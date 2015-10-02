function [ img ] = splatPatches( obj, img, patchID, locations, op )
% Draw patches onto the image.
%
% [ img ] = obj.splatPatches( img, patchID, locations, op )
%
% img - An image with the same number of
% views and layers as the patches.
% patchID - a vector of  integer from 1 to the number of patches in the patch object, indicating which patch to render onto the image.
% If the vector is of length 1, the same patch will be used for all
% locations.
% locations - 4D tensor, [ number of patches, 2, number of views, number of layers ],
% a list of 2D locations with in the image to render the
% patches to. This list must be of the same length as patchID (unless
% patchID is of length 1, in which case it can be any length).
% op - [optional] function handle -the operation to use when combining
% pixels. Default simple replacement.

if nargin < 5
    op = [];
end
    

if numel(patchID)==1
    patchID = repmat(patchID, size(locations,1), 1);
end

patchID = ceil(patchID);  % force integer

if numel(patchID) ~= size(locations,1)
    error('Number of patch IDs must match the number of locations');
end

nPatches = size(locations, 1);

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
for patchLoop = 1:nPatches
    patch = obj.getPatchAsMatrix(patchID(patchLoop));    
    for lLoop = 1:obj.layers
        for vLoop = 1:obj.views
            left = locations(patchLoop, 1, lLoop, vLoop) - halfWidth;
            if left < 1
                leftTrim = -left + 1;
                left = 1;
            else
                leftTrim = 1;
            end
            
            top = locations(patchLoop, 2, lLoop, vLoop) - halfHeight;
            if top < 1
                topTrim = -top + 1;
                top = 1;
            else
                topTrim = 1;
            end
            
            right = locations(patchLoop, 1, lLoop, vLoop) + halfWidth;
            if right > imWidth
                rightTrim = imWidth - right + width;
                right = imWidth;
            else
                rightTrim = width;
            end
            
            bottom = locations(patchLoop, 2, lLoop, vLoop) + halfHeight;
            if bottom > imHeight
                bottomTrim = imHeight - bottom + height;
                bottom = imHeight;
            else
                bottomTrim = height;
            end
            
            localPatch = patch(leftTrim:rightTrim, topTrim:bottomTrim, lLoop, vLoop);
            
            if ~isempty(op)
                img(left:right, top:bottom) = op(img(left:right, top:bottom), localPatch);
            else
                img(left:right, top:bottom) = localPatch;
            end
        end
    end
end


end

