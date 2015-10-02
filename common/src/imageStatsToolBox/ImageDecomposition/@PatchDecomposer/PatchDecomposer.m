classdef PatchDecomposer
    % Decompose (and potentially reconstruct) and image by dividing the
    % image into rectangular patches, the linear model is computed on the
    % patches and the results stored.
    
    properties
        neuronModel;
    end
    
    properties(Dependent)
        patchSize;
        patchWidth;
        patchHeight;
    end
    
    methods
        function obj = PatchDecompose(model)
            % obj = PatchDecompose(model)
            obj.neuronModel = model;
        end
        
        function 
    end
    
end

