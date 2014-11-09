function [imEq, histOrig, histEq] = histogramEqualize(imOrig)   
    
    dims = ndims(imOrig);
    
    if (dims == 3)
        imYIQ = transformRGB2YIQ(imOrig);
        imInt = uint8(imYIQ(:,:,1) * 256);
    else
        imInt = uint8(imOrig * 256);
    end  
    
    [histOrig, bins] = imhist(imInt);
    cumHist = cumsum(histOrig);    
    N = prod(size(imOrig));
    cumHistInt = uint8( (cumHist * 255) / N);
    imEq = intlut(imInt, cumHistInt);       
    [histEq, bins] = imhist(imEq);
    
    if (dims == 3)        
        imYIQ(:,:,1) = double(imEq) / 256;
        imEq = transformYIQ2RGB(imYIQ);        
    end
    
end
