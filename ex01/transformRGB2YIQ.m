function [imYIQ] = transformRGB2YIQ(imRGB)
    % Transforms the given RGB image to YIQ,
    % Using the standard conversion matrix.
    T = [0.299, 0.587, 0.114; 
         0.596, -0.275, -0.321
         0.212, -0.523, 0.311];             
    imRGB2 = reshape(imRGB, [], 3);
    imYIQ = T * imRGB2';
    imYIQ = reshape(imYIQ', size(imRGB));
end