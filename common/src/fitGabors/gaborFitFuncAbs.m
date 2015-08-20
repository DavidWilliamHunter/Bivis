function [ f ] = gaborFitFuncAbs(target, func)
    %target = target ./ norm(target);
    
    w.n = size(target, 1);
    w.xc = func(1);
    w.yc = func(2);
    w.sigmax = abs(func(3));
    w.sigmay = abs(func(4));
    w.gtheta = func(5);
    w.freq = func(6);
%    if(func(7)<0)
%        w.phi = 0;%func(7);
%    else
%        w.phi = 0;
%    end
    %if(func(7) < 0.2)
    %    w.phi = -pi;
    %elseif(func(7) < 0.4)
    %    w.phi = -pi/2;
    %elseif(func(7) < 0.6) 
    %    w.phi = 0;
    %elseif(func(7) < 0.8)
    %    w.phi = pi/2;
    %else
    %    w.phi = pi;
    %end
    w.phi = func(7);
    w.theta = func(8);
    w.s = func(9);

    g = gabor2dAbs(w);
    %g = g ./ norm(g);
    
    
    f = sum((target(:) - g(:)).^2);
end
    
