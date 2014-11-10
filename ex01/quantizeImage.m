function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter)  
    dims = ndims(imOrig);
    if (dims == 3)
        imYIQ = transformRGB2YIQ(imOrig);
        imInt = uint8(imYIQ(:,:,1) * 256);
    else
        imInt = uint8(imOrig * 256);
    end
    
    for i = 1 : nIter
        [h, bins] = imhist(imInt);
        ch = cumsum(h);
        a = round(ch * 16 / max(ch))
        
    end
    
    
    if (dims == 3)
        imYIQ(:,:,1) = double(imEq) / 256;
        imEq = transformYIQ2RGB(imYIQ);        
    end
    
end

function [Q] = getQ(Z, nQuants)    
    
    return 
end

function [Z]  =getZ(Q)
    
end



