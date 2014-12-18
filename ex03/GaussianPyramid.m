function [pyr, filter] = GaussianPyramid(im, maxLevels, filterSize)
    % Creates the Gassian pyramid of the given image, returned in the pyr cell 
    % array. 
    % Pyramid height is at most maxLevels. Can be smaller if a reduction
    % Makes the image smaller than 16*16.
    % filterSize specifies the size of the Gaussian filter used in the reduce
    % process. This filter is also returned.
    
    % Calculate number of levels so we don't reach an image size
    % less than 16x16
    nLevels = min(maxLevels, log2(min(size(im)))-3);
    pyr = cell(1, nLevels);
    filter = getFilter(filterSize);
        
    for i = 1:nLevels        
        pyr{i} = im;        
        im = reduce(im, filter);
    end
    
end
