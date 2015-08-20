function [ isf ] = isFiniteGabor( gabors )
% Tests a Gabor function or group of gabor functions and returns true if
% and only if all parameters contain finite values.
%
% [ isf ] = isFiniteGabor( gabors )
%
% gabor - struct containing gabor parameters
% isf - boolean vector, true and only if the assosiated gabor parameters
% are all finite

isf = isfinite(gabors.xc) & ...
    isfinite(gabors.yc) & ...
    isfinite(gabors.sigmax) & ...
    isfinite(gabors.sigmay) & ...
    isfinite(gabors.gtheta) & ...
    isfinite(gabors.theta) & ...
    isfinite(gabors.freq) & ...
    isfinite(gabors.phi) & ...
    isfinite(gabors.s);

end

