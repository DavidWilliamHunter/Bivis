classdef ResponseField
    % Calculate the response of a 'neuron' to a set of (related) stimuli and
    % return the results as a tensor field of scalar values
    
    properties
        generator = GratingStimuli2D;      % class object describing the generation of the stimuli
        model = SimplePatchNeuron;          % the a model of the neuron being tested
    end
    
    methods
        function [ heatmap, data, stimuli ] = generateHeatmap(obj, selected, dims, varargin)
            % [ heatmap, data, stimuli ] = generateHeatmap(obj, selected, dims, varargin)
            
            if numel(varargin)==1
                stimuli = varargin{1};
            else
                patchInfo = obj.model.getPatchInfo;
                [ stimuli , data ] = obj.generator.generate(patchInfo, dims, varargin{:});
            end                       

            responses = obj.model.simulate(stimuli, selected);
            
            heatmap = obj.generator.rearrangeResponses(responses, dims);            
        end
        
    end
    
end

