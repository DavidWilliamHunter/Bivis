classdef PatchOperation
    % An operation defined on patch data.
    % Classes inheriting from this one implement one (or more) functions
    % that operate on the patch data.
    %
    % Classes can also provide meta-data e.g. to a GUI or to allow for
    % interfacing with the Patch class or those classes which inherit from
    % Patch
    %
    
    
    
    methods
        function [ retPatchObj ] = run(varargin)
            % [ retPatchObj ] = PatchOperation.run(varargin)
            %
            % Bases classes implement this for all functions
            error('PatchOperation:run not implemented in base class');
        end        
    end
    
end

