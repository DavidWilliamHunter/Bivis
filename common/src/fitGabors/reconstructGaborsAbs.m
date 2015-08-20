function [ reconPatches ] = reconstructGabors(gabors, width, height, popSize, generations)    
    reconPatches = zeros(size(gabors.xc(:,1),1), 2*width*height);
    reconPatchesLeft = zeros(size(gabors.xc(:,1),1), width*height);
    reconPatchesRight = zeros(size(gabors.xc(:,1),1), width*height);
    
    for i=1:size(gabors.xc(:,1),1)     
        
        leftGabor.xc = gabors.xc(i,1);
        leftGabor.yc = gabors.yc(i,1);
        leftGabor.sigmax = gabors.sigmax(i,1);
        leftGabor.sigmay = gabors.sigmay(i,1);
        leftGabor.gtheta = gabors.gtheta(i,1);
        leftGabor.phi = gabors.phi(i,1);
        leftGabor.theta = gabors.theta(i,1);
        leftGabor.freq = gabors.freq(i,1);
        leftGabor.s = gabors.s(i,1);
        leftGabor.n = width;
        
        rightGabor.xc = gabors.xc(i,2);
        rightGabor.yc = gabors.yc(i,2);
        rightGabor.sigmax = gabors.sigmax(i,2);
        rightGabor.sigmay = gabors.sigmay(i,2);
        rightGabor.gtheta = gabors.gtheta(i,2);
        rightGabor.phi = gabors.phi(i,2);
        rightGabor.theta = gabors.theta(i,2);
        rightGabor.freq = gabors.freq(i,2);
        rightGabor.s = gabors.s(i,2);
        rightGabor.n = width;
        
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
    
    reconPatches(:,1:(width*height)) = reconPatchesLeft;
    reconPatches(:,((width*height)+1):end) = reconPatchesRight;
end