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

ndimensions = 1;
if numel(dims)==1
    dims(1:ndimensions) = dims;
elseif numel(dims)~=ndimensions
    error('Must supply either a sample size per dimension or a single overal number of samples.');
end

obj.halfDirection = [ 0 0 ];

% in this version we only need to convert disparity and (optional) orientation
% data with the halfDirection vector format
switch(inputDimStructs{1}.key)
    case 'line'
        halfMag = inputDimStructs{1}.start(1)./2;
        orient = inputDimStructs{1}.start(2);
        obj.halfDirection = [sin(orient).*halfMag cos(orient).*halfMag];
end

end

