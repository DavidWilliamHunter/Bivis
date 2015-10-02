%%
% Model and outputs complex cell responses using grating stimuli

% some basic directory setup
clear all
display('Loading Data');
plotDirectoryComplex = '..\plots\2\gratings\';
plotDirectorySingle = '..\plots\2\gratingsSingle\';
gaborDirectory = '../data/2/';

nbootstraps = 200;

subspacesize = 2;

modelTypeNames = {'Squared_GratingsSingle','AbsMaxPooled_GratingsSingle', 'SquaredHalfRec_GratingsSingle', 'MaxPooledHalfRec_GratingsSingle', 'SquaredFullRec_GratingsSingle','MaxPooledExhMaxPooledInhib_GratingsSingle','SimpleSum_GratingsSingle','MaxPooledUnRectified_GratingsSingle'};
modelTypeNames = {'Squared_GratingsSingle','AbsMaxPooled_GratingsSingle'};

offset = 1;

images = 1:6;

noModels = numel(modelTypeNames);
noComplexComponents = 125;
subspacesize = 4;

noComplexComponents = 200;
subspacesize = 2;

ddiStoreComplex = zeros(noModels, numel(images), noComplexComponents);
phaseInvLeftStoreSimple = zeros(noModels, numel(images), noComplexComponents,subspacesize);
phaseInvRightStoreSimple = zeros(noModels, numel(images), noComplexComponents,subspacesize);
respStoreSimple = cell(noModels, numel(images), noComplexComponents,subspacesize);
dispStoreSimple = cell(noModels, numel(images), noComplexComponents,subspacesize);
ddiStoreSimple = zeros(noModels, numel(images), noComplexComponents,subspacesize);

phaseInvLeftStoreComplex = zeros(noModels, numel(images), noComplexComponents);
phaseInvRightStoreComplex = zeros(noModels, numel(images), noComplexComponents);
respStoreComplex = cell(noModels, numel(images), noComplexComponents);
dispStoreComplex = cell(noModels, numel(images), noComplexComponents);


