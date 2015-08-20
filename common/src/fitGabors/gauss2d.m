function f = gauss2d(n, xc, yc, sigmax, sigmay, gtheta, flag_print)
% gauss2d -- Generating an unnormalized 2D Gaussian
%
% Useage:
% f = gauss2d(n, xc, yc, sigmax, sigmay, gtheta),
% n:      side length of the matrix f
% xc, yc: center coordinates for Gabor function
% sigmax: sigma of gaussian along horizontal axis
% sigmay: sigma of gaussian along vertical axis
% gtheta:  ccw [rad] in the matrix (ij) axis
%
% f = gauss2d(n, xc, yc, sigmax, sigmay, gtheta, flag_print),
% if flag_print = 'y', plot the results.  If flag_print is not given, it
% is treated otherwise.

% Eizaburo Doi (edoi@cnbc.cmu.edu), August 2003.
% For additional comments on this code, see cos2d.m


[x,y] = meshgrid(1:n);

x = x - xc;
y = y - yc;

gtheta = -gtheta;

px = x;
py = y;

x =  px*cos(gtheta) + py*sin(gtheta);
y = -px*sin(gtheta) + py*cos(gtheta);

f = exp( -1/2*( (x/sigmax).^2 + (y/sigmay).^2 ) );