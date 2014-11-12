function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter)
    % This function recieves an image (in doubles),
    % the number of desired gray levels and the maximum number of
    % iterations.
    % Returns the quantized image, and a vector of the error in
    % each iteration. Error vector's length might be less than nIter
    % in case the error converges.
    
    % Turn image to ints, and handle RGB
    dims = ndims(imOrig);
    if (dims == 3)
        imYIQ = transformRGB2YIQ(imOrig);
        imInt = uint8(imYIQ(:,:,1) * 256);
    else
        imInt = uint8(imOrig * 256);
    end
    
    % If the image is already quantized, return it.
    if size(unique(imInt)) < nQuant
        error = -1;
        imQuant = imOrig;
        return;
    end
    
    % Get initial Z division
    Z = getInitialZ(imInt, nQuant);
    
    % Iterate Z, Q and error calculation.
    % Stop when error converges, or after nIter iterations.
    for i = 1 : nIter                
        Q = getQ(Z, imInt);
        Z = getZ(Q, Z);
        levels = getLevelsArray(Q, Z, nQuant);
        err = getError(imInt, levels);
        if i > 1 && err == error(i-1)
            % Error converges - quantization done
            break;
        end
        error(i) = getError(imInt, levels);
    end
    
    % put it into the image
    imQuant = intlut(imInt, uint8(levels));
    
    % Final handling of RGV images
    if (dims == 3)
        imYIQ(:,:,1) = double(imQuant) / 256;
        imQuant = transformYIQ2RGB(imYIQ);        
    end    
end

function [Z] = getInitialZ(imInt, nQuant)
    % Does an initial division of the image's Z values.
    [hist, ~] = imhist(imInt);
    % Accumulate the histogram, and divide evenly by nQuant.
    cumHist = cumsum(hist);
    cumHist = round( (cumHist ./ max(cumHist) .* (nQuant - 1)));
    % Put 0 and 255 at the edges.
    Z = [0; find(diff(cumHist)); 255];
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

function [err] = getError(imInt, levels)
    % Given the array that maps the Q levels,
    % Return the current error value.
    [hist, bins] = imhist(imInt);    
    err = sum(((levels' - bins).^2) .* hist);
end

function [levels] = getLevelsArray(Q, Z, nQuant)
    % Returns an array of size 255, in which
    % arr[i] = q means that gray level i maps to q.    
    [~, levels] = histc(0:255, Z);
    levels(end) = levels(end) - 1;
    levels = changem(levels, Q, 1:nQuant);
end
