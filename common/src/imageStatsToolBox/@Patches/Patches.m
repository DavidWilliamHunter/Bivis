classdef Patches < matlab.mixin.Copyable
    % PATCHES Collection of patches used in image analysis
    % patch data is stored in a matrix of doubles, each row contains a
    % single vectorised patch
    %
    
    properties
        patchData % patch data is stored in a matrix of doubles, each row contains a
                    % single vectorised patch
        patchLimits % the maximum extent of the patch as a rectangle
        layers = 1; %number of layers in each patch
        views = 1;  % number of views in each patch
        locations = []; % the positions in the image the patch was cut from (centre)
        colourModel = BWColourModel;    % the colour model associated with the patches.
    end    
    
    properties(SetAccess = private, GetAccess = protected)
        max_attempts = 10;
    end
        
    methods
        function [ obj ] = Patches(width, height, layers, views, colourModel)
            % obj = Patches(width, height, layers, views, colourModel)
            % obj = Patches(PatchInfo)
            if nargin>=1
                if isa(width, 'PatchInfo')
                    obj.patchLimits = width.boundary;
                    obj.layers = width.layers;
                    obj.views = width.views;
                    return
                end
            end
            if nargin>=2
                obj.patchLimits = [ width height];
            end
            if nargin>=3
                obj.layers = layers;
            end
            if nargin>=4
                obj.views = views;
            end
            if nargin>=5
                obj.colourModel = colourModel;
            end
        end
        
        function [ varargout ] = getPatchBounds(obj)
            % getPatchBounds: Returns the width and height of the maximum
            % extent of the patch. Nb the product of width and height is
            % not neccessarily the number of elements in each patch
            %
            % patchSize = obj.getPatchBounds()
            % 
            % patchSize two element vector, [width height] in pixels
            
            if nargout==1
                varargout{1} = [ obj.patchLimits obj.layers obj.views ];
            else
                if nargout~=numel(obj.patchLimits)
                    error(['getPatchBounds: Number of outputs must match number of image dimensions in Patch obj, in this case ',num2str(numel(obj.patchLimits))]);
                else
                    temp = [ obj.patchLimits obj.layers obj.views ];
                    for loop = 1:nargout
                        varargout{loop} = temp(loop);
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
            
            if nargout==1
                width = obj.patchLimits(1);
                height = obj.patchLimits(2)*obj.layers*obj.views;
                varargout{1} = [ width height ];
            else
                if nargout~=numel(obj.patchLimits)
                    error(['getDisplayBounds: Number of outputs must match number of image dimensions in Patch obj, in this case ',num2str(numel(obj.patchLimits))]);
                else
                    newSize(1) = obj.PatchLimits(1);
                    newSize(2) = obj.PatchLimits(2).*obj.layers*obj.views;
                    for loop = 1:nargout
                        varargout{loop} = newSize;
                    end
                end
            end
        end
        
        function [ num ] = getNoPatches(obj)
            % getNumberOfPatches: returns the number of patches in the
            % collection.
            %
            % num = obj.getNumberOfPatches()
            num = size(obj.patchData,1);
        end
       
        function num = getNoElements(obj)
            if ~isempty(obj.patchData)
                num = size(obj.patchData,2);
            else
                bounds = obj.getPatchBounds();
                num = prod(bounds(1:2)) * obj.layers * obj.views;
            end
        end
        
        function patch = getPatchData(obj, patchNumber, layerNumber, viewNumber)
            % Returns a given patch or patches as a vector (or matrix of
            % vectors)
            %
            % patch = obj.getPatch(patchNumber)
            % patch = obj.getPatch(patchNumber, layerNumber, viewNumber)
            %
            % patchNumber - positive, integer values between 1 and number
            % of patches
            % layerNumber - positive, integer values between 1 and number
            % of layers
            % viewNumber - positive, integer values between 1 and number
            % of views
            [ width, height ] = obj.getPatchBounds;
            if nargin < 3
                if any(patchNumber<=0) || any(patchNumber>obj.getNoPatches)
                    patch = zeros(numel(patchNumber), size(obj.patchData,2));
                    return
                end
                patch = obj.patchData(patchNumber,:);
                return;
            else
                if any(patchNumber<=0) || any(patchNumber>obj.getNoPatches)
                    patch = zeros(numel(patchNumber), size(obj.patchData,2));
                    return
                end
                range = (1:width*height) + (width*height*(layerNumber-1));
                range = range(:) + (width*height*obj.layers*(viewNumber-1));
                patch = obj.patchData(patchNumber,range);
                patch = reshape(patch, width,height);
            end
        end
        
        function obj = setPatchData(obj, patchNumber, newPatchData, layerNumber, viewNumber)
            % Set the content of a given patch or patches as a vector (or matrix of
            % vectors)
            %
            % patch = obj.getPatch(patchNumber, patchData)
            % patch = obj.getPatch(patchNumber, patchData, layerNumber, viewNumber)
            %
            % patchNumber - positive, integer values between 1 and number
            % of patches
            % patchData - vector of double values, must have the same
            % number of elements as a patch
            % layerNumber - positive, integer values between 1 and number
            % of layers
            % viewNumber - positive, integer values between 1 and number
            % of views
            [ width, height ] = obj.getPatchBounds;
            if nargin < 3
                if any(patchNumber>0) || any(patchNumber<=obj.getNoPatches)
                    return
                end
                obj.patchData(patchNumber,:) = newPatchData(:);
                return;
            else
                if any(patchNumber<=0) || any(patchNumber>obj.getNoPatches)
                    error('Patches:setPatchData Element number %i is not found in Patches', patchNumber);
                end
                if any(layerNumber<=0) || any(layerNumber>obj.layers)
                    error('Patches:setPatchData Layer number %i is not found in Patches', layerNumber);
                end 
                if any(viewNumber<=0) || any(viewNumber>obj.views)
                    error('Patches:setPatchData View number %i is not found in Patches', viewNumber);
                end                     
                range = (1:width*height) + (width*height*(layerNumber-1));
                range = range(:) + (width*height*obj.layers*(viewNumber-1));
                obj.patchData(patchNumber,range) = newPatchData(:);
                
            end
        end        
            
        function [ patchMatrix ] = getAsMatrix(obj, patchNumber, filler, fixedPatchSize)
            % convert a patch to a rectangular matrix
            % [ patchMatrix ] = obj.getAsMatrix(patchNumber, [ filler ], [fixedPatchSize])
            % patchNumber - Number between 1 and number of patches
            % filler - number to replace missing values with (default = 0)
            %   fixedPatchSize - size of patch to return, patch will be
            %   clipped or filled with 'filler' for missing values  
            if patchNumber>0 && patchNumber<=obj.getNoPatches()
                patchMatrix = reshape(obj.patchData(patchNumber,:), obj.getDisplayBounds());
            else
                patchMatrix = zeros(obj.getDisplayBounds());
            end
        end
        
        function [ obj ] = removeDC(obj)
            % remove the DC component over a set of patches by subtracting
            % the patch mean from each row of data.
            %
            % obj = obj.removeDC
            obj.patchData = obj.patchData - repmat(mean(obj.patchData,2),1, size(obj.patchData,2));
        end
               
        function [ ret ] = innerProduct(obj, otherObj)
            % [ ret ] = obj.innerProduct(otherObj)
            %
            % returns the inner product between all patches of this patch
            % collection and another patch collection.
            if nargin<2
                error('Patch:innerProduct not enough input arguements');
            end
            
            if obj.getNoElements ~= otherObj.getNoElements
                error('Patches.innerProduct: Can only perform inner product on patches of the same size.');
            end
            
            ret = obj.patchData * otherObj.patchData';
        end            
        
        function [ ret ] = callFunc(obj, func, varargin)
            if ~isa(func, 'function_handle')
                error('func must be a function handle');
            end
            
            inputs = cell(size(varargin));
            for loop = 1:numel(varargin)
                if isa(varargin{loop}, 'Patches')
                    inputs{loop} = varargin{loop}.patchData;
                else
                    inputs{loop} = varargin{loop};
                end
            end                        
            
            newData = func(obj.patchData, inputs{:});
            ret = obj;
            ret.patchData = newData;
        end
        
        function [ ret ] = callFuncSeparated(obj, func, varargin)
            if ~isa(func, 'function_handle')
                error('func must be a function handle');
            end
            
            inputs = cell(size(varargin));
            for loop = 1:numel(varargin)
                if isa(varargin{loop}, 'Patches')
                    inputs{loop} = varargin{loop}.patchData;
                else
                    inputs{loop} = varargin{loop};
                end
            end
            
            ret = obj;
            patchInfo = getPatchInfo(obj);
            for eLoop = 1:obj.getNoElements();
                for vLoop = 1:patchInfo.views;
                    for lLoop = 1:patchInfo.layers;
                        localPatch = obj.getPatchData(eLoop, lLoop, vLoop);
                        newData = func(localPatch, inputs{:});
                        ret = ret.setPatchData(eLoop, newData, lLoop, vLoop);
                    end
                end
            end

        end
        
        function [ ret ] = callFuncTransposeOther(obj, func, varargin)
            if ~isa(func, 'function_handle')
                error('func must be a function handle');
            end
            
            inputs = cell(size(varargin));
            for loop = 1:numel(varargin)
                if isa(varargin{loop}, 'Patches')
                    inputs{loop} = varargin{loop}.patchData';
                else
                    inputs{loop} = varargin{loop};
                end
            end         
            ret = func(obj.patchData, inputs{:});
        end
        
        function patchInfo = getPatchInfo(obj)
            patchInfo = PatchInfo(obj.layers, obj.views, obj.getNoElements(), obj.getPatchBounds());
        end
        
        %%
        % Functions on the patches
        function p = patchPower(obj)
            % the power or magnitude of each patch returned as vector of
            % magnitudes.
            % p = obj.patchPower
            
            %p = sqrt(diag(obj.patchData * obj.patchData'));
            
            p = zeros(size(obj.patchData,1),1);
            for loop = 1:numel(p)
                p(loop) = sqrt(sum(obj.patchData(loop,:) .* obj.patchData(loop,:)));
            end
        end
        
        function newPatches = patchNormalise(obj)
            % Normalise each patch
            % newPatches = obj.patchNormalise
            newPatches = obj;
            powers = newPatches.patchPower;
            newPatches.patchData = newPatches.patchData ./ (powers * ones(1,size(newPatches.patchData,2)));
            inds = all(isfinite(newPatches.patchData),2);
            newPatches.patchData = newPatches.patchData(inds,:);
        end
        
    end
    
    methods(Static)
        [ varargout ] = sampleFromImages(  varargin  );
        [ varargout ] = samplePatchGrid(  varargin  );
        [ obj ] = import( varargin );
    end
    
    methods(Access = protected)
        function [ ret ] = generateNewPatchSet(obj, newPatchData)
            % generate a new Patches object (factory method)
            % optionaly with new patch data.
            if nargin < 2
                ret = Patches;
                ret.patchData = obj.patchData;
            else
                ret = Patches;
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

