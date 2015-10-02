classdef BarStimuli2D < GenerateStimuli2D
    % Generates stimuli using simple contrast bars
    %
    % Stimuli are returned a 2d greyscale images reshaped to vectors, the
    % stimuli dimension refers to the number of dimensions in the field not
    % the image.
    
    properties(SetAccess = protected)
        % The stimuli are generated as range from [ start ; end ] stored in
        % matrix form.
        %
        % The first dimension is the field dimensions, one for each
        % dimension.
        % The second dimension is the layers dimension. Default 1.
        % The third dimension is the views dimension. Default 1.
        %
        % summary ( dimensions, layers, views )
        width = 0.1;    % bar (2d matrix 2 * length equal to number of stimuli dimensions)
        position = 0;          % position of the bar relative to left edge of stimuli [0 1] (2d matrix 2 * length equal to number of stimuli dimensions)
        orientation = 0;    % orientation of bar
    end
    
    properties(Access = public)
        defaultWidth = 0.1;
        defaultPosition = 0;
        defaultOrientation = 0;
    end
    

    methods
        function obj = BarStimuli2D(width, position, orientation)
            % obj = GratingStimuli1D(freq, phase, orientation)
            if nargin>=3
                obj.defaultWidth = width;
                obj.defaultPosition = position;               
                obj.defaultOrientation = orientation;
            end
        end
        
        function validKeys = validKeys(obj)
            % return a list of valid attributes that can be used in
            % stimulus generation (a cell array of strings)
            validKeys = {'width','position','orientation'};
        end      
        
        function responsesOut = rearrangeResponses(obj, responsesIn, dims)
            % All stimuli are produced along a single dimension, rearrange
            % the responses (scalar) into the approprate 2D matrix.
            %
            % responsesOut = obj.rearrangeResponses(responsesIn, dims)
            % 
            % responsesIn - matrix of scalar neuron responses to rearrange
            % dim - dimensions of target matrix
            % responsesOut - rearranged responses.
            if numel(dims)==1
                dims = [ dims dims];
            end
            if numel(dims)~=2
                error('Dims must be a 2 element vector of positive integers.');
            end
            if any(~isposint(dims))
                error('Dims must be a 2 element vector of positive integers.');
            end
            if prod(dims) ~= numel(responsesIn)
                error('Number of input elements must match dimension sizes.');
            end
            
            responsesOut = zeros(dims);
            for loop1d = 1:dims(1)
                for loop2d = 1:dims(2)
                    responsesOut(loop1d, loop2d) = responsesIn((loop1d-1) + (loop2d-1)*dims(1) + 1);
                end
            end
        end
    end
    
    methods(Static)
        ret = renderBar(imgSize, width, position, orientation);
    end
    
end

