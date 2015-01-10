function desc = sampleDescriptor(im, pos, descRad)
% SAMPLEDESCRIPTOR Sample a MOPS−like descriptor at given position in image.
% Arguments:
% im - nxm grayscale image to sample within.
% pos - A nx2 matrix of [x,y] descriptor positions in im.
% descRad - "Radius" of descriptors to compute (see below).
% 
% Returns:
% desc - A kxkxn 3-d matrix containing the ith descriptor
% at desc(:,:,i). The per-descriptor dimensions kxk are related to the
% descRad argument as follows k = 1+2*descRad.
    
    % Parameters
    k = 1 + 2 * descRad;
    ksq = k^2;
    n = size(pos, 1);
    
    % Get the positions around pos, i.e a (N*k^2)x2 matrix
    repPos = reshape(repmat(pos, 1, ksq)', 2, ksq * n);
    [dx, dy] = meshgrid(-descRad:descRad);   
    dxRow = repmat(reshape(dx, 1, ksq), 1, n);
    dyRow = repmat(reshape(dy, 1, ksq), 1, n);    
    repPos = (repPos + [dxRow; dyRow])';
    
    % Sample with interpolation
    desc = interp2(im, repPos(:,1), repPos(:,2), 'linear');
    
    % Normalize
    avg = mean(desc);
    desc = (desc - avg) / norm(desc - avg);
    
    % Reshape to N kxk matrices
    desc = reshape(desc, k, k, n);    
    
end