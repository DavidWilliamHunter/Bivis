function [ stimuli ] = generate( obj , patchInfo, dims , varargin )
% Generate stimuli by sampling patches along a line
%
% obj = obj.setup(dims, 'key', values , ...)
%
% dims - vector of integers value showing how many stimuli per-dimension
% (scalar in the 1D case)
%
% key values tuples)
% The keys are string donating the parameter to vary in each
% dimension (one per dimension). All non string values are
% parameters and assumed to be key related. Generally the
% pattern is 'key', initial_value, end_value, 'next key',...
%
% valid keys are 'line'
%
% values are vectors equal to the number of views or matrices
% equal to the number of views * number of layers.
%

% need patchInfo

% need dimensions

% need to setup
obj = obj.setup(patchInfo, dims, varargin{:});

nviews = patchInfo.views;
nlayers = patchInfo.layers;
nelements = patchInfo.noElementsTotal;
stimulusSize = patchInfo.boundary;

ndimensions = 1;
if numel(dims)==1
    dims(1:ndimensions) = dims;
elseif numel(dims)~=ndimensions
    error('Must supply either a sample size per dimension or a single overal number of samples.');
end

if ~all(isposint(dims))
    error('Number of samples per dimension must be a positive integer.');
end

% as this is 1D the loop is relatively simple
sampler = DisparitySampler(obj.cutCentre, obj.magnitude, obj.orientation, dims);

if isa(obj.imageSet, 'ImageSet')
    stimuli = Patches.sampleFromImages(obj.imageSet, sampler, dims, patchInfo.width, patchInfo.height, 1);
else
    error('Lone image handling not yet implemented');
end