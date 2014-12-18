function [reducedImage] = reduce(im, filter)    
    blurredImage = conv2(conv2(im, filter, 'same'), filter', 'same');
    reducedImage = blurredImage(1:2:end, 1:2:end);
end