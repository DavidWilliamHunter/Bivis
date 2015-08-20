%% Initialise variables
clear 'gabors'
clear 'population'
patchSize = 25;
noPatches = 200;
noBootstraps = 10;

initialGabors ='bootstrap_accuracy_test_gabor.mat';
fittedGaborFileName = 'bootstrap_accuracy_test_gabor_fit.mat';
fittedLogGaborFileName = 'bootstrap_accuracy_test_log_gabor_fit.mat';

regenerateRandomGabors = false;
refitGabors = false;
refitLogGabors = false;

if regenerateRandomGabors || ~exist(initialGabors, 'file')
    %%
    % Generate a random set of Gabor patches
    popInitRange = [0,0,4,4,0,0.1, -pi, 0, 0.1; ...
        patchSize,patchSize,patchSize/2,patchSize/2,pi,0.5, pi, pi, 1];
    
    population = cell(1,2);
    for loop = 1:2
        pop = rand(noPatches, size(popInitRange,2)) .* repmat(popInitRange(2,:)-popInitRange(1,:), noPatches, 1) + repmat(popInitRange(1,:), noPatches, 1);
        
        population{loop} = pop;
        gabors.xc(:,loop) = pop(:,1);
        gabors.yc(:,loop) = pop(:,2);
        gabors.sigmax(:,loop) = pop(:,3);
        gabors.sigmay(:,loop) = pop(:,4);
        gabors.gtheta(:,loop) = pop(:,5);
        gabors.freq(:,loop) = pop(:,6);
        gabors.phi(:,loop) = pop(:,7);
        gabors.theta(:,loop) = pop(:,8);
        gabors.s(:,loop) = pop(:,9);
        gabors.n(:,loop) = ones(1,9).*patchSize;
    end
    
    save(initialGabors, 'gabors', 'patchSize', 'noPatches', 'noBootstraps');
    
    % as regenerating random gabors invalidates everything that follows we
    % must set
    refitGabors = true;
    refitLogGabors = true;
else
    load(initialGabors, 'gabors', 'patchSize', 'noPatches', 'noBootstraps');
end

if refitGabors || ~exist(fittedGaborFileName, 'file')
    delete(fittedGaborFileName);
end
patches = reconstructGabors(gabors, patchSize, patchSize);

showPatches(patches, patchSize, patchSize*2, 10, 20);


[ resultsGabor, fvalsGabors, statiiGabors] = bootstrapGaborFitPatches(noBootstraps, patches, 25, 25, fittedGaborFileName);


patchesImg = showPatches(patches, 25, 50, 10, 20);
reconPatches = reconstructGabors(resultsGabor{1}, patchSize, patchSize);
reconPatchesImg = showPatches(reconPatches, 25, 50, 10, 20);
figure
showAnaglyph(patchesImg, reconPatchesImg);
figure


correctedGabors = convertAbsGabor2Gabor(resultsGabor{1}, patchSize);
reconPatchesCorrected = reconstructGabors(correctedGabors, patchSize, patchSize);

reconPatchesCorrectedImg = showPatches(reconPatchesCorrected, 25, 50, 10, 20);

showAnaglyph(patchesImg, reconPatchesCorrectedImg);

save(fittedGaborFileName);

if refitLogGabors || ~exist(refitLogGabors, 'file')
    delete(fittedLogGaborFileName);
end

patches = reconstructGabors(gabors, patchSize, patchSize);

showPatches(patches, patchSize, patchSize*2, 10, 20);


[ resultsLogGabor, fvalsLogGabors, statiiLogGabors] = bootstrapLogGaborFitPatches(noBootstraps, patches, 25, 25, fittedLogGaborFileName);

[leftPatches, rightPatches ] = separatePatchPairs(patches);

reconPatches = reconstructLogGaborsFFT(resultsLogGabor{1}, patchSize, patchSize);
[ leftReconPatches, rightReconPatches ] = separatePatchPairs(reconPatches);
reconPatchesImg = showPatches(leftReconPatches, 25, 25, 10, 20);


patchesFFT = patchFFT(leftPatches, patchSize, patchSize);
patchesFFTImg = showPatches(abs(patchesFFT), 25, 25, 10, 20);

showAnaglyph(reconPatchesImg, patchesFFTImg);

save(fittedLogGaborFileName);

