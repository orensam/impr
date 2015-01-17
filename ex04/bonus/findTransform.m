function [T] = findTransform(im1, im2, rotate)
% This function recieves two grayscale images im1, im2
% and calculates the transformation from im1 to im2.
    
    %% Config
    rot = true;
    if exist('rotate', 'var')
        rot = rotate;
    end
    
    minMatchScore = 0.5;
    ransacIters = 1000;
    ransacInlierTol = 2;
    maxPoints = 800;
    
    %% Find the transformation
    pyr1 = GaussianPyramid(im1, 3, 3);
    pyr2 = GaussianPyramid(im2, 3, 3);
    [pos1, desc1] = findFeatures(pyr1, maxPoints);
    [pos2, desc2] = findFeatures(pyr2, maxPoints);        
    [ind1, ind2] = myMatchFeatures(desc1, desc2, minMatchScore);
    [T, ~] = ransacTransform(pos1(ind1,:), pos2(ind2,:), ransacIters, ransacInlierTol, rot);
    
end
