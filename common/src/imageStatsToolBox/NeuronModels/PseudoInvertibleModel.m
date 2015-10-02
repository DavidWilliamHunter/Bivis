classdef PseudoInvertibleModel
    % A basic abstract providing functions to decompose and manipulate the
    % responses of a neuron model.
    %
    % Generally the results of a decomposition are not stored in the Neuron
    % object but in a separate class or struct created and understood by
    % the neuron implementation.
    
    properties
    end
    
    methods(Abstract)
        [ responses , locations] = decomposeImages(neuronModel, imageSet, width, height, imageInds );
    end
    
end

