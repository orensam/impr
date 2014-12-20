% First RGB blending example: Catephant!
im1 = imReadAndConvert('cat.jpg', 2);
im2 = imReadAndConvert('elephant.jpg', 2);
mask = round(imReadAndConvert('mask1.jpg', 1));
pyramidBlendingRGB(im1, im2, mask, 7, 75, 55);
