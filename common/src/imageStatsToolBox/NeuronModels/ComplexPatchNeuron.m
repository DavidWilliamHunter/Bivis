classdef ComplexPatchNeuron < NeuronModel
    % Model of a complex linear neuron based on a set of patches
    % Simple linear non-linear model 
    % optional half-wave rectification and squaring
    
    properties
        compoundInds = []; % a 2d array of positive integers indexing the complex model 
        halfwave = 0; % optional rectification (-1 negative 1, postive, 0-none)
        squaring = 1; % raise to the power of
        type = 0;% the type of complex neuron to model, 0 for sumsq, 1
                % for max pool. 
    end
    
    methods
        function obj = ComplexPatchNeuron(patches, compoundInds, type, halfwave, squaring)
            if nargin >= 1
                obj.patches = patches;
            end
            if nargin >= 2
                obj.compoundInds = compoundInds;
            end
            if nargin >= 3
                obj.type = type;
            end
            if nargin >= 4
                obj.halfwave = halfwave;
            end
            if nargin >= 5
                obj.squaring = squaring;
            end
        end
        
        function responses = simulate(obj, patchInput, selected)
            % simulate neuron responses to model.
            %
            % responses = obj.simulate(patchInput, selected)
            %
            % patchInput - patch object containing stimuli to present to
            % neuron model.
            % selected - the neurons selected for the model
            % type - the type of complex neuron to model, 0 for sumsq, 1
            % for max pool.
            % responses - the responses of the model to each selected
            % stimuli
            if nargin<4
                type = 0;
            end
            
            if ~all(isposint(selected))
                error('Selected neurons must be positive integers (i.e. indexes on to the patch model.');
            elseif any(selected > obj.patches.getNoPatches)
                error('Indices must be within the range of available patches');
            end
            
            getStimuliData = patchInput.patchData;
            simpleResponses = zeros(size(getStimuliData,1), size(obj.compoundInds,1), numel(selected));
            for loop = 1:numel(selected)
                modelNeurons = obj.compoundInds(:,selected);
                getNeurons = obj.patches.patchData(modelNeurons, :);
                
                for innerLoop = 1:numel(modelNeurons)
                    padNeuron = padarray(getNeurons(innerLoop,:), [size(getStimuliData,1)-1 0], 'replicate', 'post');
                
                    simpleResponses(:,innerLoop, loop) = sum(getStimuliData.*padNeuron, 2);
                end
            end
            halfrec = -(simpleResponses<0);% - (simpleResponses<0);
            switch(obj.type)
                case -1
                    responses = simpleResponses;
                case 0 
                    responses = sum(simpleResponses.^2,2);
                case 1
                    responses = max(abs(simpleResponses), [], 2);
                case 2
                    halfrec = simpleResponses;
                    halfrec(halfrec<0) = 0;
                    responses = sum(halfrec.^2,2);               
                case 3
                    halfrec = simpleResponses;
                    halfrec(halfrec<0) = 0;                    
                    responses = max(halfrec, [], 2);
                case 4
                    inds = simpleResponses<0;
                    respSq = simpleResponses.^2;
                    respSq(inds) = -respSq(inds);
                    responses = sum(respSq,2);
                case 5
                    halfrecplus = simpleResponses;
                    halfrecplus(halfrecplus<0) = 0;    
                    halfrecminus = -simpleResponses;
                    halfrecminus(halfrecminus<0) = 0;                      
                    responsesPlus = max(halfrecplus, [], 2);
                    responsesMinus = max(halfrecminus, [], 2);
                    responses = responsesPlus - responsesMinus;
                case 6
                    responses = sum(simpleResponses,2);
                case 7
                    halfrecplus = simpleResponses;
                    halfrecplus(halfrecplus<0) = 0;    
                    halfrecminus = -simpleResponses;
                    halfrecminus(halfrecminus<0) = 0;                      
                    responsesPlus = max(halfrecplus, [], 2);
                    responsesMinus = max(halfrecminus, [], 2);
                    responses = responsesPlus;
                    responses(responsesPlus < responsesMinus) = -responsesMinus(responsesPlus < responsesMinus);
                    
            end
        end
        
        function img = reconstruct(obj, img, responses, patchLocations)            
%             for lLoop = 1:size(patchLocations,1)
%                 expandedResponses(obj.compoundInds) = responses(lLoop, repmat(1:80, 4, 1));           
%                 
%                 for rLoop = 1:numel(expandedResponses)
%                     img = obj.patches.splatPatchSet(img, 2, patchLocations(lLoop,:,:,:), @(u,v) u+(v.*expandedResponses(rLoop)));
%                 end
%             end

%             expandedResponses = zeros(size(patchLocations,1), obj.patches.getNoPatches);
%             for lLoop = 1:size(patchLocations,1)
%                 %temp(obj.compoundInds) = responses(lLoop, repmat(1:size(responses,2), 4, 1));           
%                 temp = zeros(1,320);
%                 temp(obj.compoundInds(1,:)) = responses(lLoop,:);                
%                 expandedResponses(lLoop, :) = temp(:);
%             end
%               img = obj.patches.splatPatchSet(img, expandedResponses, patchLocations);
            adjusted = responses.simple;
            for qloop = 1:size(adjusted,1)
                for cloop = 1:getNoModels(obj)
                    m = max(adjusted(qloop,obj.compoundInds(:,cloop)).^2);
                    a = responses.complex(qloop, cloop)./m;
                    adjusted(qloop,obj.compoundInds(:,cloop)) = ...
                        adjusted(qloop,obj.compoundInds(:,cloop)) .* a;
                end
            end
            img = obj.patches.splatPatchSet(img, adjusted, patchLocations);
                    
        end
            
        function [responses ,locations] = decomposeImages(neuronModel, imageSet, width, height, imageInds )
            patches = Patches.sampleFromImages(imageSet, GridSampler, NaN, width, height, imageInds);

            responses.simple = zeros(patches.getNoPatches, neuronModel.getNoModels);
            locations = patches.locations;
            
            simple = SimplePatchNeuron(neuronModel.patches, neuronModel.halfwave, neuronModel.squaring);
            
            responses.simple = simple.simulate(patches, 1:simple.getNoModels);
            
            for loop = 1:neuronModel.getNoModels
                responses.complex(:,loop) = neuronModel.simulate(patches, loop);
            end
        end
        
        
        function num = getNoModels(obj)
            num = size(obj.compoundInds,2);
        end
        
        function [ expandedResponses ] = expandResponses(obj, responses)
            temp = repmat(responses(:), 1, 4);
            expandedResponses = temp(obj.compoundInds);
        end
    end
    
end

