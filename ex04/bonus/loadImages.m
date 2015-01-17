function imgs = loadImages(directoryPath)
% Read all images from directoryPath
%
% Arguments:
% directoryPath - A string with the directory path
%
% Returns
% imgs - 4 dimensional vector, where imgs(:,:,:,k) is the k'th
% image in RGB format.
    
    % Get filenames, remove '.', '..'
    filenames = dir(directoryPath);
    filenames(1:2) = [];
    
    % Fix size according to first image
    imSize = size(imread(getPath(directoryPath, filenames(1).name)));
    
    % Read images
    imgs = zeros(imSize(1), imSize(2), imSize(3), numel(filenames));    
    for i = 1:numel(filenames)        
        imgs(:,:,:,i) = imReadAndConvert(getPath(directoryPath, filenames(i).name), 2);
    end
    
end

function fn = getPath(directory, name)
% Returns the full path of the directory and the file names.
    fn = strcat(directory, '/', name);
end
