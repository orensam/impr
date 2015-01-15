function newImage = imReadAndConvert(filename, representation)
% This function receives an image filename and a required
% representation (1 GS, 2 RGB), and returns the image in doubles,
% after conversion of RGB to grayscale if desired.

    try
        image = imread(filename);
    catch
        newImage = 0;
        fprintf('Error: no such file\n');        
        return;
    end
    
    newImage = double(image) / 255;
    
    try
        imInfo = imfinfo(filename);
    catch
        fprintf('Error: file is not a valid image\n');
    end
    
    if strcmp(imInfo.ColorType, 'truecolor') && representation == 1
        newImage = rgb2gray(newImage);     
    end
end