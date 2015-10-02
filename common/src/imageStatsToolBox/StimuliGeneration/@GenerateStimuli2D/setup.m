function [ inputDimStructs ] = setup(obj, varargin)
% Setup the grating stimuli to compare along the specified
% dimensions.
%
% obj = obj.setup('key', values , ...)
%
% key values tuples)
% The keys are string donating the parameter to vary in each
% dimension (one per dimension). All non string values are
% parameters and assumed to be key related. Generally the
% pattern is 'key', initial_value, end_value, 'next key',...
%
% valid keys are 'frequency', 'phase', 'orientation'
%
% values are vectors equal to the number of views or matrices
% equal to the number of views * number of layers.
%
% The return variable inputDimStructs is a cell array of structs containing
% the processed input information (with some blanks filled in with defualt
% values.
%
% struct.key  - string the name of the parameter to be altered.
% struct.start - scalar array of the initial parameters for the stimuli.
%               Layers in the first dimension, views, in the second.
% struct.end - scalar array of the final values for the varied parameters.



if isempty(varargin)
    error('Must supply at least one direction for stimuli creation');
end

searchloc = 1;
readDims = 0;
inputDimStructs = {};
while searchloc <= numel(varargin)
    if ischar(varargin{searchloc})
        key = varargin{searchloc};
        if ~any(strcmpi(key, obj.validKeys))
            error('String values must be valid keys, e.g. %s.', obj.validKeys{1});
        end
        readDims = readDims + 1;
        newDim = struct;
        newDim.key = key;
        newDim.start = [];
        newDim.end = [];
        inputDimStructs{readDims} = newDim;
    elseif isnumeric(varargin{searchloc})
        if isempty(inputDimStructs{readDims}.start)
            inputDimStructs{readDims}.start = varargin{searchloc};
        elseif isempty(inputDimStructs{readDims}.end)
            if ndims(varargin{searchloc}) ~= ndims(inputDimStructs{readDims}.start)
                error('Start and end values must have the same number of dimensions');
            end
            if size(varargin{searchloc}) ~= size(inputDimStructs{readDims}.start)
                error('Start and end values must be the same size');
            end
            inputDimStructs{readDims}.end = varargin{searchloc};
        else
            error('Too many numeric values');
        end
    else
        error('Unknown input type');
    end
    searchloc = searchloc + 1;
end

if isempty(inputDimStructs)
    inputDimStructs = { struct };
    inputDimStructs.key = 'all';
    inputDimStructs{1}.start = -1.0;
    inputDimStructs{1}.end = 1.0;
end
