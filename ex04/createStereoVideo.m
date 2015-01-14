function [stereoVid] = createStereoVideo(imgDirectory, nViews)
%
% This function gets an image directory and create a stereo movie with
% nViews. It does the following:
%
% 1. Match transform between pairs of images.
% 2. Convert the transfromations to a common coordinate system.
% 3. Determine the size of each panoramic frame.
% 4. Render each view.
% 5. Create a movie from all the views.
%
% Arguments:
% imgDirectory - A string with the path to the directory of the images
% nViews - The number of views to extract from each image
%
% Returns:
% stereoVid - a movie which includes all the panoramic views
%
    
    %% Calculate transformations between given images
    minMatchScore = 0.5;
    ransacIters = 1000;
    ransacInlierTol = 20;
    maxPoints = 400;
    
    imgs = loadImages(imgDirectory);
    [imHeight, imWidth, ~, n] = size(imgs);
    transforms = cell(1, n-1);
        
    for i = 1:(n-1)
        im1 = rgb2gray(imgs(:,:,:,i));
        im2 = rgb2gray(imgs(:,:,:,i+1));
        pyr1 = GaussianPyramid(im1, 3, 3);
        pyr2 = GaussianPyramid(im2, 3, 3);
        [pos1, desc1] = findFeatures(pyr1, maxPoints);
        [pos2, desc2] = findFeatures(pyr2, maxPoints);        
        [ind1, ind2] = myMatchFeatures(desc1, desc2, minMatchScore);
        newPos1 = pos1(ind1,:);
        newPos2 = pos2(ind2,:);
        [T, ~] = ransacTransform(newPos2, newPos1, ransacIters, ransacInlierTol);        
        transforms{i} = T;
    end
    
    % Get the comulative transformations
    panoTransforms = imgToPanoramaCoordinates(transforms);
    
    %% Calculate panorama size
    dxs = cellfun(@(T) T(1,3), panoTransforms)
    dys = cellfun(@(T) T(2,3), panoTransforms)    
    
    topPixels = abs(min(dys(find(dys<0))));
    bottomPixels = max(dys(find(dys>0)));
    leftPixels = abs(min(dxs(find(dxs<0))));
    rightPixels = max(dxs(find(dxs>0)));
    
    panoHeight = imHeight;
    panoWidth = imWidth;    
    
    if ~isempty(topPixels)
        panoHeight = panoHeight + topPixels;
    end
    if ~isempty(bottomPixels)
        panoHeight = panoHeight + bottomPixels;
    end
    
    if ~isempty(leftPixels)
        panoWidth = panoWidth + leftPixels;
    end
    if ~isempty(rightPixels)
        panoWidth = panoWidth + rightPixels;
    end
    
    panoHeight = ceil(panoHeight);
    panoWidth = ceil(panoWidth);
    
    panoSize = [panoHeight, panoWidth];
    
    %% Calculate strip center for each frame
    stripWidth = round(imWidth / nViews);
    centersX = round(stripWidth / 2) : stripWidth : imWidth;        
    
    %% Iterate views and create panorama frame for each one
    stereoVid = struct('cdata', 1, 'colormap', cell([1 nViews]));
    for i = 1:nViews
        imgSliceCenterX = ones(1, n) * centersX(i);
        [panoFrame, frameNotOK] = renderPanoramicFrame(panoSize, imgs, panoTransforms, ...
                                                       imgSliceCenterX, stripWidth / 2);
        if frameNotOK
            fprintf('Problem in frame %d\n', i);
        else
            stereoVid(i) = im2frame(panoFrame);
        end        
    end
    
end