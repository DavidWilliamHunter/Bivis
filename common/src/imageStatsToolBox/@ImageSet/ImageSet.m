classdef ImageSet < hgsetget
    % ImageSet - A list of files to load as layered images,
    % The image set is organised as a list of scenes, organised as a list
    % of multilayered images. Each layer is 2d matrix of doubles
    % representing the image intensities
    
    properties(Access = protected)
        base_directory;
        file_names;    % cell of strings, {imageNo, layerNo}
        colour_model;    % a colour conversion model for file handling
        imageSizeOnly = []; % size of the image [ width height noLayers noViews]        
    end
    
    properties(SetAccess = private, Dependent = true)
        noScenes;  % number of scenes in the set
        noViews;  % number of images or views of each scene
        noLayers;  % number of layers in each image
        width;     % width of the images.
        height;    % height of the images.
        imageSize;  % combined vector of image information [ width height noLayers noViews ].
    end    
    
    methods
        function [ obj ] = ImageSet(varargin)
            % obj = ImageSet();
            % obj = ImageSet(fileOfImageNames)
            % obj = ImageSet(fileOfImageNames, colour_model)
            % obj = ImageSet(fileOfImageNames, colour_model)
            %
            % fileOfImageName - a file containing a list of images to load.
            % see help loadImageNameList
            if nargin>=1
                obj = obj.loadImageNameList(varargin{1});
            end
            if nargin>=2
                if isa(varargin{2}, ColourModel)
                    obj.colour_model = varargin{2};
                else
                    obj.colour_model = BWColourModel;
                end
            else
                obj.colour_model = BWColourModel;
            end
        end
        
        function num = get.width(obj)
            if isempty(obj.imageSizeOnly)
                is = obj.imageSize;
                num = is(1);
            else
                num = obj.imageSizeOnly(1);
            end
        end
        
        function num = get.height(obj)
            if isempty(obj.imageSizeOnly)
                is = obj.imageSize;
                num = is(2);
            else
                num = obj.imageSizeOnly(2);
            end
        end
            
        function num = get.noScenes(obj)
            num = size(obj.file_names,1);
        end
        
        function num = get.noLayers(obj)
            if isempty(obj.imageSizeOnly)
                is = obj.imageSize;
                num = is(3);
            else
                num = obj.imageSizeOnly(3);
            end
        end
        
        function num = get.noViews(obj)
            if isempty(obj.imageSizeOnly)
                is = obj.imageSize;
                num = is(4);
            else
                num = obj.imageSizeOnly(4);
            end
        end
        
        function img_size = get.imageSize(obj)
            if isempty(obj.imageSizeOnly)
                if ~isempty(obj.file_names)
                    img = obj.getImage(1);
                    if ndims(img)==2
                        obj.imageSizeOnly = [ size(img) 1 size(obj.file_names,2) ];
                    elseif ndims(img)==3
                        obj.imageSizeOnly = [ size(img) size(obj.file_names,2) ];
                    else
                        obj.imageSizeOnly = size(img);
                    end
                    
                else
                    obj.imageSizeOnly = [];
                end
            end
            img_size = obj.imageSizeOnly ;
        end 
    end
    
end

