function [patches, patchLocations, relativeIntensityBefore, relativeIntensityAfter ] = cutDifferencePatches(varargin)
% [patches, patchLocations,relativeIntensityBefore, relativeIntensityAfter] = cutDisparityPatches(directory, noPatches, patchSize, scaleFactor)
% cuts the specified number of patches from the images in the images
% directory.
noImages = 139;         % number of images in the 'images' folder
scaleFactor = 1;
patchSize = 25;
noPatches = 100;
directory = '';
normalization = 'magnitude';

% process inputs
if(nargin>=1)
    directory = varargin{1};
end
% find next string input (this marks the beginning of a command
% sequence
commandIndex = -1;
for loop = 2:nargin
    if ischar(varargin{loop})
        commandIndex = loop;
        break;
    end
end
if(nargin>=2 && (commandIndex>2 || commandIndex==-1))
    noPatches = varargin{2};
end
if(nargin>=3 && (commandIndex>3 || commandIndex==-1))
    patchSize = varargin{3};
end
if(nargin>=4 && (commandIndex>4 || commandIndex==-1))
    scaleFactor = varargin{4};
end

if(commandIndex~=-1)
    while(commandIndex<nargin)
        command = varargin{commandIndex};
        arg = varargin{commandIndex+1};
        switch(command)
            case 'normalization'
                normalization = arg;
            otherwise
                error(['Command ', command,' is not understood']);
        end
        commandIndex = commandIndex + 2;
    end
end


if(isscalar(noPatches))
    noPatchesPerImage = ceil(noPatches/noImages);
    
    patchesLeft = noPatches;
    patchLocations = zeros(noPatches,2);
    patches = zeros(noPatches, 2* patchSize * patchSize);
else
    noPatchesPerImage = ceil(size(noPatches,1)/noImages);
    
    patchesLeft = noPatches;
    patchLocations = noPatches;
    patches = zeros(size(patchLocations,1), 2* patchSize * patchSize);
    
end

relativeIntensityBefore = zeros(size(patches,1), 2);
relativeIntensityAfter = zeros(size(patches,1), 2);
for i=1:noImages
    leftImageName = [directory , 'left', num2str(i), '.jpg'];
    rightImageName = [directory , 'right', num2str(i), '.jpg'];
    
    left = imresize(im2double(imread(leftImageName)), scaleFactor);
    right = imresize(im2double(imread(rightImageName)), scaleFactor);
    
    if(isscalar(noPatches))
        [newPatches, newLocations, newRelativeIntensityBefore, newRelativeIntensityAfter] = chop(left, right, min(patchesLeft, noPatchesPerImage), patchSize, normalization);
    else
        [newPatches, newLocations, newRelativeIntensityBefore, newRelativeIntensityAfter] = chop(left, right, patchLocations((i-1)*noPatchesPerImage + 1: min(i*noPatchesPerImage, size(patches,1)),:) , patchSize, normalization);
    end
    
    %  check for null patches
    inds = any(~isfinite(newRelativeIntensityAfter),2);
    inds = find(inds);
    term = 100;
    while ~isempty(inds) 
        if(isscalar(noPatches))
            [newPatches(inds,:), newLocations(inds,:), newRelativeIntensityBefore(inds,:), newRelativeIntensityAfter(inds,:)] = ...
                chop(left, right, length(inds), patchSize, normalization);
        else
            [newPatches(inds,:), newLocations(inds,:), newRelativeIntensityBefore(inds,:), newRelativeIntensityAfter(inds,:)] = ...
                chop(left, right, patchLocations((i-1)*noPatchesPerImage + inds,:) , patchSize, normalization);
        end        
        inds = any(~isfinite(newRelativeIntensityAfter),2);
        inds = find(inds);
        term = term-1;
        if term<=0
            error('Failed to cut enough appropriate patches');
        end
    end
    
    patchLocations((i-1)*noPatchesPerImage + 1: min(i*noPatchesPerImage, size(patches,1)),:) = newLocations;
    
    patches((i-1)*noPatchesPerImage + 1: min(i*noPatchesPerImage, size(patches,1)), :) = newPatches;
    
    relativeIntensityBefore((i-1)*noPatchesPerImage + 1: min(i*noPatchesPerImage, size(patches,1)), :) = newRelativeIntensityBefore;
    relativeIntensityAfter((i-1)*noPatchesPerImage + 1: min(i*noPatchesPerImage, size(patches,1)), :) = newRelativeIntensityAfter;
    
    patchesLeft = patchesLeft - size(newPatches,1);
end


end

function [patches, patchLocations, relativeIntensityBefore, relativeIntensityAfter ] = chop(left, right, noPatches, patchSize, normalization)
[patches, patchLocations] = cutPatchPairs(left, right, noPatches , patchSize, patchSize, normalization);

if isscalar(noPatches)
    relativeIntensityBefore = zeros(noPatches, 2);
    relativeIntensityAfter = zeros(noPatches, 2);
else
    relativeIntensityBefore = zeros(size(noPatches));
    relativeIntensityAfter = zeros(size(noPatches));
end
if size(patches,1)>0
    [left, right] = separatePatchPairs(patches);
    % apply normalization
    switch(normalization)
        case 'magnitude'
            for loop = 1:size(patches,1)
                relativeIntensityBefore(loop,1) = norm(left(loop,:));
                relativeIntensityBefore(loop,2) = norm(right(loop,:));
                left(loop,:) = left(loop,:) - mean(left(loop,:));
                left(loop,:) = left(loop,:) ./ norm(left(loop,:));
                right(loop,:) = right(loop,:) - mean(right(loop,:));
                right(loop,:) = right(loop,:) ./ norm(right(loop,:));
            end
            patches = combinePatchPairs(left,right);
            for loop = 1:size(patches,1)
                patches(loop,:) = patches(loop,:) - mean(patches(loop,:));
                patches(loop,:) = patches(loop,:) ./ norm(patches(loop,:));
                relativeIntensityAfter(loop,1) = norm(patches(loop,1:patchSize*patchSize));
                relativeIntensityAfter(loop,2) = norm(patches(loop,patchSize*patchSize+1:end));
            end
        case 'Logan'
            for loop = 1:size(patches,1)
                relativeIntensityBefore(loop,1) = norm(left(loop,:));
                relativeIntensityBefore(loop,2) = norm(right(loop,:));
                left(loop,:) = left(loop,:) - mean(left(loop,:));
                left(loop,:) = left(loop,:) ./ (1+norm(left(loop,:)));
                right(loop,:) = right(loop,:) - mean(right(loop,:));
                right(loop,:) = right(loop,:) ./ (1+norm(right(loop,:)));
            end
            patches = combinePatchPairs(left,right);
            for loop = 1:size(patches,1)
                patches(loop,:) = patches(loop,:) - mean(patches(loop,:));
                patches(loop,:) = patches(loop,:) ./ norm(patches(loop,:));
                relativeIntensityAfter(loop,1) = norm(patches(loop,1:patchSize*patchSize));
                relativeIntensityAfter(loop,2) = norm(patches(loop,patchSize*patchSize+1:end));
            end
        case 'DingSperling'
            for loop = 1:size(patches,1)
                relativeIntensityBefore(loop,1) = norm(left(loop,:));
                relativeIntensityBefore(loop,2) = norm(right(loop,:));
                left(loop,:) = left(loop,:) - mean(left(loop,:));
                right(loop,:) = right(loop,:) - mean(right(loop,:));
                
                normLeft = norm(left(loop,:));
                normRight = norm(right(loop,:));
                left(loop,:) =  (normLeft./(normLeft+normRight)) .* left(loop,:);
                right(loop,:) =  (normRight./(normLeft+normRight)) .* right(loop,:);
            end
            
            patches = combinePatchPairs(left,right);
            
            for loop = 1:size(patches,1)
                patches(loop,:) = patches(loop,:) - mean(patches(loop,:));
                patches(loop,:) = patches(loop,:) ./ norm(patches(loop,:));
                relativeIntensityAfter(loop,1) = norm(patches(loop,1:patchSize*patchSize));
                relativeIntensityAfter(loop,2) = norm(patches(loop,patchSize*patchSize+1:end));
            end
        otherwise
            error('Unknown normalization type');
    end
    
end
end
