function [ img ] = splatPatchSet( obj, img, patchWeights, locations, op )
% Draw patches onto the image.
%
% [ img ] = obj.splatPatches( img, patchID, locations, op )
%
% img - An image with the same number of
% views and layers as the patches.
% patchWeights - a 2D matrix of weighting data for the patches, the values
% of pixels in each patch is multiplied by this weight before splatting
% onto the image. Each row relates to the locations, each column to a
% particular patch, therefor the matrix must by no_locations x no_patches
% in size.
% locations - 4D tensor, [ number of patches, 2, number of views, number of layers ],
% a list of 2D locations with in the image to render the
% patches to. This list must be of the same length as patchID (unless
% patchID is of length 1, in which case it can be any length).
% op - [optional] function handle -the operation to use when combining
% pixels. Default simple replacement.

if nargin < 5
    op = [];
end


if numel(patchWeights)==1
    patchWeights = repmat(patchWeights, size(locations,1), obj.getNoPatches);
end

if size(patchWeights,2)~=obj.getNoPatches
    error('Size of patch wieghts must match number of patches.');
end

if size(patchWeights,1)~=size(locations,1)
    error('Size of patch wieghts must match number of locations.');
end

nLocations = size(locations, 1);
nPatches = obj.getNoPatches;
nElements = obj.getNoElements;

% check image for appropriate dimensions
if ndims(img)~=4 && obj.layers~=1 && obj.views~=1
    error('Number of dimensions in the image must match the number of dimensions in the patch object');
end
if size(img,3) ~= obj.layers
    error('Number of dimensions in the image must match the number of dimensions in the patch object');
end
if size(img,4) ~= obj.views
    error('Number of dimensions in the image must match the number of dimensions in the patch object');
end

% check locations for appropriate dimensions
if ndims(locations)~=4 && obj.layers~=1 && obj.views~=1
    error('Number of dimensions in the locations tensor must match the number of dimensions in the patch object');
end
if size(locations,3) ~= obj.layers
    error('Number of dimensions in the locations tensor must match the number of dimensions in the patch object');
end
if size(locations,4) ~= obj.views
    error('Number of dimensions in the locations tensor must match the number of dimensions in the patch object');
end

% get patch dimensions
[width,height] = obj.getPatchBounds();

% set bounds in which to cut patches
halfWidth = floor( (width - 1 ) / 2);
halfHeight = floor( (height - 1) / 2);

imWidth = size(img,1);
imHeight = size(img,2);
for locationLoop = 1:nLocations
    
    patch = obj.patchData' .* repmat(patchWeights(locationLoop,:), nElements, 1);
    patch = reshape(sum(patch,2), width, height, obj.layers, obj.views);
    for lLoop = 1:obj.layers
        for vLoop = 1:obj.views
            left = locations(locationLoop, 1, lLoop, vLoop) - halfWidth;
            if left < 1
                leftTrim = -left + 1;
                left = 1;
            else
                leftTrim = 1;
            end
            
            top = locations(locationLoop, 2, lLoop, vLoop) - halfHeight;
            if top < 1
                topTrim = -top + 1;
                top = 1;
            else
                topTrim = 1;
            end
            
            right = locations(locationLoop, 1, lLoop, vLoop) + halfWidth;
            if right > imWidth
                rightTrim = imWidth - right + width;
                right = imWidth;
            else
                rightTrim = width;
            end
            
            bottom = locations(locationLoop, 2, lLoop, vLoop) + halfHeight;
            if bottom > imHeight
                bottomTrim = imHeight - bottom + height;
                bottom = imHeight;
            else
                bottomTrim = height;
            end
            
            localPatch = patch(leftTrim:rightTrim, topTrim:bottomTrim, lLoop, vLoop);
            
            if ~isempty(op)
                img(left:right, top:bottom, lLoop, vLoop) = op(img(left:right, top:bottom), localPatch);
            else
                img(left:right, top:bottom, lLoop, vLoop) = localPatch;
            end
        end
    end
end
end