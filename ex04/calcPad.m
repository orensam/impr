function [topPad, bottomPad, leftPad, rightPad, dxs, dys] = calcPad(transforms)
    dxs = cellfun(@(T) T(1,3), transforms)
    dys = cellfun(@(T) T(2,3), transforms)    
    
    bottomPad = ceil(abs(min(dys(find(dys<0)))));
    topPad = ceil(max(dys(find(dys>0))));
    leftPad = ceil(abs(min(dxs(find(dxs<0)))));
    rightPad = ceil(max(dxs(find(dxs>0))));    
    
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