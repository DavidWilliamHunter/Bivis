classdef PatchInfo
    %PATCHINFO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = public, SetAccess = protected)
        layers = 1; %number of layers in each patch
        views = 1;  % number of views in each patch 
        noElementsTotal = 0; % number of elements in patch
        boundary = [0 0]; % size of the patch (width and height) when displayed
    end
    
    properties(SetAccess = private, Dependent)
        width;          % width of the patch
        height;         % height of the image patch
    end
    
    methods
        function obj = PatchInfo(varargin)
            % create a patchInfo object 
            % obj = patchInfo()
            % obj = patchInfo(layers, views)
            % obj = patchInfo(layers, views, noElementsTotal, boundary)
            if nargin>=2
                if ~(isnumeric(varargin{1}) && isposint(varargin{1}) && varargin{1}>0)
                    error('layers must be a positive interger value of 1 or greater.');
                end
                if ~(isnumeric(varargin{2}) && isposint(varargin{2}) && varargin{2}>0)
                    error('views must be a positive interger value of 1 or greater.');
                end
                obj.layers = varargin{1};
                obj.views = varargin{2};
            end
            if nargin>=4
                obj.noElementsTotal = varargin{3};
                obj.boundary = varargin{4};
            end                
        end
        
        function val = get.width(obj)
            val = obj.boundary(1);
        end
        
        function val = get.height(obj)
            val = obj.boundary(2);
        end
    end
    
end

