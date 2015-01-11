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
    
    minMatchScore = 0.5;
    ransacIters = 1000;
    ransacInlierTol = 500;
    
    imgs = loadImages(imgDirectory);
    n = size(imgs, 3);
    transforms = cell(1, n-1);
        
    for i = 1:(n-1)
        im1 = rgb2gray(imgs(:,:,:,i));
        im2 = rgb2gray(imgs(:,:,:,i+1));
        pyr1 = GaussianPyramid(im1, 3, 3);
        pyr2 = GaussianPyramid(im2, 3, 3);
        [pos1, desc1] = findFeatures(pyr1, 100);
        [pos2, desc2] = findFeatures(pyr2, 100);        
        [ind1, ind2] = myMatchFeatures(desc1, desc2, minMatchScore);
        newPos1 = pos1(ind1,:);
        newPos2 = pos2(ind2,:);
        [T, ~] = ransacTransform(newPos1, newPos2, ransacIters, ransacInlierTol);
        transforms{i} = T;        
    end
    
    panoTransforms = imgToPanoramaCoordinates(transforms);
    
    dxs = cellfun(@(T) T(1,3), panoTransforms);
    dys = cellfun(@(T) T(2,3), panoTransforms);
    
    panoSizeX = round(size(imgs, 2) + abs(min(dxs)) + abs(max(dxs)));
    panoSizeY = round(size(imgs, 1) + abs(min(dys)) + abs(max(dys)));
    panoSize = [panoSizeX, panoSizeY];
    
    imgWidth = size(imgs, 2);
    stripWidth = round(imgWidth / nViews);
    centersX = round(stripWidth / 2) : nViews : imgWidth;
    
    stereoVid = struct;
    for i = 1:nViews
        frame = renderPanoramicFrame(panoSize, imgs, panoTransforms, centersX, stripWidth / 2);
        stereoVid(i) = im2frame(frame);
    end
    

end