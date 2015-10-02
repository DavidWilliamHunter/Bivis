function [ handle ] = processProperties(varargin)
% Helper function for plotting, take a structure of property name, key
% pairs and applies them as properties (using the set command) to a figure.
%
% processProperties(struture_in)
% processProperties(handle, struture_in)
% handle = processProperties(...
%
% struture_in - structure containing properties. Properties set as
%   variables within the structure, i.e. 
%       new_properties.HorizontalAlignment = 'Right'
%       processProperties(handle,new_properties)
%
%   is equivelent to:
%       set(handle, 'HorizontalAlignment', 'Right')
%
%  handle - optional , handle to figure to apply properties.

if nargin < 1
        error('Need to supply a struct containing properties');
end
    
if isstruct(varargin{1})
    cax = gca;
    args = varargin;
    nargs = length(args);
else
    cax = varargin{1};
    args = varargin(2:end);
    nargs = length(args);
end
    
    if nargs < 1
        error('Need to supply a struct containing properties');
    end
	
    for loop = 1:nargs
        if isstruct(args{loop})
            properties = fieldnames(args{loop});
            
            for innerLoop = 1:numel(properties)
                set(cax, properties{innerLoop}, getfield(args{loop}, properties{innerLoop}));
            end
        end
    end
    handle = cax;
end