function f = gabor2dAbs(w)


% gabor2d -- Generating a 2D Gabor function
%
% Useage:
% f = gabor2d(w),
% w. (parameters are passed in through a structure)
%   n      patch size (n x n)
%   xc,yc  center coordinates for the 2D Gabor
%   sigmax 2D Gaussian horizontal axis std dev before ccw rotation
%   sigmay 2D Gaussian vertical  axis std dev before ccw rotation
%   gtheta 2D Gaussian orientation (in rad., ccw from horiz)
%   freq   normalized frequency (0=DC, 1=Nyquist)
%   phi    phase of 2D cosine (0, pi)
%   theta  2D cosine orientation (in rad., ccw from horiz)
%   s      scale factor

% This is based on Mike Lewicki's gaborfit code set.
% Eizaburo Doi (edoi@cnbc.cmu.edu), August 2003.    

Gauss = gauss2d(w.n, w.xc, w.yc, w.sigmax, w.sigmay, w.gtheta);

Cos   = cos2dAbs(w.n, w.freq, w.phi, w.theta, w.xc, w.yc);

f = w.s * Gauss .* Cos;

