function [ stimuli ] = generate( obj , patchInfo, dims , varargin )
% Generate grating stimuli
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
% valid keys are 'frequency', 'phase', 'orientation'
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

ndimensions = size(obj.frequency,2);
if numel(dims)==1
    dims(1:ndimensions) = dims;
elseif numel(dims)~=ndimensions
    error('Must supply either a sample size per dimension or a single overal number of samples.');
end

if ~all(isposint(dims))
    error('Number of samples per dimension must be a positive integer.');
end

stimuli = Patches(patchInfo);

newStimuli = zeros(prod(dims), nelements);

% as this is 1D the loop is relatively simple
for loop = 1:dims(1)
    newPatch = zeros([stimulusSize nlayers nviews]);
    for lloop = 1:nlayers
        for vloop = 1:nviews
            localPatch = cos2d(stimulusSize(1), ...
                obj.frequency(loop, lloop, vloop), ...
                obj.phase(loop, lloop, vloop), ...
                obj.orientation(loop, lloop, vloop), ...
                stimulusSize(1)./2, stimulusSize(2)./2);
            newPatch(:,:, lloop, vloop) = localPatch;
        end
    end
    %newPatch = newPatch ./ sum(newPatch(:));
    newStimuli(loop, :) = reshape(newPatch, nelements, 1);
end
    
stimuli.patchData = newStimuli;
            