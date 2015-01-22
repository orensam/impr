function [waveletDecomp] = DWT(image, lowFilt, highFilt, levels)
% Decomposes the given image into its wavelet representation,
% using the given filters. <levels> decompositions are performed.
% Displays the resulting decomposition.
    
    [height, width] = size(image);
    waveletDecomp = zeros(size(image));
    LL = image;
    
    for i = 1:levels        
        
        L = conv2(LL, lowFilt, 'same');
        L = L(:,1:2:end);
        
        H = conv2(LL, highFilt, 'same');        
        H = H(:,1:2:end);
        
        LL = conv2(L, lowFilt', 'same');
        LL = LL(1:2:end, :);
        
        LH = conv2(L, highFilt', 'same');
        LH = LH(1:2:end, :);
        
        HL = conv2(H, lowFilt', 'same');
        HL = HL(1:2:end, :);
        
        HH = conv2(H, highFilt', 'same');
        HH = HH(1:2:end, :);    
        
        waveletDecomp(1:height/2, (width/2+1):width) = LH;
        waveletDecomp((height/2+1):height, 1:width/2) = HL;
        waveletDecomp((height/2+1):height, (width/2+1):width) = HH;
        
        height = height / 2;
        width = width / 2;                
    
    end
    
    waveletDecomp(1:height, 1:width) = LL;
    
    minVal = min(waveletDecomp(:));
    maxVal = max(waveletDecomp(:));
    figure;
    imshow((waveletDecomp-minVal) / (maxVal-minVal));
    
end






