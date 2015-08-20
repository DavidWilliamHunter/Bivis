function [ handle ] = polarR(varargin)
% Radian version of the polar plot
%
%

    [cax, args, nargs] = axescheck(varargin{:});

    inputs = processInput(args);

    cax = newplot(cax);

    hold_state = ishold(cax);

    handle = struct;
    if ~hold_state
        handle.radar =  drawRadar(cax, inputs.dataRange, inputs.angleRange);
        handle.rLabels = drawRLabels(cax, inputs.dataRange, inputs.rRange, inputs.angleRange);
        handle.aLabels = drawALabels(cax, inputs.dataRange, inputs.angleRange, inputs.angleLabels);

        set(cax, 'DataAspectRatio', [1, 1, 1]), axis(cax, 'off');

        set(get(cax, 'XLabel'), 'Visible', 'on');
        set(get(cax, 'YLabel'), 'Visible', 'on');        
    end
    if isfield(inputs,'angles') && isfield(inputs,'radius') && isfield(inputs,'cmd')
        [x,y] = pol2cart(inputs.angles,inputs.radius);
        hold on
        handle.func = plot(cax, x,y,inputs.cmd);
        handle.cax = cax;
    end
    if(hold_state)
        hold on
    else
        hold off
    end
end

function [ inputs ] = processInput(varargin)
    args = varargin{1};

    if length(args)<1
        error('Not enough input parameters');
    end

    defaults = getDefaults();

    if length(args)>1
        if isnumeric(args{1})
            if isnumeric(args{2})
                inputs.angles = args{1};
                inputs.radius = args{2};
                paramInd = 3;
                valInd = 4;
            else
                inputs.radius = args{1};
                inputs.angles = linspace(0, 2*pi, length(inputs.radius));
                paramInd = 2;
                valInd = 3;
            end
        else
            paramInd = 1;
            valInd = 2;
        end
    else if isnumeric(args{1})
            inputs.radius = args{1};
            inputs.angles = linspace(0, 2*pi, length(inputs.radius));
            paramInd = 2;
            valInd = 3;
        else
            paramInd = 1;
            valInd = 2;
        end
    end

    inputs.parameters = {};
    inputs.values = {};  

    while length(args)>=valInd
        param = args{paramInd};
        val = args{valInd};
        switch(lower(param))
            case {'valuerange', 'value_range', 'value range'}
                inputs.valueRange = val;
            case {'anglerange', 'angle_range', 'angle range'}
                inputs.angleRange = val;
            case {'datarange', 'data_range', 'data range'}
                inputs.dataRange = val;
            case {'r labels', 'rlabels', 'r_labels'}
                inputs.rRange = val;
            case {'a labels', 'alabels', 'a_labels'}
                inputs.angleLabels = val;
            case {'rings'}
                inputs.rings = val;
            otherwise
                inputs.parameters = [ inputs.parameters ; param ];
                inputs.values = [ inputs.values ; val ];
        end
        paramInd = paramInd + 2;
        valInd = valInd + 2;
    end

    % validate lengths
    if isfield(inputs, 'rings') && isfield(inputs, 'rRange')
        if length(inputs.rRange)~=inputs.rings+1;
            error('Number of Labels must equal number of rings + 1');
        end
    end
    
    if isfield(inputs,'dataRange') && isfield(inputs,'rings')
        if length(inputs.dataRange)~=inputs.rings+1;
            error('Number of range points must equal number of rings + 1');
        end
    end
    
    if ~isfield(inputs,'rings')
        if isfield(inputs, 'rRange')
            inputs.rings = length(inputs.rRange)-1;
        else
            inputs.rings = defaults.rings;
        end
    end
    
    if ~isfield(inputs, 'dataRange')       
        if isfield(inputs, 'valueRange')
            inputs.dataRange = linspace(0, max(inputs.valueRange(:)), inputs.rings+1);
        else
            inputs.dataRange = linspace(0, max(inputs.radius(:)), inputs.rings+1);
        end
    end
        
    if ~isfield(inputs, 'rRange')
        inputs.rRange = inputs.dataRange;
    end
    
    if length(args)==paramInd
        inputs.cmd = args{paramInd};
    end

    inputs = mergeStructs(defaults, inputs);
