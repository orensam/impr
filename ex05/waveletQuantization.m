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
    wdQuant = quantizeImage(wdNew, nQuant, quantIters);
    wdQuant = wdQuant + minVal;    
    
    % Now we can get the actual compressed wavelet, and perform inverse DWT
    % to get the compressed image.
    waveletDecompCompressed = [LL, reshape(wdQuant(1:topRightSize), LLHeight, (w-LLWidth)); ...
                               reshape(wdQuant(topRightSize+1:end), (h-LLHeight), w)];            
    compressedImage = IDWT(waveletDecompCompressed, lowFilt, highFilt, levels);
    
    % Save both wavelets to files
    saveWave(waveletDecomp, LLHeight, LLWidth, 'beforeCompress.mat');
    saveWave(waveletDecompCompressed, LLHeight, LLWidth, 'afterCompress.mat');
    
    % Display the result
    figure;
    imshow(compressedImage);
    
end

function saveWave(wave, LLHeight, LLWidth, fn)
% Converts the given wavelet to integers and save it to file <fn>
% Uses the given LL height/width to decide which areas have which
% ranges of values
    mask = true(size(wave));
    mask(1:LLHeight, 1:LLWidth) = false;
    % Normalize the non-LL parts to 0..1    
    wave(mask) = wave(mask) + 0.5;
    % convert to integer, save and zip
    wave = uint8(wave * 255);
    save(fn, 'wave', '-v6');
    gzip(fn);    
end
