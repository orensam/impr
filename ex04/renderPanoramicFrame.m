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
    
    frameNotOK = 0;
    
    n = numel(T);
    panoramaFrame = zeros(panoSize(1), panoSize(2), 3);
    centerY = ones(1, numel(imgSliceCenterX)) * size(imgs,1)/2;
    centers = [imgSliceCenterX; centerY; ones(1, numel(centerY))];
    
    
    centersT = zeros(size(centers));
    
    for i = 1:n
        centersT(:,i) = T{i} * centers(:,i);
    end
    
    centersX = centersT(1,:);
    % Calculate bounds by averaging every pair of consecutive x's.
    % Special treatment for first and last.
    bounds = (centersX + [centersX(2:end), 0]) / 2;
    bounds = bounds(1:end-1);    
    bounds = round([centersX(1) - halfSliceWidthX, ...
                    bounds, ...
                    centersX(n) + halfSliceWidthX]);
    
    for i = 1:n
        
        % Get panorama strip coordinates
        
        stripTop = 1;
        stripBottom = panoSize(1);
        stripLeft = bounds(i) + 1;
        stripRight = bounds(i+1)-1;
        
        stripWidth = stripRight - stripLeft + 1;
        stripHeight = stripBottom - stripTop + 1;        
        
        [stripX, stripY] = meshgrid(stripLeft:stripRight, stripTop:stripBottom);
         
        % Switch to M*N x 2 so we can use T
        stripCoords = [reshape(stripX, 1, stripWidth * stripHeight); ...
                       reshape(stripY, 1, stripWidth * stripHeight); ...
                       ones(1, stripWidth * stripHeight)];        
        
         
%         imgTopLeft = inv(T{i}) * [stripLeft; stripTop; 1];
%         imgBottomRight = inv(T{i}) * [stripRight; stripBottom; 1];
%         imCoordsX = imTopLeft(1):imBottomRight(1);
%         imCoordsY = imTopLeft(2):imBottomRight(2);
                
        % Apply transformation 
        imCoords = inv(T{i}) * stripCoords;
        imCoordsX = reshape(imCoords(1,:), stripHeight, stripWidth); 
        imCoordsY = reshape(imCoords(2,:), stripHeight, stripWidth);
        
        stripData = zeros(size(imCoordsX));
        % Interpolate from original image and add to the panorama
        stripData(:,:,1) = interp2(imgs(:,:,1,i), imCoordsX, imCoordsY, 'linear', 0);
        stripData(:,:,2) = interp2(imgs(:,:,2,i), imCoordsX, imCoordsY, 'linear', 0);
        stripData(:,:,3) = interp2(imgs(:,:,3,i), imCoordsX, imCoordsY, 'linear', 0);
        panoramaFrame(stripTop:stripBottom, stripLeft:stripRight, :) = stripData;
2
    end

end
