function [ param, fitValue, status ] = gaGaborFitAbs(target, tol, gaPopulationSize)
    if(nargin<2)
        tol = 0.000001;
    end
    if(nargin<3)
        gaPopulationSize = 1000;
    end
    param.n = size(target,1);
    options = gaoptimset(@ga);
    options.PopInitRange = [0,0,0,0,-pi,0, -pi, - pi, 0; ...
                            param.n,param.n,param.n,param.n,pi,1,pi, pi, 26];
    options.PopulationSize = gaPopulationSize;
    
    options.Display = 'final';
    %options.PlotFcns = { @gaplotbestf };
    options.EliteCount = ceil(options.PopulationSize / 100);
    options.UseParallel = 'always';
    options.MaxIter = 25;
    options.MutationFcn  = @mutationadaptfeasible;
    
    LB = [ 0 , 0 , 0, 0, -pi, 0, -pi, -pi, 0];
    UB = [ size(target,1), size(target,2), size(target,1), size(target,2), pi/2, 1 , pi, pi, 25 ];
    %x = ga(fitnessfcn,nvars,A,b,[],[],LB,UB,nonlcon,IntCon,options);
    w = ga(@(u) gaborFitFuncAbs(target, u), 9, [], [], [], [], LB, UB, [], [], options);
    
    %gaborFitFunc(target, w)
    
    fitOptions = optimset('MaxIter', 10000, 'TolX' , tol); 
    
    [w, fitValue, status] = fminsearch(@(u) gaborFitFuncAbs(target, u), w, fitOptions);
    
    %gaborFitFunc(target, w)
    %gaborFitFFT2Func(target, w)
    
    %[w, fitValue, status] = fminsearch(@(u) gaborFitFFT2Func(target, u), w, fitOptions);
    
    %gaborFitFunc(target, w)
    %gaborFitFFT2Func(target, w)
    %fitValue
    %status
    
    param.xc = w(1);
    param.yc = w(2);
    param.sigmax = abs(w(3));
    param.sigmay = abs(w(4));
    param.gtheta = w(5);
    param.freq = w(6);
    param.phi = w(7);
    %if(w(7) < 0.2)
    %    param.phi = -pi;
    %elseif(func(7) < 0.4)
    %    param.phi = -pi/2;
    %elseif(func(7) < 0.6) 
    %    param.phi = 0;
    %elseif(func(7) < 0.8)
    %    param.phi = pi/2;
    %else
    %    param.phi = pi;
    %end    
    param.theta = w(8);
    param.s = w(9);
    
end
    