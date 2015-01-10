function [T, inliers] = ransacTransform(pos1, pos2, numIters, inlierTol)
% Fit transform to maximal inliers given point matches
% using the RANSAC algorithm.
%
% Arguments:
% pos1, pos2 - Two nx2 matrices containing n rows of [x,y] coordinates of
% matched points.
% numIters - Number of RANSAC iterations to perform.
% inlierTol - inlier tolerance threshold. When determining if a given match,
% e.g. between pos1(i,:) and pos2(i,:), is an inlier match, the squared euclidean
% distance between the transformed pos1(i,:) and pos2(i,:) is computed and
% compared to inlierTol. Matches having this squared distance smaller than
% inlierTol are treated as inliers.
%
% Returns:
% T - A 3x3 matrix, where T(1,3) is dX and T(2,3) is dY.
% inliers - An array containing the indices in pos1/pos2 of the maximal set of
% inlier matches found.
%
% Description:
% To determine if a given match, e.g. between pos1(i,:) and pos2(i,:), is an
% inlier match, the squared euclidean distance between the transformed pos1(i,:)
% and pos2(i,:) is computed and compared to inlierTol. Matches having this squared
% distance smaller than inlierTol are deemed inliers.

    n = size(pos1, 1);
       
    inliers = [];
    for i = 1:numIters
        
        % Estimnate transformation using one randon point
        p = randi(n);
        p1 = pos1(p,:);
        p2 = pos2(p,:);
        tmpT = buildT(p1(1)-p2(1), p1(2)-p2(2));
        
        % Transform pos1, using homogenous coordinates.
        % Then renormalize to regular coordinates.
        pos1T = (tmpT * [pos1'; ones(1, n)]);
        pos1T = pos1T(1:2,:)';
        %pos1T = (pos1T(1:2,:) ./ [pos1T(3,:); pos1T(3,:)])';        
        
        % Calculate squared equclidean distance and update inliers if
        % needed
        E = sum((pos2 - pos1T).^2, 2); 
        tmpInliers = find(E<inlierTol);        
        if numel(tmpInliers) > numel(inliers)
            inliers = tmpInliers;
        end
        
    end
    
    % Re-evaluate T
    pos1new = pos1(inliers,:);
    pos2new = pos2(inliers,:);    
    posdiffs = pos1new - pos2new;    
    avgdx = mean(posdiffs(:,1));
    avgdy = mean(posdiffs(:,2));    
    T = buildT(avgdx, avgdy);
    
end

function T = buildT(dx, dy)
    T = eye(3);
    T(1, 3) = dx;
    T(2, 3) = dy;
end