function [filter] = getFilter(filterSize)
    k = 1:filterSize-1;
    filter = [1 cumprod((filterSize-k)./k)];
    filter = filter / sum(filter);
end