for imageLoop = images
    
    fileNameGabors = sprintf('%sisaFittedGabors_%i.mat', gaborDirectory, imageLoop)
    fileName = sprintf('%sisa_%i.mat', gaborDirectory, imageLoop)
    S = load(fileNameGabors, 'gabors');
    
    gabors = Gabor2D(S.gabors);
    
    clear S
    
    % load ISA patch data
    info = PatchInfo(1,2, 25*25*2, [25 25]);
    isaPatches = Patches.import('Filename', fileName, 'PatchInfo', info, 'PatchData', 'Wisa');
    
    % normalise component energy.
    isaPatches = isaPatches.patchNormalise;
    
    %Generate cosine stimuli
    
    
    % define complex model
    inds = reshape(1:isaPatches.getNoPatches, subspacesize, isaPatches.getNoPatches/subspacesize);
    
    for loop = 1:noComplexComponents
        %Generate cosine stimuli using the principal orientation and frequency
        %of the component.
        gabor = gabors.select(inds(1,loop),1);
        if gabor.isValid
            % pre generate stimuli
            responseField.generator = GratingStimuli2D(gabor.frequency, gabor.phase, gabor.orientation);
            patchInfo = isaPatches.getPatchInfo;
            [ stimuli , disp ] = responseField.generator.generate(patchInfo, 100, 'phase', [-pi 0], [pi 0], 'phase', [0 -pi], [0 pi]);
            
            for modelType = 1:noModels
                % setup simulation
                simpleModel = ComplexPatchNeuron(isaPatches, 1:isaPatches.getNoPatches, -1); % create single cell models by specify a complex cell with only one sub-unit.
                responseField = ResponseField;
                responseField.model = simpleModel;
                
                % calculate simple cell data first
                simpleInds = inds(:,loop);
                for simpleLoop = 1:numel(simpleInds)
                    % generate heatmap from simulated responses
                    [ resp ] = responseField.generateHeatmap(simpleInds(simpleLoop), 100, stimuli);
                    respStoreSimple{modelType, imageLoop, loop, simpleLoop} = resp;
                    dispStoreSimple{modelType, imageLoop, loop, simpleLoop} = disp;
                    
                    % calculate phase differences for each sample
                    diff = abs(squeeze(disp.phase(:,:,1,1) - disp.phase(:,:,1,2)));
                    diff(:,:,2) = (2*pi) - abs(squeeze(disp.phase(:,:,1,2) - disp.phase(:,:,1,1)));
                    diff = min(diff,[], 3);
                    
                    % calculate DDI
                    ddiStoreSimple(modelType,imageLoop, loop, simpleLoop) = disparityDiscriminationIndex(diff(:), resp(:));
                    
                    phases = squeeze(disp.phase(:,:,1,2));
                    phaseInvLeftStoreSimple(modelType,imageLoop, loop, simpleLoop) = phaseInvariance(phases(:), resp(:));
                    phases = squeeze(disp.phase(:,:,1,1));
                    phaseInvRightStoreSimple(modelType,imageLoop, loop, simpleLoop) = phaseInvariance(phases(:), resp(:));
                    
                end
                
                % calculate complex cell responses
                model = ComplexPatchNeuron(isaPatches, inds, modelType-1);
                responseField = ResponseField;
                responseField.model = model;
                [ resp ] = responseField.generateHeatmap(loop, 100, stimuli);
                
                diff = abs(squeeze(disp.phase(:,:,1,1) - disp.phase(:,:,1,2)));
                diff(:,:,2) = (2*pi) - abs(squeeze(disp.phase(:,:,1,2) - disp.phase(:,:,1,1)));
                diff = min(diff,[], 3);
                
                % calculate DDI
                ddiStoreComplex(modelType,imageLoop, loop) = disparityDiscriminationIndex(diff(:), resp(:));
                
                phases = squeeze(disp.phase(:,:,1,2));
                phaseInvLeftStoreComplex(modelType,imageLoop, loop) = phaseInvariance(phases(:), resp(:));
                phases = squeeze(disp.phase(:,:,1,1));
                phaseInvRightStoreComplex(modelType,imageLoop, loop) = phaseInvariance(phases(:), resp(:));
                
                respStoreComplex{modelType,imageLoop, loop} = resp;
                dispStoreComplex{modelType,imageLoop, loop} = disp;
            end
            fprintf('.');
            %phaseInv(imageLoop, loop) = phaseInvariance(phases(:), responses(:));
        end
    end
    fprintf('.\n');
    
    % format save responses.
    for modelType = 1:noModels
        responses = respStoreSimple(modelType,:,:,:);
        disps = dispStoreSimple(modelType,:,:,:);
        ddi = ddiStoreSimple(modelType,:,:,:);
        phaseInvLeft = phaseInvLeftStoreComplex(modelType,:,:,:);        
        phaseInvRight = phaseInvRightStoreComplex(modelType,:,:,:);        
        
        save(sprintf('%sModelResponses_%s.mat',plotDirectorySingle, modelTypeNames{modelType}), 'responses', 'disps','-v7.3')
        
        save(sprintf('%sDDI_%s.mat',plotDirectorySingle, modelTypeNames{modelType}), 'ddi')
        
        save(sprintf('%sphaseInv_%s.mat',plotDirectorySingle, modelTypeNames{modelType}), 'phaseInvLeft', 'phaseInvRight')
        
        responses = respStoreComplex(modelType,:,:);
        disps = dispStoreComplex(modelType,:,:);
        ddi = ddiStoreComplex(modelType,:,:);
        phaseInvLeft = phaseInvLeftStoreComplex(modelType,:,:);
        phaseInvRight = phaseInvLeftStoreComplex(modelType,:,:);
        
        save(sprintf('%sModelResponses_%s.mat',plotDirectoryComplex, modelTypeNames{modelType}), 'responses', 'disps','-v7.3')
        
        save(sprintf('%sDDI_%s.mat',plotDirectoryComplex, modelTypeNames{modelType}), 'ddi')
        
        save(sprintf('%sphaseInv_%s.mat',plotDirectoryComplex, modelTypeNames{modelType}), 'phaseInvLeft', 'phaseInvRight')
    end
    
end
