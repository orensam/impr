function [denoiseImage] = denoising(image, lowFilt, highFilt, levels)
% Denoises the given image using DWT and displays the result.
    
    [h, w] = size(image);
    % Threshold found by trial and error
    threshold = 0.06;            
    
    % Get wavelet representation
    wd = DWT(image, lowFilt, highFilt, levels);    
    
    % Find position of non-LL coefficients
    LLHeight = h / 2^levels;
    LLWidth = w / 2^levels;    
    mask = ones(size(image));
    mask(1:LLHeight, 1:LLWidth) = 0;
    
    % perform thresholding
    wd((abs(wd) < threshold) & mask) = 0;
    denoiseImage = IDWT(wd, lowFilt, highFilt, levels);
    
    % Display the result
    figure;
    subplot(1,2,1);
    imshow(image);
    subplot(1,2,2);
    imshow(denoiseImage);
    
end
