function [expandedImage] = expand(im, filter)
    filter = 2 * filter;    
    expandedImage = zeros(2 * size(im));
    expandedImage(1:2:end, 1:2:end) = im;
    expandedImage = conv2(conv2(expandedImage, filter, 'same'), filter', 'same');
end