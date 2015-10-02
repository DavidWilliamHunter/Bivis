function [ patchObj ] = sampleFromImages(  varargin  )
% Sample a set of image patches from a list of images. Completely replaces
% patch image location.
%
% [ patchObj ] = sampleFromImages( imageSet, noPatches, radius  [, imageInds] )
% [ patchObj ] = sampleFromImages( imageSet, sampler, noPatches, radius  [, imageInds])
    imageSet = varargin{1};

    if ~isa(imageSet, 'ImageSet')
        error('Image set must be an instance of an ImageSet class or subclass.');
    end
    
    if isa(varargin{2}, 'PatchSampler')
        sampler = varargin{2};
        noPatches = varargin{3};
        radius = varargin{4};
    else
        sampler = RandomSampler;
        noPatches = varargin{2};
        radius = varargin{3};
    end
       
    if nargin >= 5
        scenes = varargin{5};
        if ~all(isposint(scenes))
            error('Image indices (fourth parameter) must be positive integers.');
        end
    else
       scenes = 1:imageSet.noScenes;
    end
    
    noLayers = imageSet.noLayers();
    noViews = imageSet.noViews();
    patchObj = CircularPatches(radius, noLayers, noViews);
    
%     patchObj.locations = sampler.generateSampleLocationsFromImage(noPatches, patchObj.getPatchBounds(), imageSet.imageSize());
%     

    patchObj.locations = zeros(noPatches, 2, patchObj.layers, patchObj.views);
    noElements = patchObj.getNoElements();

    
    patchObj.patchData = zeros(noPatches, noElements);
       
    patchesPerImage = ceil(noPatches/numel(scenes));
    patchesRemaining = noPatches;
    
    count = 1;
    currentLocation = 1;
    for loop = scenes
        currentImage = imageSet.getImage(loop);
        range = currentLocation:currentLocation+patchesPerImage-1; %patchesPerImage*(count-1)+1:patchesPerImage*count;
        newLocations = sampler.generateSampleLocationsFromImageSet(patchesPerImage, patchObj.getPatchBounds(), imageSet, loop);
        if size(newLocations,1)<length(range)
            range = range(1:size(newLocations,1));
        end
        if ~isempty(range)
            patchObj.locations(range,:,:,:) = round(newLocations);
            patchObj.patchData(range,:) = ...
                patchObj.cutPatches(currentImage, patchObj.locations(range,:,:,:));
        end
        patchesRemaining = patchesRemaining - length(range);
        currentLocation = currentLocation + length(range);
        patchesPerImage = min([patchesPerImage patchesRemaining]);
        count = count + 1;
    end
    if currentLocation < noPatches
        if currentLocation<=1
            patchObj.patchData = [];
        else
            patchObj.patchData = patchObj.patchData(1:currentLocation-1,:,:,:);
        end
        warning('unable to cut enough patches to fullfill demand');
    end
end

