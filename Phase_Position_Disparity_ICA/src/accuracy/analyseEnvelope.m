clear all
clear 
patchSize = 25;
noBootstraps = 10;

%initialGabors ='bootstrap_accuracy_test_gabor.mat';
%fittedGaborFileName = 'bootstrap_accuracy_test_gabor_fit.mat';
fittedLogGaborFileName = 'bootstrap_accuracy_test_ica_log_gabor_fitted3.mat';

%load(initialGabors, 'gabors', 'patchSize', 'noPatches', 'noBootstraps');
%load(fittedGaborFileName);
load(fittedLogGaborFileName);

noPatches = size(components{1},1);

noLogGabors = numel(resultsLogGabor);

gaborError = zeros(noLogGabors, noPatches*2);
logGaborError = zeros(noLogGabors, noPatches*2);

    
for loop = 1:noLogGabors
    patches = components{loop};

    [leftPatches, rightPatches ] = separatePatchPairs(patches);
    patchesLeftFFT = patchFFT(leftPatches, patchSize, patchSize);
    patchesRightFFT = patchFFT(rightPatches, patchSize, patchSize);

    figure(1)
    subplot(3,1,1)
    showPatches(abs([patchesLeftFFT patchesRightFFT]), patchSize, patchSize*2, 2, 2);
    
    reconPatches = reconstructGabors(resultsGabor{loop}, patchSize, patchSize);
    
    [ leftGabor, rightGabor ] = separatePatchPairs(reconPatches);
    
    leftGaborFFT = patchFFT(leftGabor, patchSize, patchSize);
    rightGaborFFT = patchFFT(rightGabor, patchSize, patchSize);
    
    subplot(3,1,2)
    showPatches(abs([leftGaborFFT rightGaborFFT]), patchSize, patchSize*2, 2, 2);    
    
    gaborError(loop,1:size(leftPatches,1)) = sum((abs(leftGabor)-abs(patchesLeftFFT)).^2,2);
    gaborError(loop,(1:size(leftPatches,1))+size(leftPatches,1)) = sum((abs(rightGabor)-abs(patchesRightFFT)).^2,2);

    gisf = isFiniteGabor(resultsGabor{loop});
    gisf = [gisf(:,1) ; gisf(:,2)];
    
    gaborError(loop,~gisf) = NaN;
    reconLogPatches = reconstructLogGaborsFFT(resultsLogGabor{loop}{1}, patchSize, patchSize);
    
    subplot(3,1,3)
    showPatches(reconLogPatches, patchSize, patchSize*2, 2, 2);    
        
    [ leftLogGabor, rightLogGabor ] = separatePatchPairs(reconLogPatches);
    
    logGaborError(loop,1:size(leftPatches,1)) = sum((abs(leftLogGabor)-abs(patchesLeftFFT)).^2,2);
    logGaborError(loop,(1:size(leftPatches,1))+size(leftPatches,1)) = sum((abs(rightLogGabor)-abs(patchesRightFFT)).^2,2);
end

figure(2)
subplot(2,1,1)
hist(logGaborError(:), 100)
subplot(2,1,2)
hist(gaborError(:), 100)

inds = isfinite(gaborError) & isfinite(logGaborError);

c = corr(logGaborError(inds), gaborError(inds), 'Type', 'Spearman');
fprintf('Spearmans rho for the logGaborError and gaborError: %f\n', c);

d  = 2.*(gaborError(inds) - logGaborError(inds))./(gaborError(inds) +logGaborError(inds));

lower = sum(d(:) < -0.01)./numel(d);
upper = sum(d(:) > +0.01)./numel(d);

fprintf('Proportion of Gabor Error < Log Gabor Error : %g\n', lower);
fprintf('Proportion of Gabor Error > Log Gabor Error : %g\n', upper);
fprintf('Median error for Gabor Error < Log Gabor Error : %g\n', median(d(d(:) < -0.01)));
fprintf('Median error for Gabor Error > Log Gabor Error : %g\n', median(d(d(:) > +0.01)));


figure(3)
hist(d(:),25);