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
    level1Pos = spreadOutCorners(pyr{1}, N, M, maxNum);    
    % Convert to level 3 positions
    level3Pos = 0.25 * (level1Pos - 1) + 1; % 2^(l_1 - l_2) = 2^(1 - 3) = 1/4
    
    sampleDescriptor(pyr{3}, level3Pos, DESC_RAD)
    

end