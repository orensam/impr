function [magnitude] = fourierDerivative(inImage)
% Computes and displays the magnitude of the
% image's 2-way derivative, using Fourier Transform.
    F = fftshift(DFT2(inImage));

    [height, width] = size(inImage);
    u = repmat(ceil(-width/2) : round(width/2 - 1), height, 1);
    derX = (2*pi*1i/width) * (IDFT2(F .* u));
    
    v = repmat( (ceil(-height/2) : round(height/2 - 1))', 1, width);
    derY = (2*pi*1i/height) * (IDFT2(F .* v));
        
    magnitude = sqrt(derX.^2 + derY.^2);
    imshow(magnitude);
end
