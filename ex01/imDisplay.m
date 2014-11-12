function [] = imDisplay(filename, representation)
    % This function receives an image filename and requested represntation,
    % and shows the given image in that representation.
    image = imReadAndConvert(filename, representation);    
    imshow(image);
    impixelinfo;
end