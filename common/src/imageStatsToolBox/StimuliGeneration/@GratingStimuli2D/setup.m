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

inputDimStructs = obj.setup@GenerateStimuli2D(varargin{:});

if numel(inputDimStructs)~=2
    error('1D Grating generator expects two dimensions');
end

nviews = patchInfo.views;
nlayers = patchInfo.layers;

ndimensions = 2;
if numel(dims)==1
    dims(1:ndimensions) = dims;
elseif numel(dims)~=ndimensions
    error('Must supply either a sample size per dimension or a single overal number of samples.');
end

obj.frequency = ones([dims, nlayers, nviews]).*obj.defaultFrequency;
obj.phase = ones([dims, nlayers, nviews]).*obj.defaultPhase;
obj.orientation = ones([dims, nlayers, nviews]).*obj.defaultOrientation;


for lloop = 1:nlayers
    for vloop = 1:nviews
        % first dim
        start = inputDimStructs{1}.start(min([size(inputDimStructs{1}.start,1) lloop]),...
            min([size(inputDimStructs{1}.start,2) vloop]));
        e = inputDimStructs{1}.end(min([size(inputDimStructs{1}.end,1) lloop]),...
            min([size(inputDimStructs{1}.end,2) vloop]));
        interp1 = linspace(start, e, dims(1));
        interp1 = padarray(interp1, [ dims(2)-1 0] , 'replicate', 'post');
        % second dim
        start = inputDimStructs{2}.start(min([size(inputDimStructs{2}.start,1) lloop]),...
            min([size(inputDimStructs{2}.start,2) vloop]));
        e = inputDimStructs{2}.end(min([size(inputDimStructs{2}.end,1) lloop]),...
            min([size(inputDimStructs{2}.end,2) vloop]));
        interp2 = linspace(start, e, dims(2));
        interp2 = padarray(interp2, [ dims(1)-1 0] , 'replicate', 'post');      

        obj.(inputDimStructs{1}.key)(:, :, lloop, vloop) = ...
            obj.(inputDimStructs{1}.key)(:, :, lloop, vloop)+ interp1;
        obj.(inputDimStructs{2}.key)(:, :, lloop, vloop) = ...
            obj.(inputDimStructs{2}.key)(:, :, lloop, vloop)+ interp2';
    end
end


end

