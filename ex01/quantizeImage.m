function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter)  
    dims = ndims(imOrig);
    if (dims == 3)
        imYIQ = transformRGB2YIQ(imOrig);
        imInt = uint8(imYIQ(:,:,1) * 256);
    else
        imInt = uint8(imOrig * 256);
    end
    
    for i = 1 : nIter
        
    end
    
    
    if (dims == 3)
        imYIQ(:,:,1) = double(imEq) / 256;
        imEq = transformYIQ2RGB(imYIQ);        
    end
    
end