function [reducedImage] = reduce(im, filter)
    % Reduces the size of the given image by 2 in each diemnsion.
    % Uses the given filter to blur the image beforehand.
    
    blurredImage = conv2(conv2(im, filter, 'same'), filter', 'same');
    reducedImage = blurredImage(1:2:end, 1:2:end);
end
