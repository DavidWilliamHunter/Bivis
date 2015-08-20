function [ reconPatches ] = reconstructLogGaborsFFT(logGabors, width, height)    
    reconPatches = zeros(size(logGabors.theta(:,1),1), 2*width*height);
    reconPatchesLeft = zeros(size(logGabors.theta(:,1),1), width*height);
    reconPatchesRight = zeros(size(logGabors.theta(:,1),1), width*height);
    
    for i=1:size(logGabors.theta(:,1),1)     
        
        leftGabor.theta = logGabors.theta(i,1);
        leftGabor.thetas = logGabors.thetas(i,1);
        leftGabor.fo = logGabors.fo(i,1);
        leftGabor.fsigma = logGabors.fsigma(i,1);
        leftGabor.s = logGabors.s(i,1);
        leftGabor.n = width;
        
        rightGabor.theta = logGabors.theta(i,2);
        rightGabor.thetas = logGabors.thetas(i,2);
        rightGabor.fo = logGabors.fo(i,2);
        rightGabor.fsigma = logGabors.fsigma(i,2);
        rightGabor.s = logGabors.s(i,2);
        rightGabor.n = width;
        
        leftRec = logGabor2d(leftGabor);
        rightRec = logGabor2d(rightGabor);
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