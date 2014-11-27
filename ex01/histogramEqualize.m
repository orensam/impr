function [imEq, histOrig, histEq] = histogramEqualize(imOrig)   
    % This function, given an image (in doubles),
    % Equalizes its histogram (or its Y channel histogram in case
    % of color image), displays the old and new images,
    % and returns the equalized image, and the old and new
    % histograms.
    
    % Get image as ints, and handle color images
    dims = ndims(imOrig);    
    if (dims == 3)
        imYIQ = transformRGB2YIQ(imOrig);
        imInt = uint8(imYIQ(:,:,1) * 255);
    else
        imInt = uint8(imOrig * 255);
    end
    
    if imInt == 0
        % Error in conversion
        fprintf('Error: file file conversion failed\n');
        imQuant = 0;
        error = 0;
        return;
    end
    
    % Equalize the histogram according to lecture spec
    [histOrig, ~] = imhist(imInt);
    cumHist = cumsum(histOrig);
    N = numel(imInt);
    cumHistInt = uint8( (cumHist * 255) / N);
    % This is where the image values are replaced
    imEq = intlut(imInt, cumHistInt);       
    
    % Stretch histogram linearly over [0,255] (if it isn't already so)
    mini = min(imEq(:));        
    if (mini ~= 0)
        imEq = imEq - mini;
    end    
    maxi = max(imEq(:));    
    if (maxi ~= 255)
        imEq = imEq .* (255 / maxi); 
    end
    
    % Get the new histogram
    [histEq, ~] = imhist(imEq);
    
    % Handle return values and color image rebuild
    imEq = double(imEq) / 255;
    if (dims == 3)        
        imYIQ(:,:,1) = imEq;
        imEq = transformYIQ2RGB(imYIQ);        
    end
    
    % Display the old and new image
    dispImages(imOrig, imEq);
end

function [] = dispImages(imOrig, imEq)
    % Displays the original and equalized images side by side.
    hFig = figure(1);
    set(hFig, 'Position', [0 0 1000 1000])
    
    subplot(1,2,1);
    imshow(imOrig);
    title('Original Image');
    subplot(1,2,2);
    imshow(imEq);
    title('Equalized Image');
end