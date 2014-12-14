function [pyr, filter] = LaplacianPyramid(im, maxLevels, filterSize)
    filter = getFilter(filterSize);
    pyr{1} = expand(im, filter);
end

function [expandedImage] = expand(im, filter)
    filter = 2 * filter;
    kernel = filter' * filter;
    [height, width] = size(im);
    im = reshape(im, 1, height * width);
    places = repmat([true false; false false], height, width);
    expandedImage = zeros(height * 2, width * 2);
    expandedImage(places) = im;
    expandedImage = conv2(expandedImage, kernel, 'same');
end