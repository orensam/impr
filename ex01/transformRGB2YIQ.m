function [imYIQ] = transformRGB2YIQ(imRGB)
    
    T = [0.299, 0.587, 0.114; 
         0.596, -0.275, -0.321
         0.212, -0.523, 0.311]';     
    
    sizes = size(imRGB(:,:,1));
    x_pixels = sizes(1);
    y_pixels = sizes(2);
    
    imRGB2 = reshape(imRGB, [], 3);
    %size(imRGB2)
    
    imYIQ = imRGB2 * T;
    imYIQ = reshape(imYIQ, [x_pixels, y_pixels, 3]);
end