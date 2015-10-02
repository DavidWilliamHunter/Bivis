classdef PatchSampler
    %PATCHSAMPLER Cut patches from an image or collection of images
    % abstract base class
    
    properties
    end
    
    methods(Access = public)
        function [ patchLocations ] = generateSampleLocationsFromImage(obj, noPatches, patchSize, imageSize)
            % Return a set patch sample locations across a single image.
            % 
            % patchLocations = obj.sampleFormImage(noPatches, patchSize, imageSize)
            % 
            % noPatches - Scalar integer, number of patch locations to generate.
            % patchSize - Vector of doubles, size of patch to cut, depends on patch description.
            % imageSize - Size of the image in [ width height noLayers noViews ]            
            error('Not implemenented in abstract class');
        end   
        
        function [ patchLocations ] = generateSampleLocationsFromImageSet(obj, noPatches, patchSize, imageSet, imageNo)
            % Return a set patch sample locations across an image set.
            % 
            % patchLocations = obj.generateSampleLocationsFromImageSet(noPatches, patchSize, imageSet)
            % patchLocations = obj.generateSampleLocationsFromImageSet(noPatches, patchSize, imageSet, imageNo)
            % 
            % noPatches - Scalar integer, number of patch locations to generate.
            % patchSize - Vector of doubles, size of patch to cut, depends on patch description.
            % imageSet  - ImageSet object
            % imageNo   - [optional] scalar integer, image number in the image set.
            
            % By default this simply calls generateSampleLocationsFromImage
            % to get samples independent of image set data.
            if ~isa(imageSet, 'ImageSet')
                error('PatchSampler:generateSampleLocationsFromImageSet imageSet must be an image set object');
            end
            
            patchLocations = generateSampleLocationsFromImage(obj, noPatches, patchSize, imageSet.imageSize);
        end          
    end
    
end

