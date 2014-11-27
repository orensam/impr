function [fourierImage] = DFT2(image)
% Converts the given image to its fourier representation.

    % Transform the signal, no normalization
    fourierImage = DFT(DFT(image.').');
    
end


