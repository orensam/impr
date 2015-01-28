im = im2double(imread('myNoisyImage.png'));
lowFilt = [1 1]./2;
highFilt = [1 -1]./2;
levels = 2;
dn = denoising(im, lowFilt, highFilt, levels);
