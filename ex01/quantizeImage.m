function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter)  
    dims = ndims(imOrig);
    if (dims == 3)
        imYIQ = transformRGB2YIQ(imOrig);
        imInt = uint8(imYIQ(:,:,1) * 256);
    else
        imInt = uint8(imOrig * 256);
    end
    
    Z = getInitialZ(imInt, nQuant)
    
    for i = 1 : nIter                
        Q = getQ(Z, imInt);
        Z = getZ(Q, Z);
    end    
    Q = round(Q);
    
    % put it into the image
    [~, reparr] = histc(0:255, Z);
    reparr(end) = reparr(end) - 1;
    reparr = changem(reparr, Q, 1:nQuant);
    imQuant = intlut(imInt, uint8(reparr));
    
    error = 0;
    
    if (dims == 3)
        imYIQ(:,:,1) = double(imQuant) / 256;
        imQuant = transformYIQ2RGB(imYIQ);        
    end
    
end

function [Z] = getInitialZ(imInt, nQuant)
    [hist, bins] = imhist(imInt);
    cumHist = cumsum(hist)
    cumHist = round( (cumHist ./ max(cumHist) .* (nQuant - 1)))
    diffs = find(diff(cumHist));
    Z = [0, find(diff(cumHist))', 255];
end

function [Q] = getQ(Z, imInt)
    % Create Q according to the given Z.
    % Uses histc and accumarray to make the summation
    % in the Z_i formula.
    [hist, bins] = imhist(imInt);
    zhz = (bins .* hist)'; % zhz_i = z_i*h(z_i)
    [~, reparr] = histc(0:255, Z); 
    reparr(end) = reparr(end) - 1;
    Q = accumarray(reparr', zhz) ./ accumarray(reparr', hist);

end

function [Z] = getZ(Q, curZ)
    % Keep start and end of Z at 0 and 255 respectively,
    % and tune the middle according to given Q
    Z = curZ(:);
    Z(2:end-1) = round(mean([Q(1:end-1), Q(2:end)]'));
end



