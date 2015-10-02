classdef SampleRectangularPatches < PatchSampler
    % Implementation of the PatchSampler for rectangular patches
    
    properties
    end
    
    methods
        function [ patches ] = implCutPatches(img, locations)
            
            % set bounds in which to cut patches
            halfWidth = floor( (width - 1 ) / 2);
            halfHeight = floor( (height - 1) / 2);
            
            if(isscalar(varargin{2}))
                patchLocations = [];
                noPatches = varargin{2};
                
                patchLocations(:,1) = unidrnd(imageWidth - width, noPatches, 1) + halfWidth;
                patchLocations(:,2) = unidrnd(imageHeight - height, noPatches, 1) + halfHeight;
                
            else
                patchLocations = varargin{2};
            end
            
            patches = zeros(size(patchLocations,1), width*height);
            if(size(patchLocations,2))
                for i=1:size(patchLocations,1)
                    patch = image(patchLocations(i,1)-halfWidth:patchLocations(i,1)+halfWidth,patchLocations(i,2)-halfHeight:patchLocations(i,2)+halfHeight);
                    %patch = patch - mean(patch);
                    patches(i,:) = reshape(patch, width*height, 1);
                    %patches(i,:) = patches(i,:) ./ (patches(i,:)*patches(i,:)');
                end
            end
        end
        
    end
    
end

