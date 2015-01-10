function [ind1, ind2] = myMatchFeatures(desc1, desc2, minScore)
% MYMATCHFEATURES Match feature descriptors in desc1 and desc2.
% Arguments:
% desc1 - A kxkxn1 feature descriptor matrix.
% desc2 - A kxkxn2 feature descriptor matrix.
% minScore - Minimal match score between two descriptors required to be
% regarded as matching.
% Returns:
% ind1,ind2 - These are m-entry arrays of match indices in desc1 and desc2.
%
% Note:
% 1. The descriptors of the ith match are desc1(ind1(i)) and desc2(ind2(i)).
% 2. The number of feature descriptors n1 generally differs from n2
% 3. ind1 and ind2 have the same length.
    
    [k, ~, n] = size(desc1);
    ksq = k^2;
    desc1mat = reshape(desc1, ksq, n)';
    desc2mat = reshape(desc2, ksq, n);
    S = desc1mat * desc2mat; % n1 * n2 matrix of descriptor match scores (dot product)
    S(S < minScore) = 0;
    
    % Simple matching algorithm - every descriptor in desc1 is matched with
    % its maximal descriptor in desc2.
    ind1 = 1:n;
    ind2 = max(S, [], 2)'; % max index in each row
    
end
