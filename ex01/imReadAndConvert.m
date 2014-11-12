function newImage = imReadAndConvert(filename, representation)
    % This function receives an image filename and a required
    % representation (1 GS, 2 RGB), and returns the image in doubles,
    % after conversion of RGB to grayscale if desired.
    image = imread(filename);
    newImage = double(image) / 255;
    imInfo = imfinfo(filename);
    
    if strcmp(imInfo.ColorType, 'truecolor') && representation == 1
        newImage = rgb2gray(newImage);     
    end
end