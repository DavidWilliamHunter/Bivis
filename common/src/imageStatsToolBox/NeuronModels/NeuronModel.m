classdef NeuronModel
    % A base class for models of neuron (normally based on models learned
    % from patches)
    
    properties
        patches;            % the patch set used in the model
    end
    
    methods
        function obj = NeuronModels(patches)
            % Create new NeuronModel
            % obj = NeuronModels(patches)
            obj.patches = patches;
        end
        
        function patchInfo = getPatchInfo(obj)
            patchInfo = obj.patches.getPatchInfo();
        end
        
        function num = getNoModels(obj)
            num = obj.patches.getNoPatches;
        end
    end
    
    
end

