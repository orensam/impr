% Second RGB blending example: Saturn over earth
im1 = imReadAndConvert('meadow.jpg',2);
im2 = imReadAndConvert('saturn.jpg',2);
mask = round(imReadAndConvert('mask2.jpg',1));
pyramidBlendingRGB(im1, im2, mask, 6, 75, 55);
