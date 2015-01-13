function [pos, desc] = findFeatures(pyr, maxNum)
% FINDFEATURES Detect feature points in pyramid and sample their descriptors.
% Arguments:
% pyr - Gaussian pyramid of a grayscale image having at least 3 levels.
% maxNum - Sets the maximal number of feature points to detect.
% Returns:
% pos - An nx2 matrix of [x,y] feature positions per row found in pyr. These
% coordinates are provided at the pyramid level pyr{1}.
% desc - A kxkxn feature descriptor matrix.

    N = 2;
    M = 2;
    DESC_RAD = 3;
            
    % Get corners in pyramid level 1
    pos = spreadOutCorners(pyr{1}, N, M, maxNum);
        
    % Convert to level 3 positions
    level3Pos = 0.25 * (pos - 1) + 1; % 2^(l_1 - l_2) = 2^(1 - 3) = 1/4
    
    % Fix coordinates - so that all positions can be interpolated.
    [level3Height, level3Width] = size(pyr{3});
    cols = level3Pos(:,1);
    rows = level3Pos(:,2);
    colMask = (cols > (DESC_RAD + 1)) & (cols < (level3Width - DESC_RAD));
    rowMask = (rows > (DESC_RAD + 1)) & (rows < (level3Height - DESC_RAD));
    mask = colMask & rowMask;
    level3Pos = [cols(mask), rows(mask)];    
    
    % Get the descriptors for the feature points we found
    desc = sampleDescriptor(pyr{3}, level3Pos, DESC_RAD);
    
end