classdef RDSImageSet < ImageSet
    % Stores details about a set of Random Dot Sterogram images
    % Any link between image layers or views depends on the generating
    % function.
    
    properties
    end
    
    methods
        function [ obj ] = RDSImageSet(varargin)
            % obj = ImageSet();
            % obj = ImageSet(fileOfImageNames)
            %
            % fileOfImageName - a file containing a list of images to load.
            % see help loadImageNameList
            obj = ImageSet(varargin{:});
        end
        
    end
    
end

