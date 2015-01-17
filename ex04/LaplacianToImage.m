function img = LaplacianToImage(lpyr, filter, coeffMultVec)
    % Reconstructs the image from the given Laplacian pyramid.
    % Multiplies each pyramid level by the matching coefficient
    % vector entry.
    
    img = lpyr{end};
    for j = numel(lpyr)-1:-1:1
        img = coeffMultVec(j) * lpyr{j} +  expand(img, filter);
    end    
end    