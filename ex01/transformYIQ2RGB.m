function [imRGB] = transformYIQ2RGB(imYIQ)
    % Transforms the given YIQ image to RGB,
    % Using the standard conversion matrix.
    T = [0.299, 0.587, 0.114; 
         0.596, -0.275, -0.321
         0.212, -0.523, 0.311];
     try
        imYIQ2 = reshape(imYIQ, [], 3);
        imRGB = T \ imYIQ2';
        imRGB = reshape(imRGB', size(imYIQ));     
     catch
         imRGB = 0;
         fprintf('Error: invalid image\n');
     end
end