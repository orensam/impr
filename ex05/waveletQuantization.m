function [compressedImage, waveletDecompCompressed] = ...
          waveletQuantization(image, lowFilt, highFilt, levels, nQuant)
% Compress the given image using wavelet decomposition and
% optimal quantization.
    
    % Config
    quantIters = 8;
    
    % Get wavelet decomposition
    waveletDecomp = DWT(image, lowFilt, highFilt, levels);
    
    % Create row vector of WD without LL,
    % Quantize it, and then reshape it and put LL back in place
    [h, w] = size(image);
    LLHeight = h / 2^levels;
    LLWidth = w / 2^levels;
    LL = waveletDecomp(1:LLHeight, 1:LLWidth);
    
    topRightRect = waveletDecomp(1:LLHeight, (LLWidth+1):w);
    topRightSize = LLHeight * (w-LLWidth);
    bottomRect = waveletDecomp((LLHeight+1):h, 1:w);
    bottomSize = (h-LLHeight) * w;
    
    wdNew = [reshape(topRightRect, 1, topRightSize), reshape(bottomRect, 1, bottomSize)];
    
    % Go from [-0.5 .. 0.5] to [0..1], quantize, 
    % then back to original range
    minVal = min(wdNew(:));
    wdNew = wdNew - minVal;       
    %size(unique(uint8(wdNew*255)))    
    wdQuant = quantizeImage(wdNew, nQuant, quantIters);
    wdQuant = wdQuant + minVal;
    
    %size(unique(wdQuant))
    
    waveletDecompCompressed = [LL, reshape(wdQuant(1:topRightSize), LLHeight, (w-LLWidth)); ...
                               reshape(wdQuant(topRightSize+1:end), (h-LLHeight), w)];        
    
    compressedImage = IDWT(waveletDecompCompressed, lowFilt, highFilt, levels);
    
    waveletDecompInt = im2uint8(waveletDecomp);
    save('beforeCompress.mat', 'waveletDecompInt', '-v6');
    zip('beforeCompress.zip', 'beforeCompress.mat');
    waveletDecompCompressedInt = im2uint8(waveletDecompCompressed);
    save('afterCompress.mat', 'waveletDecompCompressedInt', '-v6');
    zip('afterCompress.zip', 'afterCompress.mat');
    
%     minVal = min(wdQuant(:));
%     maxVal = max(wdQuant(:));
%     figure;
%     imshow((wdQuant-minVal) / (maxVal-minVal));
    
    
end
