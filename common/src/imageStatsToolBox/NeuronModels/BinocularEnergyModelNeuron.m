classdef BinocularEnergyModelNeuron < NeuronModel
    % Models a complex neuron using a binocular energy model, ignores any
    % patches assigned, although it will use them to generate a patch size
    
    properties
        patchSize;
        frequency;
        orientation;
        gaussianWindowSD;
        
        neurons;
    end
    
    methods
        function obj = ComplexPatchNeuron(patches, frequency, orientation, gaussianWindowSD)
            obj.patchSize = patches.getPatchSize;
            obj.frequency = frequency;
            obj.orientation = orientation;
            obj.gaussianWindowSD = gaussianWindowSD;
            
            even.n = obj.getPatchSize(1);
            even.xc = obj.getPatchSize(1)./2;
            even.yc = obj.getPatchSize(2)./2;
            even.sigmax = 2;
            even.sigmay = 2;            
            even.gtheta = 0;
            even.freq = 8./even.n;
            even.phi = 0;
            even.theta = 0;
            even.s = 1;
            
            odd = even;
            odd.phi = pi/2;
            
            obj.neurons(1,:) = reshape(gabor2d(even),1,even.n*even.n);
            obj.neurons(2,:) = reshape(gabor2d(odd),1,even.n*even.n);
        end
        
        function responses = simulate(obj, patchInput)
            % simulate neuron responses to model.
            %
            % responses = obj.simulate(patchInput, selected)
            %
            % patchInput - patch object containing stimuli to present to
            % neuron model.

            
            getStimuliData = patchInput.patchData;
            simpleResponses = zeros(size(getStimuliData,1), size(obj.compoundInds,1), numel(selected));
            for loop = 1:numel(selected)
                getNeurons = obj.neurons;
                
                for innerLoop = 1:2
                    padNeuron = padarray(getNeurons(innerLoop,:), [size(getStimuliData,1)-1 0], 'replicate', 'post');
                
                    simpleResponses(:,innerLoop, loop) = sum(getStimuliData.*padNeuron, 2);
                end
            end
            halfrec = -(simpleResponses<0);% - (simpleResponses<0);
            switch(obj.type)
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
            end
        end
        
        function img = reconstruct(obj, img, responses, patchLocations)            
            error('BinocularEnergyModelNeuron:reconstruct not yet implemented');
        end
            
        function [responses ,locations] = decomposeImages(neuronModel, imageSet, width, height, imageInds )
            error('BinocularEnergyModelNeuron:decomposeImages not yet implemented');
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

