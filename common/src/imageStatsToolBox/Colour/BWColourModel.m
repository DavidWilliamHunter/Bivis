classdef BWColourModel < ColourModel
    % A simple single layer grey-scale colour model
    
    properties
    end
    
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
            %
            % see rgb2gray and im2double for details of implementation
            if ndims(imreadData)==3
                tmpImg = im2double(rgb2gray(imreadData));
            elseif ndims(imreadData)==2
                tmpImg = imreadData;
            else
                error('Invalid number of dimension in input data');
            end
            layeredImage(:,:,1) = tmpImg;
        end 
        
        function [ num ] = getNoLayers(obj)
            num = 1;
        end
    end
    
end

