function [pyr, filter] = LaplacianPyramid(im, maxLevels, filterSize)
% Creates the Laplacian pyramid of the given image, returned in the pyr cell 
% array. It is calculated using the Gaussian pyramid.
% Pyramid height is at most maxLevels. Can be smaller if a reduction
% Makes the image smaller than 16*16.
% filterSize specifies the size of the blur filter for the Gaussain
% pyramid, and it is doubled for the exapnd-blur done here.
% This filter (not-doubled) is also returned.

    [gpyr, filter] = GaussianPyramid(im, maxLevels, filterSize);
    nLevels = numel(gpyr);
    pyr = cell(1, numel(gpyr));
    
    for i=1:nLevels - 1
        pyr{i} = gpyr{i} - expand(gpyr{i+1}, filter);    
    end
    pyr{nLevels} = gpyr{i+1};
    
end


