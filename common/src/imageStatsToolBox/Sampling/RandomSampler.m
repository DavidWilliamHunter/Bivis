classdef RandomSampler < PatchSampler
    % Sample patches uniformly at random from an image
    
    properties
    end
    
    methods(Access = public)
        function [ patchLocations ] = generateSampleLocationsFromImage(obj, noPatches, patchSize, imageSize)
            % Create a set of random patch locations over an image.
            %
            % [ patchLocations ] = sample(noPatches, patchSize, imageSize)
            %
            % noPatches - number of patch locations to generate
            % patchSize - the size of the patch (maximum rectangular range)
            %             2 vector double
            % imageSize - the size of the images to cut from.
            %            [ width, height, noLayers, noImages ]
            
            
            width = patchSize(1);
            height = patchSize(2);
            imageWidth = imageSize(1);
            imageHeight = imageSize(2);
            
            
            if numel(imageSize) >= 3
                noLayers = imageSize(3);
            else
                noLayers = 1;
            end
            
            if numel(imageSize) >= 4
                noViews = imageSize(4);
            else
                noViews = 1;
            end
                
            
            halfWidth = floor( (width - 1 ) / 2);
            halfHeight = floor( (height - 1) / 2);
            
            newPatchLocations(:,1) = unidrnd(imageWidth - width, noPatches, 1) + halfWidth;
            newPatchLocations(:,2) = unidrnd(imageHeight - height, noPatches, 1) + halfHeight;
            
            for loopL = 1:noLayers
                for loopI = 1:noViews
                    patchLocations(:,:,loopL, loopI) = newPatchLocations;
                end
            end
        end
    end
    
    methods(Static)    
        function [ exp_locations ] = expandLocations(locations, newLayers, newViews)
            % Expands the tensor of locations by replication to match new
            % dimensions. The algorithm assumes that the expanded dimension
            % is singular, i.e. of length 1.
            %
            % [ exp_locations ] = expandLocations(locations, newLayers, [newViews])
            %
            % location - tensor of location data to expand
            % newLayers - the new number of layers in the model
            % newViews - the new number of views in the model
            
            % begin by expanding the layers
            noLayers = size(locations, 3);
            if noLayers~=newLayers
                exp_locations = repmat(locations(:,:,1,:), [ 1 1 newLayers 1]);
            else
                exp_locations = locations;
            end
            
            noViews = size(exp_locations, 4);
            if noViews~=newViews
                exp_locations = repmat(exp_locations(:,:,:,1), [ 1 1 1 newLayers]);
            end
        end
                
            
    end
    
end

