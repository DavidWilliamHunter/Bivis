function [ f ] = logGabor2d(w)
% gabor2d -- Generating a 2D Log Gabor function in Fourier Space
%
% Useage:
% f = logGabor2d(w),
% w. (parameters are passed in through a structure)
%   n      patch size (n x n)
%   xc,yc  center coordinates for the 2D Gabor
%   theta  centre of orientation filter
%   thetas bandwidth of the orientation filter
%   fo     maximum frequency of filter
%   fsigma frequency bandwidth
%   s      scale factor
%
% Adapted from GaborConvolve.m from Gabor_image_Features set downloaded
% from
% http://www.mathworks.co.uk/matlabcentral/fileexchange/38844-gabor-image-features
% 090614.
% 
% *Original* Code contained the following notice
%
% Copyright (c) 2001-2005 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
% Modified Code is Copywrite(c) 2014 David Hunter
% School of Psychology and Neuroscience
% University of St Andrews
% UK
        
    % create grid
    [ x , y ] = meshgrid( 1:w.n, 1:w.n);
    
    % shift zero to centre and normalise
    x = (x-w.n/2)/w.n;
    y = (y-w.n/2)/w.n;
    
    radius = sqrt(x.^2 + y.^2);
    fudgeInds = radius==0;
    radius(fudgeInds) = 1;        %remove 0 radius
    
    
    % Compute angular spread function
    angles = atan2(-y,x);        % precompute angular portion
    
    sangles = sin(angles);
    cangles = cos(angles);
    
    % For each point in the filter matrix calculate the angular distance from the
    % specified filter orientation.  To overcome the angular wrap-around problem
    % sine difference and cosine difference values are first computed and then
    % the atan2 function is used to determine angular distance.
    ds = sangles * cos(w.theta) - cangles * sin(w.theta);     % Difference in sine.
    dc = cangles * cos(w.theta) + sangles * sin(w.theta);     % Difference in cosine.
    dtheta = abs(atan2(ds,dc));                           % Absolute angular distance.
    inds = dtheta > pi/2;
    dtheta(inds) = pi-dtheta(inds);                       % mirror the orientation filter.    
    spread = exp((-dtheta.^2) / (2 * w.thetas^2));      % Calculate the angular filter component.
    
    % Compute frequency bandpass component
    logGabor = exp((-(log(radius/w.fo)).^2) / ( 2 * log(w.fsigma)^2));
    
    logGabor(fudgeInds) = 0;        % undo the log 0 fudge.
    
    f = (logGabor .* spread); % Multiply by the angular spread to get the filter
    % and swap quadrants to move zero frequency
    % to the corners.
    
    
end
    
