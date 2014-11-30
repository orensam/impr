function blurImage = blurInFourierSpace(inImage, kernelSize)
% Blurs the given image in Fourier space,
% using a pointwise multiplication with a gaussian kernel of 
% the given size.
    
    % Compute binomial coefficients sequence of size kernelSize.
    % Uses the closed multiplicative formula.  
    k = 1:kernelSize-1;
    coefs = [1 cumprod((kernelSize-k)./k)];
    % Create the kernel, and normalize to sum 1
    kernel = conv2(coefs, coefs');
    kernel = kernel ./ sum(kernel(:));  
    % Pad the kernel with zeros to match image size
    [height, width] = size(inImage);
    kernelBig = zeros(height, width);
    midRow = ceil(height/2);
    midCol = ceil(width/2);
    kernelBig(midRow-floor(kernelSize/2):midRow+floor(kernelSize/2), ...
              midCol-floor(kernelSize/2):midCol+floor(kernelSize/2)) = kernel;
    % Compute DFT of image and kernel
    F = DFT2(inImage);
    G = DFT2(fftshift(kernelBig));
    % Blur by pointwise multiplication, and go back to image space    
    blurImage = IDFT2(F .* G);     
    imshow(real(blurImage));
    
end

