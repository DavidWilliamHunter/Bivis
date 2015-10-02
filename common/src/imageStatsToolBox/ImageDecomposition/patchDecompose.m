function [ responses, locations ] = patchDecompose( neuronModel, imageSet, width, height, imageInds )
% Decompose an image by dividing the image into patches (size determined by
% the NeuronModel and running the linear NeuronModel on each patch
% separately. Based on the following assumptions, NeuronModel based on
% simple linear model (fully described using inner-product), components are
% orthogonal (and for preference orthonormal).
%
%
% Note colour model not yet implemented.

if ~isa(neuronModel, 'NeuronModel')
    error('First Parameter must be a NeuronModel, see help patchDecompose');
end


patches = Patches.sampleFromImages(imageSet, GridSampler, NaN, width, height, imageInds);

responses = zeros(patches.getNoPatches, neuronModel.getNoModels);
locations = patches.locations;

for loop = 1:neuronModel.getNoModels
    responses(:,loop) = neuronModel.simulate(patches, loop);
end


end

