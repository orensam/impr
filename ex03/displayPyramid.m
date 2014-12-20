function [] = displayPyramid(pyr, levels)
    % Renders the given pyramid and displays the result.
    
    res = renderPyramid(pyr, levels);
    imshow(res);
end