function f = gabor2d(w)

if nargin == 0
    f.n = 25;
    f.xc = f.n/2;
    f.yc = f.n/2;
    f.gtheta = 0;
    f.freq = 0.5;
    f.phi = 0;
    f.theta = 0;
    f.sigmax = 1.5./f.freq;
    f.sigmay = 1.5./f.freq;
    f.s = 1;
    return
end
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

Cos   = cos2d(w.n, w.freq, w.phi, w.theta, w.xc, w.yc);

f = w.s * Gauss .* Cos;

