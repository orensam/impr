function [topPad, bottomPad, leftPad, rightPad, dxs, dys] = calcPad(transforms)
% Calculates the padding required on the 4 sides of a frame according to
% the given transformations.
    
    moves = cellfun(@(T) T*[1;1;1], transforms, 'UniformOutput', false);
    dxs = cellfun(@(p) p(1)/p(3), moves);
    dys = cellfun(@(p) p(2)/p(3), moves);

    %dxs = cellfun(@(T) T*[0,0], transforms);
    %dys = cellfun(@(T) T(2,3), transforms);   
    
    topPad = abs(min(dys(find(dys<0))));
    bottomPad = max(dys(find(dys>0)));
    leftPad = abs(min(dxs(find(dxs<0))));
    rightPad = max(dxs(find(dxs>0)));    
    
    if isempty(topPad)
        topPad = 0;        
    end
    if isempty(bottomPad)
        bottomPad = 0;        
    end    
    if isempty(leftPad)
        leftPad = 0;        
    end
    if isempty(rightPad)
        rightPad = 0;
    end
    
end