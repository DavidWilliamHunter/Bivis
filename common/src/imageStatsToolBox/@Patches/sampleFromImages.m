function [ patchObj ] = sampleFromImages(  varargin  )
    % Sample a set of image patches from a list of images. Completely replaces
    % patch image location.
    %
    % [ patchObj ] = sampleFromImages( imageSet, noPatches, width, height [, imageInds] )
    % [ patchObj ] = sampleFromImages( imageSet, sampler, noPatches, width, height [,imageInds] )
    imageSet = varargin{1};

    if ~isa(imageSet, 'ImageSet')
        error('Image set must be an instance of an ImageSet class or subclass.');
    end

    if isa(varargin{2}, 'PatchSampler')
        sampler = varargin{2};
        noPatches = varargin{3};
        patchWidth = varargin{4};
        patchHeight = varargin{5};

        if nargin >= 6
            scenes = varargin{6};
            if ~all(isposint(scenes))
                error('Image indices (fifth parameter) must be positive integers.');
            end
        else
            scenes = 1:imageSet.noScenes;
        end

    else
        sampler = RandomSampler;
        noPatches = varargin{2};
        patchWidth = varargin{3};
        patchHeight = varargin{4};
        if nargin >= 5
            scenes = varargin{5};
            if ~all(isposint(scenes))
                error('Image indices (fourth parameter) must be positive integers.');
            end
        else
            scenes = 1:imageSet.noScenes;
        end
    end


    noLayers = imageSet.noLayers;
    noViews = imageSet.noViews;
    patchObj = Patches(patchWidth, patchHeight, noLayers, noViews);

    %patchObj.locations = sampler.generateSampleLocationsFromImage(noPatches, [patchWidth patchHeight], imageSet.imageSize);
    %noPatches = size(patchObj.locations,1);

    patchObj.locations = zeros(noPatches, 2, patchObj.layers, patchObj.views);
    noElements = patchObj.getNoElements();

    patchObj.patchData = zeros(noPatches, noElements);

    patchesPerImage = ceil(noPatches/numel(scenes));
    patchesRemaining = noPatches;

    count = 1;
    for loop = scenes
        currentImage = imageSet.getImage(loop);
        %range =patchesPerImage*(count-1)+1:patchesPerImage*count;
        range = (0:-1:-patchesPerImage+1) + patchesRemaining;
        newLocations = sampler.generateSampleLocationsFromImageSet(patchesPerImage, [patchWidth patchHeight], imageSet, loop);
        patchObj.locations(range,:,:,:) = round(newLocations);
        patchObj.patchData(range,:) = ...
            patchObj.cutPatches(currentImage, patchObj.locations(range,:,:,:));
        patchesRemaining = patchesRemaining - patchesPerImage;
        patchesPerImage = min([patchesPerImage patchesRemaining]);
        count = count + 1;
    end
end

