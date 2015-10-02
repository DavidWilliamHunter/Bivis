classdef ColourModel
    % A Colour model for images, can convert between models
    % Subclass store any relevent information about the colour models they
    % use and well as (at least) handling image file convertion.
    
    
    methods
        function [ layeredImage ] = convertFromImread(obj, imreadData)
            % convert from matlab's imread image format to
            % the colour model's layered format.
            %
            % [ layeredImage ] = obj.convertFromImread(imreadData)
            %
            % imreadData - data returned by a call to the imread function
            %               in the image toolbox.
            % layeredImage - tensor of doubles dimension [ width height colours]
            
            error('Must be called from a class that inheirits from ColourModel');
        end
        
        function [ num ] = getNoLayers(obj)
            % Returns the number of layers in the colour model
            % [ num ] = obj.getNoLayers(obj)
            error('Must be called from a class that inheirits from ColourModel');
        end
    end
    
end

