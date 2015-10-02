classdef ShowPatchesGUI < hgsetget
%show: displays to a figure the current patch collection
% obj.show()
% obj.show(figure_handle,...)
% obj.show(...,'property_name', property_value)
% obj.show(..., properties_struct)
%
% property          | decription
% GridSize          | Number of row and columns of patches to display
% ShowGrid          | Display boundaries of patches
% BorderSize        | The thickness of the boundary between patches
% BorderColor       | The colour of the border between patches
% NullColor         | The colour(s) to replace NaN, Inf values with
% SelectedPatches   | Indices to the patches selected for visualization
% Patches           | Patches object containing the patch information
% Display           | If true display immediately in the current figure,
%                   | otherwise delay display, default true.
% Pandle            | A handle to the figure/axis to display patches in.
%                   | Default gcf
% 
    properties
        GridSize = [3 3];
        ShowGrid = true;
        BorderSize = 5;
        BackgroundColor = [ 0 ];
        BorderColor = [ 0 ];
        NullColor = [ 0 ];
        Patches = []; 

        SelectedPatches = [];
    end
    
    properties(SetAccess = private)
        Parent = [];                % object containing the image
        Handle = [];                % handle to the image itself
        Display = true;             % is the image being displayed
    end
    
    
    
    methods
        function [ obj ] = ShowPatchesGUI(varargin)     
            [obj.Parent, args] = axescheck(varargin{:});
            
            obj = processKeyValuePairInputs(obj, args{:});            
            
            if obj.Display
                obj.Handle = obj.display;
            end
        end
        
        function handle = display(obj)
                img = obj.generateImage;
                if isempty(obj.Parent) || ~ishandle(obj.Parent)
                    obj.Parent = gca;
                end
                handle = imshow(img, 'Parent', obj.Parent);
        end
        
    end
    
end

