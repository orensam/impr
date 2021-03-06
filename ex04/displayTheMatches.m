function displayTheMatches(im1, im2, pos1, pos2, inlind)
% DISPLAYMATCHES Display matched pt. pairs overlayed on given image pair.
% Arguments:
% im1, im2 - two grayscale images
% pos1, pos2 - nx2 matrices containing n rows of [x,y] coordinates of matched
% points in im1 and im2 (i.e. the i'th match's coordinate is
% pos1(i,:) in im1 and and pos2(i,:) in im2).
% inlind - k-element array of inlier matches (e.g. see output of
% ransacHomography.m)
    
    % Sizes
    width = size(im1, 2);
    n = size(pos1, 1);    
        
    % Show images side by side
    figure;
    im = [im1, im2];
    imshow(im);
    hold on;
    
    % Scatter the match points on both images
    pos2(:,1) = pos2(:,1) + width;
    scatter(pos1(:,1), pos1(:,2), 'ro');
    scatter(pos2(:,1), pos2(:,2), 'ro');
    
    % Get inlier positions
    inpos1 = pos1(inlind, :)';
    inpos2 = pos2(inlind, :)';
    
    % Get outlier postions
    outind = setdiff(1:n, inlind);
    outpos1 = pos1(outind, :)';
    outpos2 = pos2(outind, :)';    
    
    % Draw inlier and outlier lines
    plot([inpos1(1,:); inpos2(1,:)], [inpos1(2,:); inpos2(2,:)], 'y');
    plot([outpos1(1,:); outpos2(1,:)], [outpos1(2,:); outpos2(2,:)], 'b');
    impixelinfo;
    
end
