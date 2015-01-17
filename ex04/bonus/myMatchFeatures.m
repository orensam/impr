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
    
    % Get sizes
    [k, ~, n1] = size(desc1);
    [~, ~, n2] = size(desc2);    
    ksq = k^2;
    
    % Reshape desc1 - every row is a descriptor
    desc1mat = reshape(desc1, ksq, n1)';
    % Reshape desc2 - every column is a descriptor
    desc2mat = reshape(desc2, ksq, n2);
    % S is an n1xn2 matrix of descriptor match scores (dot product)
    S = desc1mat * desc2mat;
    % Leave S only with values higher than the threshold
    S(S < minScore) = 0;
    
    % Initialize matching indices lists
    ind1 = zeros(1, n1);
    ind2 = zeros(1, n1);
    
    % Match descriptors when entry value is both
    % a row and a column maximum
    counter = 0;
    for i = 1:n1
        [maxVal, maxCol] = max(S(i,:));
        if maxVal > 0 && maxVal == max(S(:,maxCol))
            counter = counter + 1;
            ind1(counter) = i;
            ind2(counter) = maxCol;
        end
    end
    ind1 = ind1(1:counter);
    ind2 = ind2(1:counter);
    
end
