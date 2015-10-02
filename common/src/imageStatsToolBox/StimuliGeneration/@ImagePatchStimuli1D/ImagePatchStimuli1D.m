classdef ImagePatchStimuli1D < GenerateStimuli1D
    % This class generates stimuli by cutting patches from images at
    % slightly shifted locations
    
    properties
        imageSet = [];      % an image set (handle) containing the images to cut from, alternativiely it can be a matrix/tensor containing actual values of an image
        cutCentre = [];     % 2D (two element) vector of the location of the centre of line the images are cut from.        
        halfDirection = [1 0];      % vector of the line to cut, together with its magnitude.  (Acutally its half magnitude) 2 elements      
    end
    
    properties(Dependent, SetAccess = private)
        orientation;        % orientation of the sampling line
        magnitude;          % length of the sampling line
    end
    
    methods
        function obj = ImagePatchStimuli1D(imageSet, cutCentre, direction)
            % ImagePatchStimuli1D constructor
            % obj = ImagePatchStimuli1D()
            % obj = ImagePatchStimuli1D(imageSet)            
            % obj = ImagePatchStimuli1D(imageSet, cutCentre)
            % obj = ImagePatchStimuli1D(imageSet, cutCentre, direction)
            %
            % imageSet - either an ImageSet obj (handle) to a set images or
            % a matrix/tensor of actual image data.
            % cutCentre - 2D centre of the image for begin cutting patches
            % from. In multi-sample mode a matrix of such values.
            if nargin >= 1
                if isa(imageSet, 'ImageSet') || isnumeric(imageSet)
                    obj.imageSet = imageSet;
                else
                    error('ImagePatchStimuli1D:ImagePatchStimuli1D imageSet must be either a ImageSet object handle or an appropriate matrix/tensor of image data');
                end
            end
            if nargin >= 2
                if isnumeric(cutCentre) && size(cutCentre,2)==2
                    obj.cutCentre = cutCentre;
                else
                    error('ImagePatchStimuli1D:ImagePatchStimuli1D cutCentre must describe 2D data');
                end
            else
                if ~isempty(obj.getImageSize)
                    imageSize = obj.getImageSize;
                    obj.cutCentre = imageSize(1:2)./2;
                end
            end
            if nargin>=3
                obj.halfDirection = orientation ./ 2;
            end
        end
        
        function bool = isMultiSample(obj)
            % Returns true if the sampler is in multi-sample mode
            % bool = isMultiSample(obj)
            if ~isempty(obj.cutCentre)            
                bool = size(obj.cutCentre,1)==1;
            else
                bool = false;
            end
        end
        
        function angle = get.orientation(obj)
            % the orientation of sampling line
            angle = atan2(obj.halfDirection(1), obj.halfDirection(2));
        end
        
        function mag = get.magnitude(obj)
            % the magnitude of the sampling line, returns total length
            % rather than the half length of the direction variable
            mag = norm(obj.halfDirection).*2;
        end
        
        function bounds = getImageSize(obj)
            if isa(obj.imageSet, 'ImageSet')
                bounds = obj.imageSet.imageSize;
            end
        end
                
    end
    
    methods(Static)
        function validKeys = validKeys()
            % return a list of valid attributes that can be used in
            % stimulus generation (a cell array of strings)
            validKeys = {'line'};
        end  
    end
    
end

