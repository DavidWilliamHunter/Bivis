classdef SimplePatchNeuron < NeuronModel & InvertibleModel
    % Model of a simple linear neuron based on a single patch
    % Simple linear non-linear model 
    % optional half-wave rectification and squaring
    
    properties
        halfwave = 0; % optional rectification (-1 negative 1, postive, 0-none)
        squaring = 1; % raise to the power of
    end
    
    methods
        function obj = SimplePatchNeuron(patches, halfwave, squaring)
            if nargin >= 1
                obj.patches = patches;
            end
            if nargin >= 2
                obj.halfwave = halfwave;
            end
            if nargin >= 3
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
            % responses - the responses of the model to each selected
            % stimuli
            
            if ~all(isposint(selected))
                error('Selected neurons must be positive integers (i.e. indexes on to the patch model.');
            elseif any(selected > obj.patches.getNoPatches)
                error('Indices must be within the range of available patches');
            end
            
            getStimuliData = patchInput.patchData;
            responses = zeros(size(getStimuliData,1), numel(selected));
            for loop = 1:numel(selected)
                getNeuron = obj.patches.patchData(selected(loop), :);
                padNeuron = padarray(getNeuron, [size(getStimuliData,1)-1 0], 'replicate', 'post');
                
                responses(:,loop) = sum(getStimuliData.*padNeuron, 2);
            end
        end
        
        function responses = convolve(obj, img, selected)
            % simulate neuron responses to model by convolution with an
            % image
            %
            % responses = obj.simulate(image, selected)
            %
            % image - ToolBox image formatted image.
            % selected - the neurons selected for the model
            % responses - the responses of the model to each selected
            % stimuli
                       
            
            if ~all(isposint(selected))
                error('Selected neurons must be positive integers (i.e. indexes on to the patch model.');
            elseif any(selected > obj.patches.getNoPatches)
                error('Indices must be within the range of available patches');
            end
            
            responses = zeros(size(img,1), size(img,2), numel(selected));
            for loop = 1:numel(selected)
                getNeuron = obj.patches.getAsMatrix(loop);                
                
                for lloop = 1:size(img,3)
                    for vloop = 1:size(img,4)
                        responses(:,:) = responses(:,:) + ...
                            conv2d(img(:,:,lloop, vloop), getNeuron(:,:,lloop, vloop), 'full');
                    end
                end
            end
        end
         
        function img = reconstruct(obj, img, responses, patchLocations)            
              img = obj.patches.splatPatchSet(img, responses, patchLocations);
        end
        
        
        function [responses ,locations] = decomposeImages(neuronModel, imageSet, width, height, imageInds )
            patches = Patches.sampleFromImages(imageSet, GridSampler, NaN, width, height, imageInds);

            responses = zeros(patches.getNoPatches, neuronModel.getNoModels);
            locations = patches.locations;
            
            for loop = 1:neuronModel.getNoModels
                responses(:,loop) = neuronModel.simulate(patches, loop);
            end
        end
    end
    
end

