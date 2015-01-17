function [panoramaFrame, frameNotOK] = ...
          renderPanoramicFrame(panoSize, imgs, T, imgSliceCenterX, halfSliceWidthX, pyrBlend)
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
    
    blend = false;
    if exist('pyrBlend', 'var')
        blend = pyrBlend;
    end
            
    %% Boundary calculation
    [imHeight, ~, ~, n] = size(imgs);
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
    bounds = ceil([centersX(1) - halfSliceWidthX, ...
                   bounds, ...
                   centersX(n) + halfSliceWidthX]);
    
    if blend
        [panoramaFrame, frameNotOK] = createBlendedFrame(panoSize, imgs, T, bounds);
    else
        [panoramaFrame, frameNotOK] = createFrame(panoSize, imgs, T, bounds);
    end
        
end

%%
function [panoramaFrame, frameNotOK] = createBlendedFrame(panoSize, imgs, T, bounds)
% Create a panorama frame blended from the odd and even images,
% according to the given transformations and bounds.
    
    panoramaFrame = [];
    panoHeight = panoSize(1);
    panoWidth = panoSize(2);
    
    % Get the odd and even frames
    [oddPanoFrame, frameNotOK] = createFrame(panoSize, ...
                                             imgs(:,:,:,1:2:end), ...
                                             T(1:2:end), ...
                                             [bounds(1:2:end-1), bounds(end)]);
    if frameNotOK
        return;
    end
                                         
    [evenPanoFrame, frameNotOK] = createFrame(panoSize, ...
                                             imgs(:,:,:,2:2:end), ...
                                             T(2:2:end), ...
                                             [bounds(2:2:end-1), bounds(end)]);
    if frameNotOK
        return;
    end
    
    % Create mask
    mask = zeros(1, panoWidth);
    for i = 1:2:(numel(bounds)-1)
        mask(bounds(i)+1:bounds(i+1)) = 1;
    end
    mask = repmat(mask, panoHeight, 1);    
        
    % Blend
    panoramaFrame = pyramidBlendingRGB(oddPanoFrame, evenPanoFrame, mask, 3, 5, 5);
    panoramaFrame(panoramaFrame<0) = 0;
    panoramaFrame(panoramaFrame>1) = 1;
    
end

%%
function [panoramaFrame, frameNotOK] = createFrame(panoSize, imgs, T, bounds)
% Create a single panoramic frame from the given images,
% transformations and bounds.

    frameNotOK = false;
    [imHeight, imWidth, ~, n] = size(imgs);
    panoHeight = panoSize(1);
    panoWidth = panoSize(2);
    
    [topPad, ~, ~, ~, ~, dys] = calcPad(T);
    
    % Init pano frame
    panoramaFrame = zeros(panoHeight, panoWidth, 3);
    
    for i = 1:n

        % Get panorama strip coordinates
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
        
        % Check frameNotOK - if we exceed image x bounds
        minX = min(imCoordsX(1,:));
        maxX = max(imCoordsX(1,:));        
        if minX < 1 || maxX > imWidth
            frameNotOK = true;
            return;
        end
        
        % Interpolate from original image and add to the panorama
        stripData = zeros(stripHeight, stripWidth, 3);        
        stripData(:,:,1) = interp2(imgs(:,:,1,i), imCoordsX, imCoordsY, 'linear', 0);
        stripData(:,:,2) = interp2(imgs(:,:,2,i), imCoordsX, imCoordsY, 'linear', 0);
        stripData(:,:,3) = interp2(imgs(:,:,3,i), imCoordsX, imCoordsY, 'linear', 0);
        
        panoramaFrame(stripTop:stripBottom, stripLeft:stripRight, :) = stripData;

    end

end
