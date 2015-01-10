function [panoramaFrame, frameNotOK] = ...
          renderPanoramicFrame(panoSize, imgs, T, imgSliceCenterX, halfSliceWidthX)
%
% The function renders a panoramic frame. It does the following:
% 1. Convert centers into panorama coordinates and find optimal width of
% each strip.
% 2. Backwarpping each strip from image to the panorama frames
%
% Arguments:
% panoSize - [yWidth, xWidth] of the panorama frame
% imgs - The set of M images
% T - The set of transformations (cell array) from each image to
% the panorama coordinates
% imgSliceCenterX - A vector of 1xM with the required center of the strip
% in each of the images. This is given in image coordinates.
% sliceWidth - The suggested width of each strip in the image
%
% Returns:
% panoramaFrame - the rendered frame
% frameNotOK - in case of errors in rednering the frame, it is true.

    n = numel(T);
    panoramaFrame = zeros(panoSize);
    centerY = ones(numel(imgSliceCenterX)) * size(imgs,1)/2;
    centers = [imgSliceCenterX; centerY; ones(numel(centerY))];
    
    centersT = zeros(size(centers));
    for i = 1:n
        centersT(:,i) = T{i} * centers;
    end
    
    centersX = centersT(1,:);
    % Calculate bounds by averaging every pair of consecutive x's.
    % Special treatment for first and last.
    bounds = (centersX + [centersX(2:end), 0]) / 2;
    bounds = bounds(1:end-1);    
    bounds = [centersX(1) - halfSliceWidthX, ...
              bounds, ...
              centersX(n) + halfSliceWidthX];
    
    for i = 1:n
        
        % Get panorama strip coordinates
        stripWidth = bounds(i+1) - bounds(i);
        stripHeight = panoSize(1);        
        [stripX, stripY] = meshgrid( bounds(i):(bounds(i+1)-1), 1:panoSize(1));
        
        % Switch to M*N x 2 so we can use T
        stripCoords = [reshape(stripX, 1, stripWidth * stripHeight); ...
                       reshape(stripY, 1, stripWidth * stripHeight)];
        
        % Apply transformation 
        imCoords = inv(T{i}) * stripCoords;
        imCoordsX = reshape(imCoords(1,:), stripHeight, stripWidth); 
        imCoordsY = reshape(imCoords(2,:), stripHeight, stripWidth);
        
        % Interpolate from original image and add to the panorama
        stripData = interp2(imgs(:,:,:,i), imCoordsX, imCoordsY);
        panoramaFrame = [panoramaFrame, stripData];
        
    end
    
end
