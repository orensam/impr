function [pyr, filter] = GaussianPyramid(im, maxLevels, filterSize)
% Creates the Gassian pyramid of the given image, returned in the pyr cell 
% array. 
% Pyramid height is at most maxLevels. Can be smaller if a reduction
% Makes the image smaller than 16*16.
% filterSize specifies the size of the Gaussian filter used in the reduce
% process. This filter is also returned.
    
    pyr = {};
    filter = getFilter(filterSize);
        
    for i = 1:maxLevels
        if numel(im) < 16^2
            break;
        end        
        pyr{i} = im;        
        im = reduce(im, filter);
    end
    
end

function [reducedImage] = reduce(im, filter)    
    kernel = filter' * filter;
    blurredImage = conv2(im, kernel, 'same');    
    [height, width] = size(blurredImage);
    places = repmat([true false; false false], height/2, width/2);
    reducedImage = reshape(blurredImage(places), height/2, width/2);
end
