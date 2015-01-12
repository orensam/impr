minMatchScore = 0.5;
ransacIters = 1000;
ransacInlierTol = 10;
maxPoints = 800;

imgs = loadImages('apples5');
im1 = rgb2gray(imgs(:,:,:,1));
im2 = rgb2gray(imgs(:,:,:,2));
pyr1 = GaussianPyramid(im1, 3, 3);
pyr2 = GaussianPyramid(im2, 3, 3);
[pos1, desc1] = findFeatures(pyr1, maxPoints);
[pos2, desc2] = findFeatures(pyr2, maxPoints);
[ind1, ind2] = myMatchFeatures(desc1, desc2, minMatchScore);
newPos1 = pos1(ind1,:);
newPos2 = pos2(ind2,:);
[T1, inliers] = ransacTransform(newPos2, newPos1, ransacIters, ransacInlierTol);
T1
res = estimateGeometricTransform(newPos2, newPos1, 'similarity');
T2 = res.T

displayTheMatches(im1, im2, newPos1, newPos2, inliers);


