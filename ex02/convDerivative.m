function [magnitude] = convDerivative(inImage)
% Computes and displays the magnitude of the
% image's 2-way derivative, using convolution.
    derX = conv2(inImage, [1 0 -1]);
    derY = conv2(inImage, [1; 0; -1]);
    derX = derX(:, 2:end-1);
    derY = derY(2:end-1, :);
    magnitude = sqrt(derX.^2 + derY.^2);
    imshow(magnitude);
end

