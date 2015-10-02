classdef CircularPatches < Patches
    %CIRCULARPATCHES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius
    end
        
    methods
        function [ obj ] = CircularPatches(radius, layers, views)
            obj.radius = radius;
            obj.layers = layers;
            obj.views = views;
        end
        
        function [ varargout ] = getPatchBounds(obj)
            % getPatchBounds: Returns the width and height of the maximum
            % extent of the patch. Nb the product of width and height is
            % not neccessarily the number of elements in each patch
            %
            % patchSize = obj.getPatchBounds()
            % 
            % patchSize two element vector, [width height] in pixels
            
            patchSize = ([obj.radius obj.radius].*2)+1;
            if nargout==1
                varargout{1} = patchSize;
            else
                if nargout~=numel(patchSize)
                    error(['getPatchBounds: Number of outputs must match number of image dimensions in Patch obj, in this case ',num2str(numel(obj.patchLimits))]);
                else
                    for loop = 1:nargout
                        varargout{loop} = patchSize(loop);
                    end
                end
            end
            
        end
        
        function [ varargout ] = getDisplayBounds(obj)
            % getDisplayBounds: Returns the width and height of the maximum
            % extent of the patch. Nb the product of width and height is
            % not neccessarily the number of elements in each patch
            %
            % patchSize = obj.getDisplayBounds()
            % 
            % patchSize two element vector, [width height] in pixels
            
            patchLimits = obj.getPatchBounds();
            if nargout==1 || nargout==0
                width = patchLimits(1);
                height = patchLimits(2)*obj.layers*obj.views;
                varargout{1} = [ width height ];
            else
                if nargout~=numel(patchLimits)
                    error(['getDisplayBounds: Number of outputs must match number of image dimensions in Patch obj, in this case ',num2str(numel(obj.patchLimits))]);
                else
                    newSize(1) = patchLimits(1);
                    newSize(2) = patchLimits(2).*obj.layers*obj.views;
                    for loop = 1:nargout
                        varargout{loop} = newSize;
                    end
                end
            end
        end
        
        function num = getNoElements(obj)
            if ~isempty(obj.patchData)
                num = size(obj.patchData,2);
            else
                inds = obj.createTemplate();
                noActive=  sum(inds(:));
                num = noActive * obj.layers * obj.views;
            end
        end        
        
        function [ patchMatrix ] = getAsMatrix(obj, patchNumber, filler, fixedPatchSize)
            % convert a patch to a rectangular matrix
            % [ patchMatrix ] = obj.getAsMatrix(patchNumber, [ filler ], [fixedPatchSize])
            % patchNumber - Number between 1 and number of patches
            % filler - number to replace missing values with (default = 0)
            %   fixedPatchSize - size of patch to return, patch will be
            %   clipped or filled with 'filler' for missing values  
            
            if nargin<3
                filler = 0;
            end
            
            imageSize = obj.getPatchBounds();
            displaySize = obj.getDisplayBounds();
            
            ind = obj.createTemplate();
            
            totalInd = sum(ind(:));
            
            
            patchMatrix = ones(displaySize).*filler;
            if patchNumber>0 && patchNumber<=obj.getNoPatches()
                patch = obj.patchData(patchNumber,:);
                for loopL = 1:obj.layers
                    for loopV = 1:obj.views
                        localPatch=zeros(imageSize);
                        localPatch(ind) = patch((1:totalInd)+(loopL-1)*totalInd+(loopV-1)*totalInd*obj.layers);
                        patchMatrix(1:imageSize(1),...
                            imageSize(2)*(loopL-1)+(1:imageSize(2)*loopL) + imageSize(2)*(loopV-1)*obj.layers) = localPatch;
                    end
                        
                end
            end
        end
    end
    
    methods(Static)
        [ varargout ] = sampleFromImages(  varargin  );
    end   
    
    methods(Access = private)
        function [ inds ] = createTemplate(obj)
                % create a circular template
                imageSize = obj.getPatchBounds();

                [ X, Y ] = meshgrid(1:imageSize(1), 1:imageSize(2));
                inds = ((X-obj.radius-1).^2 + (Y-obj.radius-1).^2)<obj.radius.^2;
        end
    end
    
    methods(Access = protected)
        function [ ret ] = generateNewPatchSet(obj, newPatchData)
            % generate a new Patches object (factory method)
            % optionaly with new patch data.
            if nargin < 2
                ret = CircularPatches(obj.radius, obj.layers, obj.views);
                ret.patchData = obj.patchData;
            else
                ret = CircularPatches(obj.radius, obj.layers, obj.views);
                ret.patchData = newPatchData;
            end
            ret.patchLimits = obj.patchLimits; % the maximum extent of the patch as a rectangle
            ret.layers = obj.layers;
            ret.views = obj.views;
            ret.locations = obj.locations; % the positions in the image the patch was cut from (centre)
            ret.colourModel = obj.colourModel;    % the colour model associated with the patches.
        end
    end
end

