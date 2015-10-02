function [ output_args ] = show( obj, varargin )
%show: displays to a figure the current patch collection
% obj.show()
% obj.show(figure_handle,...)
% obj.show(...,'property_name', property_value)
% obj.show(..., properties_struct)
%
% property      | decription
% GridSize      | Number of row and columns of patches to display
% ShowGrid      | Display boundaries of patches
% BorderSize    | The thickness of the boundary between patches
% BorderColor   | The colour of the border between patches
% NullColor     | The colour(s) to replace NaN, Inf values with
% 

    [, args] = axescheck(varargin{:});

    [ properties_struct ] = processInputs(obj, args{:});

    
end

function [ properties_struct ] = processInputs(obj, varargin)
    offset = 1;
    loop = 1;
    
    property_name = cell();
    property_value = cell();
    while offset <= length(varargin)
        if ischar(varargin{offset})
            property_name{loop} = varargin{offset};
            offset = offset + 1;
            if offset>length(varargin)
                error('show: arguements must follow key value pairing');
            end
            property_value{loop} = varargin{offset};
            offset = offset + 1;
            loop = loop + 1;
        elseif isstruct(varargin{offset})
            
            c = struct2cell(varargin{offset}); f = fieldnames(varargin{offset});
            for inner = 1:length(c)
                property_name{loop} = c{inner};
                property_value{loop} = f{inner};
                loop = loop + 1;
            end
        end
    end
    
    if ~isempty(property_name)
        properties_struct = cell2struct(property_value, property_name);
    end
end

% property      | decription
% GridSize      | Number of row and columns of patches to display
% ShowGrid      | Display boundaries of patches
% BorderSize    | The thickness of the boundary between patches
% BorderColor   | The colour of the border between patches
% NullColor     | The colour(s) to replace NaN, Inf values with
% 

function [ defaults ] = getDefaultValues(obj)
    default.GridSize = [ 3 3 ];
    default.ShowGrid = true;
    default.BorderSize