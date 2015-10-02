function [ stimuli, data ] = generate( obj , patchInfo, dims , varargin )
% Generate grating stimuli
%
% obj = obj.setup(dims, 'key', values , ...)
% [ obj, data ] = obj.setup(dims, 'key', values , ...)
%
% dims - vector of integers value showing how many stimuli per-dimension
% (2 elements in the 2D case)
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
stimulusSize = patchInfo.boundary(1:2);

ndimensions = 2;
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

width = zeros(dims(1), dims(2), nlayers, nviews);
position = zeros(dims(1), dims(2), nlayers, nviews);
orientation = zeros(dims(1), dims(2), nlayers, nviews);
tempStimuli = zeros(dims(1), dims(2), nelements);
% as this is 1D the loop is relatively simple
for loop1d = 1:dims(1)
    parfor loop2d = 1:dims(2)
        newPatch = zeros([stimulusSize nlayers nviews]);
        for lloop = 1:nlayers
            for vloop = 1:nviews
                localPatch = BarStimuli2D.renderBar(stimulusSize, ...
                    obj.width(loop1d, loop2d, lloop, vloop), ...
                    obj.position(loop1d, loop2d, lloop, vloop), ...
                    obj.orientation(loop1d, loop2d, lloop, vloop));
                %if nargout >= 2
                    width(loop1d, loop2d, lloop, vloop) = obj.width(loop1d, loop2d, lloop, vloop);
                    position(loop1d, loop2d, lloop, vloop) = obj.position(loop1d, loop2d, lloop, vloop);
                    orientation(loop1d, loop2d, lloop, vloop) = obj.orientation(loop1d, loop2d, lloop, vloop);
                %end
                %localPatch = localPatch ./ norm(localPatch(:));
                %localPatch = localPatch - mean(localPatch(:));
                newPatch(:, :, lloop, vloop) = localPatch;
            end
        end
        %newPatch = newPatch ./ norm(newPatch(:));
        %newStimuli((loop1d-1) + (loop2d-1)*dims(1) + 1, :) = reshape(newPatch, nelements, 1);
        tempStimuli(loop1d,loop2d,:) = reshape(newPatch, nelements,1);
    end    
end

for loop1d = 1:dims(1)
    for loop2d = 1:dims(2)
        newStimuli((loop1d-1) + (loop2d-1)*dims(1) + 1, :) = tempStimuli(loop1d,loop2d,:);
    end
end
    
data.width = width;
data.position = position;
data.orientation = orientation;
stimuli.patchData = newStimuli;
            