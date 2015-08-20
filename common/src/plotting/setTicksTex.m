function [ handles ] = setTicksTex(varargin)
    % set the axis ticks to latex text.
    %
    [cax, args, nargs] = axescheck(varargin{:});
    
    if isempty(cax)
        cax = gca;
    end
    
    hold_state = ishold(cax);

    inputs = processInputs(cax, args);

    set(gcf, 'CurrentAxes', cax);    
    set(cax, 'yTickLabel', [], 'xticklabel',[]);
    xlabel(''); ylabel('');

    ax = axis(cax);
    loc = zeros(1,2);
    if isempty(inputs.xTickPos)
        xShift = 0;
    else
        xShift = (ax(2)-ax(1)).*0.01;
    end
    if isempty(inputs.yTickPos)
        yShift = 0;
    else
        yShift = (ax(4)-ax(3)).*0.01;
    end
    switch(inputs.xAxisLocation)
        case 'top'
            loc(2) = ax(4);
            inputs.xVerticalAlignment = 'bottom';
        case 'bottom'
            loc(2) = ax(3);
            inputs.xVerticalAlignment = 'top';
            yShift = -yShift;                                    
    end
    switch(inputs.yAxisLocation)
        case 'left'
            loc(1) = ax(1);
            inputs.yHorizontalAlignment = 'right';            
        case 'right'
            loc(1) = ax(2);
            inputs.yHorizontalAlignment = 'left'; 
            xShift = -xShift;            
    end
    
    for loop = 1:min([length(inputs.yTickPos), length(inputs.yTickLabels)])
        handles.yTicks(loop) = text(loc(1)-xShift, inputs.yTickPos(loop), inputs.yTickLabels(loop),...
            'VerticalAlignment','middle', 'HorizontalAlignment',inputs.yHorizontalAlignment,...
            'FontName', inputs.fontName, 'FontSize', inputs.fontSize,...
            'Margin',0.1,...
            'Interpreter','Latex');
        processProperties(handles.yTicks(loop), inputs.xproperties);
        correctLatexPosition(handles.yTicks(loop), inputs.yAxisShift(1), inputs.yAxisShift(2));
    end
    minY = min(inputs.yTickPos);

    for loop = 1:min([length(inputs.xTickPos),length(inputs.xTickLabels)])
        handles.xTicks(loop) = text(inputs.xTickPos(loop), loc(2)+yShift, inputs.xTickLabels(loop),...
            'VerticalAlignment',inputs.xVerticalAlignment, 'HorizontalAlignment','center');
        processProperties(handles.xTicks(loop), inputs.yproperties);
        correctLatexPosition(handles.xTicks(loop), inputs.xAxisShift(1), inputs.xAxisShift(2));
    end

    %midXPoint = (inputs.xTickPos(1) + inputs.xTickPos(end))./2;
    handles.xlabel = text(inputs.xlabel.Position(1), inputs.xlabel.Position(2),inputs.xlabel.Text);
    processProperties(handles.xlabel, inputs.xlabel.properties);
    correctLatexPosition(handles.xlabel, inputs.xLabelShift(1), inputs.xLabelShift(2));
    
    %midYPoint = (inputs.yTickPos(1) + inputs.yTickPos(end))./2;
    %handles.ylabel = text(ax(1)-xShift.*12, midYPoint, inputs.ylabel.text,
    handles.ylabel = text(inputs.ylabel.Position(1), inputs.ylabel.Position(2), inputs.ylabel.Text);
    processProperties(handles.ylabel, inputs.ylabel.properties);
    correctLatexPosition(handles.ylabel, inputs.yLabelShift(1), inputs.yLabelShift(2));    
    
    handles.title = get(cax, 'Title');
    set(handles.title, 'Interpreter', 'Latex');
    set(handles.title, 'String', inputs.title.Text);
    set(handles.title, 'Position', inputs.title.Position);
    set(handles.title, 'HorizontalAlignment', 'center');
    processProperties(handles.title, inputs.title.properties);
    correctLatexPosition(handles.title, inputs.titleShift(1), inputs.titleShift(2));    
    
    if hold_state
        hold on
    else
        hold off
    end


end

function [ inputs ] = processInputs(cax, varargin)
    args = varargin{1};
    nargs = length(args);

    inputs.xTickPos = [];
    inputs.xTickLabels = {};
    inputs.yTickPos = [];
    inputs.yTickLabels = {};

    axis_properties = get(cax);
    
    defaults.properties.interpreter = 'latex';
    defaults.properties.FontAngle = axis_properties.FontAngle;
    defaults.properties.FontName = axis_properties.FontName;
    defaults.properties.FontUnits = axis_properties.FontUnits;
    defaults.properties.FontWeight = axis_properties.FontWeight;
    defaults.properties.FontSize = axis_properties.FontSize;
    defaults.properties.LineWidth = axis_properties.LineWidth;
    
    defaults.xproperties = defaults.properties;
    defaults.xproperties.Color = axis_properties.XColor;
    
    defaults.yproperties = defaults.properties;
    defaults.yproperties.Color = axis_properties.YColor;

    xlabel = get(get(cax, 'Xlabel'));
    ylabel = get(get(cax, 'Ylabel'));
    defaults.xlabel.Text = xlabel.String;
    defaults.xlabel.Position = xlabel.Position;
    defaults.xlabel.properties.VerticalAlignment = xlabel.VerticalAlignment;
    defaults.xlabel.properties.HorizontalAlignment = xlabel.HorizontalAlignment;
    defaults.xlabel.properties.Rotation = xlabel.Rotation;
    defaults.xlabel.properties.FontAngle = xlabel.FontAngle;
    defaults.xlabel.properties.FontName = xlabel.FontName;
    defaults.xlabel.properties.FontUnits = xlabel.FontUnits;
    defaults.xlabel.properties.FontWeight = xlabel.FontWeight;
    defaults.xlabel.properties.FontSize = xlabel.FontSize;
    defaults.xlabel.properties.LineWidth = xlabel.LineWidth;
    
    defaults.ylabel.Text = ylabel.String;
    defaults.ylabel.Position = ylabel.Position;    
    defaults.ylabel.properties.VerticalAlignment = ylabel.VerticalAlignment;
    defaults.ylabel.properties.HorizontalAlignment = ylabel.HorizontalAlignment;
    defaults.ylabel.properties.Rotation = ylabel.Rotation;    
    defaults.ylabel.properties.FontAngle = ylabel.FontAngle;
    defaults.ylabel.properties.FontName = ylabel.FontName;
    defaults.ylabel.properties.FontUnits = ylabel.FontUnits;
    defaults.ylabel.properties.FontWeight = ylabel.FontWeight;
    defaults.ylabel.properties.FontSize = ylabel.FontSize;
    defaults.ylabel.properties.LineWidth = ylabel.LineWidth;
    
    title = get(get(cax, 'Title'));    
    defaults.title.Text = title.String;
    defaults.title.Position = title.Position;    
    defaults.title.properties.VerticalAlignment = title.VerticalAlignment;
    defaults.title.properties.HorizontalAlignment = title.HorizontalAlignment;
    defaults.title.properties.Rotation = title.Rotation;    
    defaults.title.properties.FontAngle = title.FontAngle;
    defaults.title.properties.FontName = title.FontName;
    defaults.title.properties.FontUnits = title.FontUnits;
    defaults.title.properties.FontWeight = title.FontWeight;
    defaults.title.properties.FontSize = title.FontSize;
    defaults.title.properties.LineWidth = title.LineWidth;    
    
    shifts.xAxisShift = [0, -0.175];
    shifts.yAxisShift = [1/3, 0];
    shifts.xLabelShift = [ 0.05, 0];
    shifts.yLabelShift = [ 0 , -0.05];
    shifts.titleShift = [ 0.075, 0];    
    
    if nargs > 0
        loop = 1;
        while loop <= nargs
            if iscell(args{loop}) || all(ischar(args{loop}))
                if isempty(inputs.xTickLabels)
                    inputs.xTickLabels = args{loop};
                elseif isempty(yTickLabels)
                    yTickLabels = args{loop};
                else
                    error ('Too many inputs contain text.');
                end
            elseif all(isnumeric(args{loop}))
                if isempty(inputs.xTickPos)
                    inputs.xTickPos = args{loop};
                elseif isempty(inputs.yTickPos)
                    inputs.yTickPos = args{loop};
                else
                    error ('Too many inputs contain numbers.');
                end
            elseif isstruct(args{loop})
                if isfield(args{loop}, 'xAxisShift') || ...
                        isfield(args{loop}, 'yAxisShift') || ...
                        isfield(args{loop}, 'xLabelShift') || ...
                        isfield(args{loop}, 'yLabelShift') || ...
                        isfield(args{loop}, 'titleShift')
                    shifts = mergeStructs(shifts, args{loop});
                else

                    input_properties = args{loop};

                    inputs.xproperties = mergeStructs(defaults.properties, defaults.xproperties, input_properties);
                    inputs.yproperties = mergeStructs(defaults.properties, defaults.yproperties, input_properties);                
                end            
            end
            loop = loop + 1;
        end
    end

    if isempty(inputs.xTickPos)
        if isempty(inputs.xTickLabels)
            inputs.xTickPos = get(cax, 'xtick');
            labels = get(cax, 'xticklabel');
           switch(class(labels))
                case 'char'            
                    for loop = 1:min(length(labels), length(inputs.xTickPos))
                        inputs.xTickLabels{loop} = labels(loop,:);
                    end
                    if loop~=length(inputs.xTickPos)
                        for loop = loop:length(inputs.xTickPos)
                            inputs.xTickLabels{loop} = num2str(inputs.xTickPos(loop));
                        end
                    end
               case 'cell'
                   min(length(labels), length(inputs.xTickPos))
                   for loop = 1:min(length(labels), length(inputs.xTickPos))
                        inputs.xTickLabels{loop} = labels{loop};
                   end
                   if loop<length(inputs.xTickPos)
                       for loop = loop:length(inputs.xTickPos)
                           inputs.xTickLabels{loop} = num2str(inputs.xTickPos(loop));
                       end
                   end
           end
        else
            inputs.xTickPos = 1:length(inputs.xTickLabels);
        end
    end
    if isempty(inputs.xTickLabels)
        inputs.xTickLabels = num2tex(inputs.xTickPos);
    end

    if isempty(inputs.yTickPos)
        if isempty(inputs.yTickLabels)
            inputs.yTickPos = get(cax, 'ytick');
            labels = get(cax, 'yticklabel');            
            switch(class(labels))
                case 'char'
                    for loop = 1:size(labels,1)
                        inputs.yTickLabels{loop} = labels(loop,:);
                    end
                case 'cell'
                    for loop = 1:size(labels,1)
                        inputs.yTickLabels{loop} = labels{loop};
                    end
            end
            if loop<length(inputs.yTickPos)
                for loop2 = loop:length(inputs.yTickPos)
                    inputs.yTickLabels{loop2} = num2str(inputs.yTickPos(loop2));
                end
            end
        else
            inputs.yTickPos = 1:length(inputs.yTickLabels);
        end
    end
    if isempty(inputs.yTickLabels)
        inputs.yTickLabels = num2tex(inputs.yTickPos);
    end
    
    if ~isfield(inputs, 'xAxisLocation')
        inputs.xAxisLocation = get(cax, 'XAxisLocation');
    end
    
    if ~isfield(inputs, 'yAxisLocation')
        inputs.yAxisLocation = get(cax, 'YAxisLocation');
    end
    
    if ~isfield(inputs, 'fontName')
        inputs.fontName = get(cax, 'FontName');
    end
    
    if ~isfield(inputs, 'fontSize')
        inputs.fontSize = get(cax, 'FontSize');
    end
    
    if ~isfield(inputs, 'xlabel')
        inputs.xlabel = struct();
    end
    if ~isfield(inputs, 'ylabel')
        inputs.ylabel = struct();
    end
    
    if~isfield(inputs.xlabel, 'properties')
        inputs.xlabel.properties = struct();
    end
    if~isfield(inputs.ylabel, 'properties')
        inputs.ylabel.properties = struct();
    end
    
    if ~isfield(inputs, 'xproperties')
        inputs.xproperties = mergeStructs(defaults.properties, defaults.xproperties);
    end
    if ~isfield(inputs, 'yproperties')
        inputs.yproperties = mergeStructs(defaults.properties, defaults.yproperties);
    end
    
    if ~isfield(inputs.xlabel, 'Position')
        inputs.xlabel.Position = defaults.xlabel.Position;
    end
    if ~isfield(inputs.ylabel, 'Position')
        inputs.ylabel.Position = defaults.ylabel.Position;
    end
    if ~isfield(inputs.xlabel, 'Text')
        inputs.xlabel.Text = defaults.xlabel.Text;
    end
    if ~isfield(inputs.ylabel, 'Text')
        inputs.ylabel.Text = defaults.ylabel.Text;
    end
    
    if ~isfield(inputs, 'title')
        inputs.title = struct();
    end  
    if~isfield(inputs.title, 'properties')
        inputs.title.properties = struct();
    end    
    inputs.xlabel.properties = mergeStructs(defaults.properties, defaults.xlabel.properties, inputs.xlabel.properties);
    inputs.ylabel.properties = mergeStructs(defaults.properties, defaults.ylabel.properties, inputs.ylabel.properties);
    inputs.title.properties = mergeStructs(defaults.properties, defaults.title.properties, inputs.title.properties);
    inputs.title = mergeStructs(defaults.title, inputs.title);
    inputs = mergeStructs(shifts, inputs);
end

function [  ] = correctLatexPosition(handle, hscale, vscale)
    set(handle, 'Units', 'normalized');
    extentLatex = get(handle, 'Extent');
    %set(handle, 'Interpreter', 'None');
    %extentNone = get(handle, 'Extent');
    position = get(handle, 'Position');
    halign = get(handle, 'HorizontalAlignment');
    valign = get(handle, 'VerticalAlignment');
    switch(halign)
        case 'left'
            newX = position(1) + hscale * extentLatex(3);%(extentLatex(3) - extentNone(3));
        case 'center'
            newX = position(1) - hscale * extentLatex(3);%(extentLatex(3) - extentNone(3));
        case 'right'
            newX = position(1) - hscale * extentLatex(3);%(extentLatex(3) - extentNone(3));
    end
    switch(valign)
        case {'top', 'cap'}
            newY = position(2) + vscale * extentLatex(4);%(extentLatex(3) - extentNone(3));
        case 'middle'
            newY = position(2) - vscale * extentLatex(4);%(extentLatex(3) - extentNone(3));
        case 'bottom'
            newY = position(2) - vscale * extentLatex(4);%(extentLatex(3) - extentNone(3));
    end     
    %newX = position(1) - scale * extentLatex(3);
    %newY = position(2) - scale * extentLatex(4);%(extentLatex(4) - extentNone(4));
    set(handle, 'Position', [newX, newY]);
    set(handle, 'Interpreter', 'Latex');

end


% function [cax, args, nargs] = axescheck(varargin)
%     if nargin < 1
%         cax = [];
%         args = varargin;
%         nargs = 0;
%         return;
%     end
%     if ishandle(varargin{1})
%         cax = varargin{1};
%         if nargin > 1
%             args = varargin{2:end};
%         else
%             args = [];
%         end
%         nargs = nargin - 1;
%     end
% end