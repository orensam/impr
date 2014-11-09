function [] = imDisplay(filename, representation)
    image = imReadAndConvert(filename, representation);
    imshow(image);
end