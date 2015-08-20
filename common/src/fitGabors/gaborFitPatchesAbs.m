function [ results, fvals, statii, reconPatches ] = gaborFitPatchesAbs(patches, width, height, popSize, generations)    
    reconPatches = zeros(size(patches));
    [left,right] = separatePatchPairs(patches);
    xc = zeros(size(patches,1), 2);
    yc = zeros(size(patches,1), 2);
    sigmax = zeros(size(patches,1), 2);
    sigmay = zeros(size(patches,1), 2);
    gtheta = zeros(size(patches,1), 2);
    freq = zeros(size(patches,1), 2);
    phi = zeros(size(patches,1), 2);
    theta = zeros(size(patches,1), 2);
    s = zeros(size(patches,1), 2);

    fvalsLeft = zeros(size(patches,1),1);
    fvalsRight = zeros(size(patches,1),1);
    statiiLeft = zeros(size(patches,1),1);
    statiiRight = zeros(size(patches,1),1);
    
    parfor i=1:size(patches,1)
        i
        leftImage = reshape(left(i,:), width, height);
        rightImage = reshape(right(i,:), width, height);       
        
        [leftGabor, fvalsLeft(i), statiiLeft(i)] = gaGaborFitAbs(leftImage);
        [rightGabor, fvalsRight(i), statiiRight(i)] = gaGaborFitAbs(rightImage);        
        
        xc(i,:) = [leftGabor.xc, rightGabor.xc];
        yc(i,:) = [leftGabor.yc, rightGabor.yc];        
        sigmax(i,:) = [leftGabor.sigmax, rightGabor.sigmax];
        sigmay(i,:) = [leftGabor.sigmay, rightGabor.sigmay];
        gtheta(i,:) = [leftGabor.gtheta, rightGabor.gtheta];
        freq(i,:) = [leftGabor.freq, rightGabor.freq];
        phi(i,:) = [leftGabor.phi, rightGabor.phi];
        theta(i,:) = [leftGabor.theta, rightGabor.theta];
        s(i,:) = [leftGabor.s, rightGabor.s];
        
        leftRec = gabor2dAbs(leftGabor);
        rightRec = gabor2dAbs(rightGabor);
        reconPatchesLeft(i,:) = reshape(leftRec, 1, numel(leftRec));
        reconPatchesRight(i,:) = reshape(rightRec, 1, numel(leftRec));
        %reconPatches(i,1:(width*height)) = reshape(leftRec, 1, numel(leftRec));
        %reconPatches(i,((width*height)+1):end) = reshape(rightRec, 1, numel(leftRec));
        
        %figure(1);
        %showPatches(reconPatches, 25, 50, 10, 20);
        %figure(2);
        %showPatches(abs(reconPatches - patches), 25, 50, 10, 20);
    end 
    results.xc = xc;
    results.yc = yc;
    results.sigmax = sigmax;
    results.sigmay = sigmay;
    results.gtheta = gtheta;
    results.freq = freq;
    results.phi = phi;
    results.theta = theta;
    results.s = s;
    
    reconPatches(:,1:(width*height)) = reconPatchesLeft;
    reconPatches(:,((width*height)+1):end) = reconPatchesRight;
    
    fvals = [fvalsLeft ; fvalsRight];
    statii = [statiiLeft ; statiiRight];
end