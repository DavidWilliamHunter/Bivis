%%
% Model and outputs complex cell responses using grating stimuliclear all

% some basic directory setup

display('Loading Data');
plotDirectoryComplex = '..\src\plots\2\bars\';
plotDirectorySingle = '..\plots\2\barsSingle\';
gaborDirectory = '../data/2/';
%gaborDirectory = 'E:\documents\isa_data/';
%gaborDirectory = 'E:\Matlab\ISA_data\4\';
nbootstraps = 200;

% fileName = sprintf('%sisaSetup.mat', gaborDirectory)
% load(fileName)
subspacesize = 2;

modelTypeNames = {'Squared_barsSingle','AbsMaxPooled_barsSingle', 'SquaredHalfRec_barsSingle', 'MaxPooledHalfRec_barsSingle', 'SquaredFullRec_barsSingle','MaxPooledExhMaxPooledInhib_barsSingle','SimpleSum_barsSingle','MaxPooledUnRectified_barsSingle'};
modelTypeNames = {'Squared_barsSingle','AbsMaxPooled_barsSingle'};

offset = 1;

images = 1:6;

noModels = numel(modelTypeNames);
noComplexComponents = 200;
subspacesize = 2;

ddiStoreComplex = zeros(noModels, numel(images), noComplexComponents);
phaseInvStoreComplex = zeros(noModels, numel(images), noComplexComponents);
respStoreSimple = cell(noModels, numel(images), noComplexComponents,subspacesize);
dispStoreSimple = cell(noModels, numel(images), noComplexComponents,subspacesize);
respStoreComplex = cell(noModels, numel(images), noComplexComponents);
dispStoreComplex = cell(noModels, numel(images), noComplexComponents);

%for imageLoop = [1 3:11 13:19 ]%1:6
for imageLoop = images%1:6
    
    fileNameGabors = sprintf('%sisaFittedGabors_%i.mat', gaborDirectory, imageLoop)
    fileName = sprintf('%sisa_%i.mat', gaborDirectory, imageLoop)
    S = load(fileNameGabors, 'gabors');
    
    gabors = Gabor2D(S.gabors);
    
    clear S
    
    % load ISA patch data
    info = PatchInfo(1,2, 25*25*2, [25 25]);
    isaPatches = Patches.import('Filename', fileName, 'PatchInfo', info, 'PatchData', 'Wisa');
    
    % normalise component energy.
    %isaPatches.patchData = orthogonalizerows(isaPatches.patchData);
    isaPatches = isaPatches.patchNormalise;
    
    %Generate cosine stimuli
    
    
    % define complex model
    inds = reshape(1:isaPatches.getNoPatches, subspacesize, isaPatches.getNoPatches/subspacesize);
    %isaPatches.patchData = randn(size(isaPatches.patchData));
    
    
    
    for loop = 1:noComplexComponents
        %Generate cosine stimuli using the principal orientation and frequency
        %of the component.
        gabor = gabors.select(inds(1,loop),1);
        if gabor.isValid
            % pre generate stimuli
            responseField.generator = BarStimuli2D(1/(2*gabor.frequency), 0, gabor.orientation);
            patchInfo = isaPatches.getPatchInfo;
            [ stimuli , disp ] = responseField.generator.generate(patchInfo, 25, 'position', [0 0], [1 0], 'position', [0 0], [0 1]);
            
            for modelType = 1:noModels
                % setup simulation                
                simpleModel = ComplexPatchNeuron(isaPatches, 1:isaPatches.getNoPatches, -1); % create single cell models by specify a complex cell with only one sub-unit.
                responseField = ResponseField;
                responseField.model = simpleModel;
                
                % calculate simple cell data first                
                simpleInds = inds(:,loop);
                for simpleLoop = 1:numel(simpleInds)
                    % generate heatmap from simulated responses                    
                    [ resp ] = responseField.generateHeatmap(simpleInds(simpleLoop), 25, stimuli);
                    respStoreSimple{modelType, imageLoop, loop, simpleLoop} = resp;
                    dispStoreSimple{modelType, imageLoop, loop, simpleLoop} = disp;
                end
                
                % calculate complex cell responses                
                model = ComplexPatchNeuron(isaPatches, inds, modelType-1);
                responseField = ResponseField;
                responseField.model = model;
                [ resp ] = responseField.generateHeatmap(loop, 25, stimuli);
                                
                respStoreComplex{modelType,imageLoop, loop} = resp;
                dispStoreComplex{modelType,imageLoop, loop} = disp;
            end
            fprintf('.');
        end
    end
    fprintf('.\n');

    % format responses for saving    
    for modelType = 1:noModels
        responses = respStoreSimple(modelType,:,:,:);
        disps = dispStoreSimple(modelType,:,:,:);
        
        save(sprintf('%sModelResponses_%s.mat',plotDirectorySingle, modelTypeNames{modelType}), 'responses', 'disps','-v7.3')

        responses = respStoreComplex(modelType,:,:);
        disps = dispStoreComplex(modelType,:,:);

        save(sprintf('%sModelResponses_%s.mat',plotDirectoryComplex, modelTypeNames{modelType}), 'responses', 'disps','-v7.3')

    end
    
end
