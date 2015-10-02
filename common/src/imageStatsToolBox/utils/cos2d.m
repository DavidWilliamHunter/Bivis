function f = cos2d(n, freq, phi, theta, xc, yc)
% cos2d -- Generating a 2D cosine grating.
%    
% Useage:
% f = cos2d(n, freq, phi, theta, xc, yc),
% n:      side length of the output matrix f
% freq:   spatial frequency; normalized such that Nyquist freq. = 1
% phi:    phase [rad]; 0 is cos (even), pi/2 is sin (odd).
% theta:  ccw [rad] in the matrix (ij) axis; 0 yields vertical gratings,
%         *not horizontal*, such that it corresponds to frequency space
%         representation.   
% xc, yc: center coordinates for Gabor function.
%
% f = cos2d(n, freq, phi, theta, xc, yc,flag_print),
% flag_print (optional): if flag_print = 'y', plot the results.  If
% flag_print is not given, it is treated 'n'.

% Eizaburo Doi (edoi@cnbc.cmu.edu), August 2003.

    
[x,y] = meshgrid(1:n);
% Note: x is horizontal, y is vertical axis
% relation to matrix index (i,j):
% j = x;
% i = n-y+1;

% Put xc and yc to be at the origin
x = x - xc;
y = y - yc; 


% Note: ccw rotation of (x,y) to (px,py) in the conventional coordinate
% is given as follows:
% (px,py)' = [cos(theta), -sin(theta); sin(theta), cos(theta)]*(x,y)'.
% In our definition y directs downward instead of upward); so to get ccw we
% need to change sign of theta.
theta = -theta;

% Note: to obtain f(px,py) (f at the rotated point), we solve the above
% linear equations and plug it into f(x,y), i.e.,
% (x,y)'
%   = inv[cos(theta), -sin(theta); sin(theta), cos(theta)]*(px,py)'
%   = [cos(theta), sin(theta); -sin(theta), cos(theta)]*(px,py)'.

px = x;
py = y;

x =  px*cos(theta) + py*sin(theta);
y = -px*sin(theta) + py*cos(theta);

arg = pi*freq*x*2; 
% Note: arg gives the gradient that passed to cos function below.
% tehta = 0  yields only horizontal gradient, leading horizontal
% gratings.


f = cos(arg+phi);







