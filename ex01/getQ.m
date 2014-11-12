function [Q] = getQ(Z, nQuants, imInt)
    Q = zeros(1, nQuants);
    [hist, bins] = imhist(imInt);
    zhz = bins .* hist;    
    for i = 1:nQuants
        Q(i) = sum( zhz(Z(i)+1:Z(i+1)+1) ) / sum(hist(Z(i)+1:Z(i+1)+1));
    end    
end