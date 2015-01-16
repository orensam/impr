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
    
    frameNotOK = false;
    
    % Sizes
    [imHeight, ~, ~, n] = size(imgs);
    panoHeight = panoSize(1);
    panoWidth = panoSize(2);    
    
    % Init pano frame
    panoramaFrame = zeros(panoHeight, panoWidth, 3);
    
    % Handle centers
    centersY = ones(1, n) * imHeight/2;
    centers = [imgSliceCenterX; centersY; ones(1, n)];
    
    centersT = zeros(size(centers));
    
    for i = 1:n
        centersT(:,i) = T{i} * centers(:,i);
    end
    
    centersX = centersT(1,:);
    
    % Calculate bounds by averaging every pair of consecutive x's.
    % Special treatment for first and last.
    bounds = (centersX(1:end-1) + centersX(2:end)) / 2;
    %bounds = bounds(1:end-1);    
    bounds = ceil([centersX(1) - halfSliceWidthX, ...
                   bounds, ...
                   centersX(n) + halfSliceWidthX]);    
    
    [topPad, ~, ~, ~, ~, dys] = calcPad(T);
    
    for i = 1:n

        % Get panorama strip coordinates
        %verticalShift = 0;%ceil(-1 * dys(i));                
        stripTop = max(1, ceil(topPad + dys(i)));
        stripBottom = stripTop + imHeight;
        stripBounds =  [max([1, bounds(i)]), bounds(i+1)-1];
        stripLeft = min(stripBounds);
        stripRight = max(stripBounds);

        stripWidth = stripRight - stripLeft + 1;
        stripHeight = stripBottom - stripTop + 1;        
        
        [stripX, stripY] = meshgrid(stripLeft:stripRight, stripTop:stripBottom);        
         
        % Switch to M*N x 2 so we can use T
        stripCoords = [reshape(stripX, 1, stripWidth * stripHeight); ...
                       reshape(stripY, 1, stripWidth * stripHeight); ...
                       ones(1, stripWidth * stripHeight)];                         
                
        % Apply transformation 
        imCoords = inv(T{i}) * stripCoords;
        imCoords = imCoords(1:2,:) ./ repmat(imCoords(3,:),2,1);
        imCoordsX = reshape(imCoords(1,:), stripHeight, stripWidth); 
        imCoordsY = reshape(imCoords(2,:), stripHeight, stripWidth) - topPad;        
        
        stripData = zeros(stripHeight, stripWidth, 3);
        % Interpolate from original image and add to the panorama
        stripData(:,:,1) = interp2(imgs(:,:,1,i), imCoordsX, imCoordsY, 'linear', 0);
        stripData(:,:,2) = interp2(imgs(:,:,2,i), imCoordsX, imCoordsY, 'linear', 0);
        stripData(:,:,3) = interp2(imgs(:,:,3,i), imCoordsX, imCoordsY, 'linear', 0);
        
        panoramaFrame(stripTop:stripBottom, stripLeft:stripRight, :) = stripData;

    end

end
