function [ obj ] = setup(obj, patchInfo, dims, varargin)
% Setup the grating stimuli to compare along the specified
% dimensions.
%
% obj = obj.setup(patchInfo, dims, 'key', values , ...)
%
% A PatchInfo object describing the patch to be created.
% dims - vector of integers value showing how many stimuli per-dimension
% (scalar in the 1D case)
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
if ~isa(patchInfo, 'PatchInfo')
    error('A PatchInfo object mustbe supplied');
end

if ~all(isposint(dims))
    error('Dimension sizes must be positive integers');
end

inputDimStructs = obj.setup@GenerateStimuli1D(varargin{:});

if numel(inputDimStructs)~=1
    error('1D Grating generator expects only one dimension');
end

nviews = patchInfo.views;
nlayers = patchInfo.layers;

ndimensions = size(obj.frequency,2);
if numel(dims)==1
    dims(1:ndimensions) = dims;
elseif numel(dims)~=ndimensions
    error('Must supply either a sample size per dimension or a single overal number of samples.');
end

obj.frequency = ones([dims(1), nlayers, nviews]).*obj.defaultFrequency;
obj.phase = ones([dims(1), nlayers, nviews]).*obj.defaultPhase;
obj.orientation = ones([dims(1), nlayers, nviews]).*obj.defaultOrientation;

% as only one dimension is allow this bit is pretty simple
for lloop = 1:nlayers
    for vloop = 1:nviews
        start = inputDimStructs{1}.start(min([size(inputDimStructs{1}.start,1) lloop]),...
            min([size(inputDimStructs{1}.start,2) vloop]));
        e = inputDimStructs{1}.end(min([size(inputDimStructs{1}.end,1) lloop]),...
            min([size(inputDimStructs{1}.end,2) vloop]));
        interp = linspace(start, e, dims(1));
        obj.(inputDimStructs{1}.key)(:, lloop, vloop) = interp;
    end
end


end

