classdef RDSStimuli1D < GenerateStimuli1D
    % This class generates stimuli by cutting patches from random dot stereogram patterns at
    % slightly shifted locations
    
    properties(SetAccess = protected)
        imageSize = [ 256 256 1 2];  % the size of the image [ width height layers views ]
        halfDirection = [1 0];      % vector of the line to cut, together with its magnitude.  (Acutally its half magnitude) 2 elements
    end
    
    properties(Dependent, SetAccess = private)
        orientation;        % orientation of the sampling line
        magnitude;          % length of the sampling line
    end
    
    methods
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
            % return the size of the images in the image set
            bounds = obj.imageSize;
        end
    end
    
end

