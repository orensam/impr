function [fourierImage] = DFT2(image)
% Converts the given image to its fourier representation.
    %x = DFT(image(1,:))
    %rows = num2cell(image, 2);
    %rowsDFT = num2cell(cellfun(@DFT, rows), 2);
    %fourierImage = 
    
    [height, width] = size(image);
    fourierImage = DFT(DFT(image.').') .* width;

end


