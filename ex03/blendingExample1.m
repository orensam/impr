function [] = blendingExample1()
    % First RGB blending example
    
    im1 = imReadAndConvert('images/cat.jpg',2);
    im2 = imReadAndConvert('images/batman.jpg',2);
    mask = imReadAndConvert('images/mask1.png',1);
    res = pyramidBlendingRGB(im1, im2, mask, 3, 15, 21);
    
    figure;
    imshow(im1);
    title('Image 1');
    figure;
    imshow(im2);
    title('Image 2');
    figure;
    imshow(mask);
    title('Blending mask');
    figure;
    imshow(res);
    title('Blended image');
    
end