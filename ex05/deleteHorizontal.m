function [outImage] = deleteHorizontal(image, lowFilt, highFilt, levels)
% Deletes horizontal lines from a page image.
    
    [h, w] = size(image);
    
    % Get wavelet representation
    wd = DWT(image, lowFilt, highFilt, levels);
    
    % Start at the largest LH element
    top = 1;
    bottom = h/2;
    left = w/2;
    right = w;
    
    % Iterate and zero out all the LH coefficients, making horizontal
    % details disappear
    for i = 1:levels
        wd(top:bottom, left+1:right)=0;
        bottom = bottom/2;
        left = left/2;
        right = right/2;
    end
    
    % Reconstruct the image
    outImage = IDWT(wd, lowFilt, highFilt, levels);
    
    % Display the result
    figure;
    imshow(outImage);
    
end
