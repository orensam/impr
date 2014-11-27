function [magnitude] = convDerivative(inImage)
% Computes and displays the magnitude of the
% image's 2-way derivative, using convolution.
    
    % X derivative
    derX = conv2(inImage, [1 0 -1], 'same');
    % Y derivative
    derY = conv2(inImage, [1; 0; -1], 'same');
    % Calculate magnitude
    magnitude = sqrt(derX.^2 + derY.^2);
    imshow(magnitude);
    
end

