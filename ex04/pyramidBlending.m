function [imBlend] = pyramidBlending(im1, im2, mask, maxLevels, filterSizeIm, filterSizeMask)
    % Blends the two given images using the pyramid method, with the given
    % mask deciding on the which areas to use from which image.
    
    [lpyr1, filter] = LaplacianPyramid(im1, maxLevels, filterSizeIm);
    [lpyr2, ~] = LaplacianPyramid(im2, maxLevels, filterSizeIm);
    
    [mpyr, ~] = GaussianPyramid(mask, maxLevels, filterSizeMask);
    
    nLevels = numel(lpyr1);
    respyr = cell(1, nLevels);
    for k = 1:nLevels
        respyr{k} = mpyr{k} .* lpyr1{k} + (1-mpyr{k}) .* lpyr2{k};
    end
    
    imBlend = LaplacianToImage(respyr, filter, ones(1, nLevels));
    
end
