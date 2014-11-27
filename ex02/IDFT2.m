function [image] = IDFT2(fourierImage)
% Converts the given fourier-represented image to a regular image.

    % Transform the signal, normalization factor N*M
    [height, width] = size(fourierImage);
    image = IDFT(IDFT(fourierImage.').') ./ (width * height);
    
end


