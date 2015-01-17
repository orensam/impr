function [imBlend] = pyramidBlendingRGB(im1, im2, mask, maxLevels, filterSizeIm, filterSizeMask)
    % Blends the two given RGB images, using the given mask.
    % Blends each channel independently.
    
    imBlend = zeros(size(im1));
    for i = 1:3
        imBlend(:,:,i) = pyramidBlending(im1(:,:,i), im2(:,:,i), ...
                                        mask, maxLevels, filterSizeIm, filterSizeMask);
    end
    
end
