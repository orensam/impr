minMatchScore = 0.5;
ransacIters = 1000;
ransacInlierTol = 50;

imgs = loadImages('apples2');
im1 = rgb2gray(imgs(:,:,:,3));
im2 = rgb2gray(imgs(:,:,:,4));
pyr1 = GaussianPyramid(im1, 3, 3);
pyr2 = GaussianPyramid(im2, 3, 3);
[pos1, desc1] = findFeatures(pyr1, 100);
[pos2, desc2] = findFeatures(pyr2, 100);
[ind1, ind2] = myMatchFeatures(desc1, desc2, minMatchScore);
newPos1 = pos1(ind1,:);
newPos2 = pos2(ind2,:);
[T, inliers] = ransacTransform(newPos2, newPos1, ransacIters, ransacInlierTol);
T
displayTheMatches(im1, im2, newPos1, newPos2, inliers);


