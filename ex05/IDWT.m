function [image] = IDWT(waveletDecomp, lowFilt, highFilt, levels)
% Reconstructs an image from the given wavelet decomposition,
% using the given filter and amount of levels.
% Displays the resulting image.

    [height, width] = size(waveletDecomp);
    image = waveletDecomp;
    lowFilt = 2 * lowFilt;
    highFilt = 2 * highFilt(end:-1:1);
    
    h = height / (2^levels);
    w = width / (2^levels);
    
    for i = 1:levels
        
        LL = image(1:h, 1:w);
        LH = image(1:h, (w+1):w*2);
        HL = image((h+1):(h*2), 1:w);
        HH = image((h+1):(h*2), (w+1):w*2);
        
        LLnew = zeros(h*2, w);
        LLnew(2:2:end, :) = LL;
        LLnew = conv2(LLnew, lowFilt', 'same');
        
        LHnew = zeros(h*2, w);
        LHnew(2:2:end, :) = LH;
        LHnew = conv2(LHnew, highFilt', 'same');
        
        HLnew = zeros(h*2, w);
        HLnew(2:2:end, :) = HL;
        HLnew = conv2(HLnew, lowFilt', 'same');
        
        HHnew = zeros(h*2, w);
        HHnew(2:2:end, :) = HH;
        HHnew = conv2(HHnew, highFilt', 'same');
        
        L = LLnew + LHnew;
        Lnew = zeros(h*2, w*2);
        Lnew(:, 2:2:end) = L;
        Lnew = conv2(Lnew, lowFilt, 'same');
        
        H = HLnew + HHnew;
        Hnew = zeros(h*2, w*2);
        Hnew(:, 2:2:end) = H;
        Hnew = conv2(Hnew, highFilt, 'same');
        
        image(1:(h*2), 1:(w*2)) = Lnew + Hnew;
        
        h = h*2;
        w = w*2;
        
    end
    
    figure;
    imshow(image);
    
end
