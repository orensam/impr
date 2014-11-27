function blurImage = blurInImageSpace(inImage,kernelSize)
% Blurs the given image in image space,
% using a convolution with a gaussian kernel of 
% the given size.

    % Compute binomial coefficients sequence of size kernelSize.
    % Uses the closed multiplicative formula.
    k = 1:kernelSize-1;
    coefs = [1 cumprod((kernelSize-k)./k)];
    % Create the kernel, and normalize to sum 1
    kernel = conv2(coefs, coefs');
    kernel = kernel ./ sum(kernel(:));
    % Convolve to blur the image
    blurImage = conv2(inImage, kernel, 'same');   
    imshow(blurImage);
    
end

