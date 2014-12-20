function res = renderPyramid(pyr, levels)
    % Renders the given pyramid to a single image.
    % Uses a white background.
    
    [nrows, ncols] = cellfun(@size, pyr');
    res = ones(nrows(1), sum(ncols(1:levels)));
    colBorders = [0 cumsum(ncols)];
    
    for i = 1:levels
        res(1:nrows(i), colBorders(i)+1:colBorders(i+1)) = pyr{i};
    end
    
end