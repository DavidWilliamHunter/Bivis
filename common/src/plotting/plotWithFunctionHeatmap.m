function [ handle ] = plotWithFunctionHeatmap(varargin)
% plots a whole load o functions in the manner of the Matlab plot
% function.
% plotWithFunctionHeatmap(y_data)
% plotWithFunctionHeatmap(x,_data, y_data)
% plotWithFunctionHeatmap(x,_data, y_data, opt)
% [ handle ] = plotWithFunctionHeatmap(...)

    inputs = processInputs(varargin);

    lineThickness = range(inputs.Y(isfinite(inputs.Y))) .* 0.05;
    for loop = 1:size(inputs.Y,1)
        handle(loop) = plotTransparent(inputs.X, inputs.Y(loop,:), inputs.colour, 1./size(inputs.Y,1), lineThickness);
    end
    set(gcf,'Renderer', 'OpenGL')
    axis tight;
end

function [ handle ] = plotTransparent(xdata, ydata, colour, transparency, lineWidth)
    halfLineWidth = lineWidth./2;
    handle = patch([xdata xdata(end:-1:1)], [ydata+halfLineWidth ydata(end:-1:1)-halfLineWidth], colour);
    alpha(handle, transparency);
    set(handle, 'EdgeAlpha', 0);
    set(handle, 'LineWidth' , 1);
    set(handle, 'EdgeColor', colour);
    
    tinyLineWidth = lineWidth./100;
    handle = patch([xdata xdata(end:-1:1)], [ydata+tinyLineWidth ydata(end:-1:1)-tinyLineWidth], colour);
    alpha(handle, transparency);
    set(handle, 'EdgeAlpha', transparency);
    set(handle, 'LineWidth' , 1.5);
    set(handle, 'EdgeColor', colour);
end
    
function [ structuredInputs ] = processInputs(varargin)
    args = varargin{1};

    defaultSettings = defaults();

    if(numel(args)<1)
        error('Not enough inputs see "help plotWithFunctionHeatmap" for syntax');
    end

    if(~ismatrix(args{1}))
        error('First input variable is incorrectly formatted see "help plotWithFunctionHeatmap" for syntax');
    end

    if(numel(args)==1)
        inputs.Y = args{1};
        inputs.X = 1:size(inputs.Y,2);
    else

        if(~ismatrix(args{2}))
            error('Second input variable is incorrectly formatted see "help plotWithFunctionHeatmap" for syntax');
        end

        inputs.X = args{1};
        inputs.Y = args{2};

        pos = 3;
        index = 1;
        propertyList = struct();
        while(pos<(length(args)-1))
            propertyList{index} = args{pos};
            propertyList{index+1} = args{pos+1};
            pos = pos + 2;
            index = index + 2;
        end
    end
    structuredInputs = mergeStructs(defaultSettings, inputs);
end

function [ defaultSettings ] = defaults()
    defaultSettings = struct();
    position = get(gcf, 'Position');
    defaultSettings.resolution = [ position(3)  position(4)];
    defaultSettings.colour = 'k';
end

function [ output ] = mergeStructs(varargin)
    if(nargin<1)
        error('mergeStructs must have at least one inputs');
    end
    if(nargin==1)
        output = varargin{1};
        return
    end

    fieldNames = cell(1,numel(varargin));
    values = cell(1, numel(varargin));
    for loop = 1:numel(varargin)
        if(~isstruct(varargin{loop}))
            error('inputs must be structs');
        end
        if(~isempty(varargin{loop}))
            fieldNames{loop} = fieldnames(varargin{loop});
            values{loop} = struct2cell(varargin{loop});
        end
    end

    fieldNames = cat(1, fieldNames{:});
    values = cat(1, values{:});
    [ ~, uniqueFieldNames ] = unique(fieldNames);

    for loop = uniqueFieldNames'
        if(isstruct(values{loop}))
            % find and merge these structures
            temp = struct();
            for loop2 = 1:nargin
                if(isfield(varargin{loop2}, fieldNames(loop)))
                    temp = mergeStructs(temp, varargin{loop2}.(fieldNames{loop}));
                end
            end
            values{loop} = temp;
        end
    end

    output = cell2struct(values(uniqueFieldNames), fieldNames(uniqueFieldNames));

end
