function [image] = IDFT2(fourierImage)
% Converts the given fourier-represented image to a regular image.
    
    [height, width] = size(fourierImage);
    image = IDFT(IDFT(fourierImage.').') ./ width;

end


