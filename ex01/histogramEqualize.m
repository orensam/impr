function [imEq, histOrig, histEq] = histogramEqualize(imOrig)   
    
    dims = ndims(imOrig);
    
    if (dims == 3)
        imYIQ = transformRGB2YIQ(imOrig);
        imInt = uint8(imYIQ(:,:,1) * 255);
    else
        imInt = uint8(imOrig * 255);
    end  
    
    [histOrig, bins] = imhist(imInt);
    cumHist = cumsum(histOrig);
    N = prod(size(imInt));
    cumHistInt = uint8( (cumHist * 255) / N);
    imEq = intlut(imInt, cumHistInt);       
    [histEq, bins] = imhist(imEq);
    imEq = double(imEq) / 255;
    
    if (dims == 3)        
        imYIQ(:,:,1) = imEq;
        imEq = transformYIQ2RGB(imYIQ);        
    end
    
end
