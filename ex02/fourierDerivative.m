function [magnitude] = fourierDerivative(inImage)
% Computes and displays the magnitude of the
% image's 2-way derivative, using Fourier Transform.  

    % Get the image's FT
    F = fftshift(DFT2(inImage));    
    % Calculate X derivative
    [height, width] = size(inImage);
    u = repmat(ceil(-width/2) : round(width/2 - 1), height, 1);
    derX = (2*pi*1i/width) * (IDFT2(F .* u));    
    % Calculate Y derivative
    v = repmat( (ceil(-height/2) : round(height/2 - 1))', 1, width);
    derY = (2*pi*1i/height) * (IDFT2(F .* v));
    % Combine both to get magnitude
    magnitude = sqrt(derX.^2 + derY.^2);
    imshow(magnitude, []);
    
end