end

function [ defaults ] = getDefaults()
    defaults.rings = 5;
    defaults.seqments = 6;
    defaults.angleRange = 0:pi/defaults.seqments:2*pi;
    defaults.cmd = 'b-';
end

function [ handle ] = drawRadar(cax, range, angle_range)
    set(gca, 'Visible','off')
    theta = [ min(angle_range):0.01:max(angle_range) min(angle_range) ];
    maxRange = max(range(:));

    [x , y] = pol2cart(theta, ones(size(theta)).*maxRange.*1.25);
    handle.max_background_handle = patch(x, y, 1, 'FaceColor', [1 1 1], 'LineStyle', 'none', 'Parent', cax);    
    
    [x , y] = pol2cart(theta, ones(size(theta)).*maxRange);
    handle.background_handle = patch(x, y, 1, 'FaceColor', [1 1 1], 'LineWidth', 1, 'Parent', cax);
 
    scale = 1.0./(length(range)-1);

    for loop = 1:length(range)-1
        [x , y] = pol2cart(theta, ones(size(theta)).*(loop).*scale.*maxRange);
        handle.rods(loop) = line(x,y, 'Color', [0 0 0], 'LineStyle', ':', 'Parent', cax);
    end
  
    
    %names = { '0', '$\frac{\pi}{6}$', '$\frac{2\pi}{6}$', '$\frac{\pi}{2}$', '$\frac{4\pi}{6}$', '$\frac{5\pi}{6}$', '$\pi$', '$\frac{7\pi}{6}$', '$\frac{8\pi}{6}$', '$\frac{3\pi}{2}$', '$\frac{10\pi}{6}$', '$\frac{11\pi}{6}$', '$\pi$' };
    values = unique(mod(angle_range,2*pi));
    for loop = 1:length(values)
        [x,y] = pol2cart([values(loop) values(loop)],[0 maxRange]);
        handle.spokes(loop) = line(x,y, 'Color', [0 0 0], 'LineStyle', ':', 'Parent', cax);
    end
end

function handles = drawRLabels(cax, range, range_labels, angle_range)
if max(angle_range)<=pi
    maxRange = max(range(:));
    %shift = (3 - max(mod(angle_range,2*pi))./pi).*2 + 2;
    shift = maxRange./7.5;
    scale = 1.0./(length(range)-1);
    for loop = 1:length(range)
        [x, y] = pol2cart(0, (loop-1).*scale.*maxRange);
        lableText = num2str(range_labels(loop), '%2.1g');
        handles(loop) = text(x,y-shift, lableText, 'Interpreter','latex', ...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'middle',...
            'Color', [0 0 0], 'FontName', 'Helvetica', 'FontSize', 10, 'Parent', cax);
    end
else
    handles = [];
end
end

function handles = drawALabels(cax, range, angle_range, angle_labels)
    [values,inds] = unique(mod(angle_range,2*pi));
    angle_labels = angle_labels(inds);
    shift = 0.1./pi.*max(values(:)) + 1;
    maxRange = max(range(:));    
    for loop = 2:length(values)-1
        [x,y] = pol2cart(values(loop),shift.*maxRange);
        name = num2tex(angle_labels(loop), '\pi',pi);
        handles(loop) = text(x,y, name, 'Interpreter','latex', 'HorizontalAlignment', 'center', 'Color', [0 0 0], 'FontName', 'Helvetica', 'FontSize', 10, 'Parent', cax);
    end
    
    [x,y] = pol2cart(values(1),shift.*maxRange);
    name = num2tex(angle_labels(1), '\pi',pi);
    text(x,y+maxRange./25, name, 'Interpreter','latex', 'HorizontalAlignment', 'center', 'Color', [0 0 0], 'FontName', 'Helvetica', 'FontSize', 10, 'Parent', cax);
    
    [x,y] = pol2cart(values(end),shift.*maxRange);
    name = num2tex(angle_labels(end), '\pi',pi);
    text(x,y+maxRange./25, name, 'Interpreter','latex', 'HorizontalAlignment', 'center', 'Color', [0 0 0], 'FontName', 'Helvetica', 'FontSize', 10, 'Parent', cax);
end

