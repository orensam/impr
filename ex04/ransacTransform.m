function [T, inliers] = ransacTransform(pos1, pos2, numIters, inlierTol, rotate)
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
    
    % Config
    rot = false;
    if exist('rotate', 'var')
        rot = rotate;
    end
    
    % Sizes
    n = size(pos1, 1);
    
    % Initialize empty inliers list
    inliers = [];
    
    % Perform RANSAC iterations
    for i = 1:numIters        
        
        % 1. Estimnate transformation using one randon point
        if rot
            p = randi(n, 1, 2);
        else
            p = randi(n);
        end
        tmpT = buildT(pos1(p,:), pos2(p,:), rot);
        
        % 2. Transform pos1 using the estimated transformation,
        %    (using homogenous coordinates).
        pos1T = (tmpT * [pos1'; ones(1, n)]);
        pos1T = (pos1T(1:2,:) ./ repmat(pos1T(3,:),2,1))';
        %pos1T = pos1T(1:2,:)';        
        
        % 3. Calculate squared equclidean distance and update inliers if
        %    needed
        E = sum((pos2 - pos1T).^2, 2); 
        tmpInliers = find(E<inlierTol);        
        if numel(tmpInliers) > numel(inliers)
            inliers = tmpInliers;
        end
        
    end    
    T = buildT(pos1(inliers,:), pos2(inliers,:), rot);
    
end

function T = buildT(pos1, pos2, rot)
% Estimate transformation according to 
    if rot        
        % Create the equation system.
        % in case of two source points [x1, y1], [x2, y2]
        % and two destination points [x'1, y'1], [x'2, y'2]
        % So we have a system of the form M * x = r:
        %     x1 -y1 1 0     a     x'1
        %     x2 -y2 1 0  *  b  =  x'2
        %     y1  x1 0 1     c     y'1
        %     y2  x2 0 1     d     y'2
        % And we solve for [a, b, c, d].
        %
        % 2 source and destination points give us 4 equations, so
        % that should suffice for the 4 unknowns.
        % if given k>2 points, M has 2*k rows, i.e we have 2*k>4 equations
        % with 4 unknowns - an overdetermined system. Matlab will
        % automagically give us a solution which minimizes the squared
        % error.
                
        numPoints = size(pos1, 1);        
        M = [pos1(:,1), -pos1(:,2), ones(numPoints, 1), zeros(numPoints, 1);
             pos1(:,2),  pos1(:,1), zeros(numPoints, 1), ones(numPoints, 1)];
        r = [pos2(:,1);
             pos2(:,2)];
                
        if rank(M) < min(size(M))
            % M is singular (uninvertible) - cannot solve
            avgDiffs = mean(pos2 - pos1, 1);
            T = eye(3);
            T(1,3) = avgDiffs(1);
            T(2,3) = avgDiffs(2);
            return;
        end
        % x = [a,b,c,d] = [cos(w), sin(w), dx, dy], where w is the rotation
        % angle
        x = M\r;         
                
        T = [x(1), x(2), x(3);
             -x(2), x(1), x(4);
             0,     0,    1];
         
    else
        avgDiffs = mean(pos2 - pos1, 1);
        T = eye(3);
        T(1,3) = avgDiffs(1);
        T(2,3) = avgDiffs(2);
    end
    
end
