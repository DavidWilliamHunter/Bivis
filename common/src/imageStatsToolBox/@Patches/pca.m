function [newObj,ave, d, w, prob, varExplained] = pca(obj, k, ordering)
% Perform Principal components analysis on the patches
%
% [newObj,[d, [w]]] = obj.pca([k ,[ ordering]])
%
% k - scalar integer then number of pca's to compute.
% ordering - vector of integer indices on the patches, used to
% reorder for e.g. bootstapping
%
% newObj - a new Patches object containing the PCAs vectors in
% order.
% ave - the centre of the PCA model.
% d - diagonal eigenvalues
% w - wieghts on each patch
% prob - Hotelling T squared on the scores (weights)
% varExplained - Total variance explained by the generated components
if nargin<2
    k = size(obj.patchData,1);
end
if nargin<3
    ordering = 1:size(obj.patchData,1);
end

[V, w, d, prob, varExplained, ave] = pca(obj.patchData(ordering, :), 'Centered', true,'Algorithm', 'svd', 'NumComponents', k, 'Rows', 'complete');

newObj = obj;
newObj.patchData = V';


