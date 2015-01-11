function Tout = imgToPanoramaCoordinates(Tin)
% Tout{k} transforms image i to the coordinates system of the Panorama Image.
%
% Arguments:
% Tin - A set of transformations (cell array) such that T_i transfroms
% image i+1 to image i.
%
% Returns:
% Tout - a set of transformations (cell array) such that T_i transforms
% image i to the panorama corrdinate system which is the the corrdinates
% system of the first image
    
    n = numel(Tin);
    Tout = cell(1, n+1);
    Tout{1} = eye(3);
    
    for i = 1:n
        Tout{i+1} = Tin{i} * Tout{i};
    end

end