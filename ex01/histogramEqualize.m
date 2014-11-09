function [imEq, histOrig, histEq] = histogramEqualize(imOrig)   
    imInt = uint8(imOrig * 256);
    [histOrig, bins] = imhist(imInt);
    cumHist = cumsum(histOrig);    
    N = prod(size(imOrig));
    cumHistInt = uint8( (cumHist * 255) / N);
    imEq = intlut(imInt, cumHistInt);       
    [histEq, bins] = imhist(imEq);
end
