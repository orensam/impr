function newImage = imReadAndConvert(filename, representation)
    image = imread(filename);
    newImage = double(image) / 255;
    imInfo = imfinfo(filename);
    
    if strcmp(imInfo.ColorType, 'truecolor') && representation == 1
        newImage = rgb2gray(newImage);     
    end
end

function [] = imDisplay(filename, representation)
    image = imReadAndConvert(filename, representation);
    imshow(image);
end