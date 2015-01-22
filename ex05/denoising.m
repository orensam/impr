function [denoiseImage] = denoising(image, lowFilt, highFilt, levels)
% Denoises the given image using DWT and displays the result.

    threshold = 0.06;
    
    [h, w] = size(image);
    
    wd = DWT(image, lowFilt, highFilt, levels);    
    
    LLHeight = h / 2^levels;
    LLWidth = w / 2^levels;    
    mask = ones(size(image));
    mask(1:LLHeight, 1:LLWidth) = 0;
    
    wd(abs(wd) < threshold & mask) = 0;
    denoiseImage = IDWT(wd, lowFilt, highFilt, levels);

    figure;
    subplot(1,2,1);
    imshow(image);
    subplot(1,2,2);
    imshow(denoiseImage);
    
end
