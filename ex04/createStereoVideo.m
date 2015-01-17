function [stereoVid] = createStereoVideo(imgDirectory, nViews, rotate, pyrBlend)
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
    
    %% Init
    rot = false;
    if exist('rotate', 'var')
        rot = rotate;
    end
    
    blend = false;
    if exist('pyrBlend', 'var')
        blend = pyrBlend;
    end
    
    imgs = loadImages(imgDirectory);
    [imHeight, imWidth, ~, n] = size(imgs);
    
    %% Calculate transformations between given images    
    transforms = cell(1, n-1);
        
    for i = 1:(n-1)
        im1 = rgb2gray(imgs(:,:,:,i));
        im2 = rgb2gray(imgs(:,:,:,i+1));
        transforms{i} = findTransform(im2, im1, rot);
    end
    
    % Get the comulative transformations
    panoTransforms = imgToPanoramaCoordinates(transforms);
    
    %% Calculate panorama size    
    [topPad, bottomPad, leftPad, rightPad, ~, ~] = calcPad(panoTransforms);        
    
    panoHeight = ceil(imHeight + topPad + bottomPad);
    panoWidth = ceil(imWidth + leftPad + rightPad);
    
    % To use pyramids we need size divisible by 4
    if blend
        panoHeight = ceil(panoHeight / 4.0) * 4;
        panoWidth = ceil(panoWidth / 4.0) * 4;        
    end
    
    panoSize = [panoHeight, panoWidth];
    
    %% Calculate strip center for each frame
    stripWidth = imWidth / nViews;
    halfSliceWidthX = stripWidth / 2;
    centersX = halfSliceWidthX : stripWidth : imWidth;
    
    %% Iterate views and create panorama frame for each one
    okFrames = 0;
    stereoVid = struct('cdata', 1, 'colormap', cell([1 nViews]));
    for i = 1:nViews        
        imgSliceCenterX = ones(1, n) * centersX(i);
        [panoFrame, frameNotOK] = renderPanoramicFrame(panoSize, imgs, panoTransforms, ...
                                                       imgSliceCenterX, halfSliceWidthX, ...
                                                       blend);
        if frameNotOK
            fprintf('Problem in frame %d\n', i);            
        else
            okFrames = okFrames + 1;
            stereoVid(okFrames) = im2frame(panoFrame);            
        end        
    end
    
    stereoVid(okFrames+1:end) = [];
    
end