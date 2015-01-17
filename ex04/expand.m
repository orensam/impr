function [expandedImage] = expand(im, filter)
    % Expands the size of the given image by 2 in each diemnsion.
    % Uses the given filter to blur the image afterwords.
    
    filter = 2 * filter;    
    expandedImage = zeros(2 * size(im));
    expandedImage(1:2:end, 1:2:end) = im;
    expandedImage = conv2(expandedImage, filter, 'same');
    expandedImage = conv2(expandedImage, filter', 'same');
end