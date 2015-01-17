function [filter] = getFilter(filterSize)
    % Returns a gaussian filter (row vector) of the given size.
    % The filter is normalized to have sum 1.
    
    k = 1:filterSize-1;
    filter = [1 cumprod((filterSize-k)./k)];
    filter = filter / sum(filter);
end