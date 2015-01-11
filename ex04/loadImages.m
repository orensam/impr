function imgs = loadImages(directoryPath)
%
% Read all images from directoryPath
%
% Arguments:
% directoryPath - A string with the directory path
%
% Returns
% imgs - 4 dimensional vector, where imgs(:,:,:,k) is the k'th
% image in RGB format.

    filenames = dir(directoryPath);
    filenames(1:2) = [];
    
    imSize = size(imread(getPath(directoryPath, filenames(1).name)));
    imgs = zeros(imSize(1), imSize(2), imSize(3), numel(filenames));
    
    for i = 1:numel(filenames)        
        imgs(:,:,:,i) = imReadAndConvert(getPath(directoryPath, filenames(i).name), 2);
    end
    
end

function fn = getPath(directory, name)
    fn = strcat(directory, '/', name);
end