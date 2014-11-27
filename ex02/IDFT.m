function [signal] = IDFT(fourierSignal)
% Converts the given fourier signal to regular signal.

    N = size(fourierSignal, 2);   
    % vector: w^0, ... , w^(n-1)
    omegas = exp( -2 * pi * i / N) .^ [0 : N-1];    
    % Create Vandermonde matrix
    [gridX, gridY] = meshgrid(omegas, 0:N-1);
    ivdm = conj((gridX .^ gridY));
    
    signal = (ivdm * fourierSignal.').';
    
end

