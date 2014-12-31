function [pos, desc] = findFeatures(pyr, maxNum)
% FINDFEATURES Detect feature points in pyramid and sample their descriptors.
% Arguments:
% pyr − Gaussian pyramid of a grayscale image having at least 3 levels.
% maxNum − Sets the maximal number of feature points to detect.
% Returns:
% pos − An nx2 matrix of [x,y] feature positions per row found in pyr. These
% coordinates are provided at the pyramid level pyr{1}.
% desc − A kxkxn feature descriptor matrix.

    N = 8;
    M = 8;
    DESC_RAD = 3;
            
    % Get corners in pyramid level 1
    pos = spreadOutCorners(pyr{1}, N, M, maxNum);
        
    % Convert to level 3 positions
    level3Pos = 0.25 * (pos - 1) + 1; % 2^(l_1 - l_2) = 2^(1 - 3) = 1/4
    
    % Fix coordinates - so that all positions can be interpolated.
    [height, width] = size(pyr{3});    
    posX = level3Pos(:,1);
    posY = level3Pos(:,2);
    xMask = (posX > (DESC_RAD + 1)) & (posX < (width - DESC_RAD));
    yMask = (posY > (DESC_RAD + 1)) & (posY < (height - DESC_RAD));
    mask = xMask & yMask;
    level3Pos = [posX(mask), posY(mask)];
    
    % Get the descriptors for the feature points we found
    desc = sampleDescriptor(pyr{3}, level3Pos, DESC_RAD);
    
end