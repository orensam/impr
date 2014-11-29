function [image] = IDFT2(fourierImage)
% Converts the given fourier-represented image to a regular image.

    % Transform the signal, normalization with N*M done in IDFT    
    image = IDFT(IDFT(fourierImage.').');
    
end


