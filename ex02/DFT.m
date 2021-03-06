function [fourierSignal] = DFT(signal)
% Converts the given signal (row vector) to fourier

    N = size(signal, 2);    
    % Vector: w^0, ... , w^(n-1)
    omegas = exp(-2*pi*1i/N) .^ (0:N-1);    
    % Create Vandermonde matrix
    [gridX, gridY] = meshgrid(omegas, 0:N-1);
    vdm = (gridX .^ gridY);    
    % Transform the signal, return row vector
    fourierSignal = (vdm * (signal.')).';
    
end

