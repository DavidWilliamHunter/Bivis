classdef GratingStimuli1D < GenerateStimuli1D
    % Generates grating stimuli using cosine waves
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
        frequency = 0.1;    % frequency of the waveform (2d matrix 2 * length equal to number of stimuli dimensions)
        phase = 0;          % phase of the waveform in the centre of the stimuli (2d matrix 2 * length equal to number of stimuli dimensions)
        orientation = 0;    % direction of cosine grating
    end
    
    properties(Access = public)
        defaultFrequency = 0.1;
        defaultPhase = 0;
        defaultOrientation = 0;
    end
    

    methods
        function obj = GratingStimuli1D(freq, phase, orientation)
            % obj = GratingStimuli1D(freq, phase, orientation)
            if nargin>=3
                obj.defaultFrequency = freq;
                obj.defaultPhase = phase;
                obj.defaultOrientation = orientation;
            end
        end
        
        function validKeys = validKeys(obj)
            % return a list of valid attributes that can be used in
            % stimulus generation (a cell array of strings)
            validKeys = {'frequency','phase','orientation'};
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
            responsesOut = responsesIn;
        end        
    end
    
end

