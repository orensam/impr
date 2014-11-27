function [] = imDisplay(filename, representation)
    % This function receives an image filename and requested represntation,
    % and shows the given image in that representation.
    
    image = imReadAndConvert(filename, representation);
    
    if image == 0
        fprintf('Error: file file conversion failed\n');
        return;
    end
    
    imshow(image);
    impixelinfo;
end