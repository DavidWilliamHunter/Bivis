function [ handle ] = plotBarsWithErrors(varargin)
    inputs = processInputs(varargin);
    gh =gca;
    h = ishold(gh);
    
    if isfield(inputs, 'names') || isfield(inputs, 'colours')
        handle = plot(gh, inputs.X, inputs.Y, inputs.width, 'LineStyle', 'none'); hold on;        
        for loop = 1:length(inputs.X)
            handle(1,loop) = plot(gh, inputs.X(loop), inputs.Y(loop), inputs.width); hold on;
            safeSet(handle(1,loop), inputs.propertyList);
            if isfield(inputs,'colours')
                set(handle(1,loop), 'FaceColor', inputs.colours(loop,:));
            end
            if isfield(inputs,'names')
                set(handle(1,loop), 'DisplayName', inputs.names{loop});
            end
            handle(2,loop) = errorbar(gh, inputs.X(loop), inputs.Y(loop), inputs.M(1,loop), inputs.M(2,loop) ,'k.');
            safeSet(handle(2,loop), inputs.propertyList);
        end
    else
        handle(1) = plot(gh, inputs.X', inputs.Y, 'LineWidth', 0.5, 'Color', [ 0 0 0 ]); hold on;
        %errorbar(1:length(inputs.Y), inputs.Y, inputs.M(1,:), inputs.M(2,:) ,'k-','LineWidth',3);
        handle(2) = errorbar(gh, inputs.X, inputs.Y, inputs.M(1,:), inputs.M(2,:) ,'k.','LineWidth',1);
    
        set(gh,'FontName', 'Helvetica');
        set(gh,'FontSize',10);
        set(gca, 'LineWidth', 1);
    end
    
    if isfield(inputs,'names')
        set(gca, 'XTickLabels', inputs.names);
    end
            
    axis tight;
    if h
        hold on;
    else
        hold off;
    end
end

function [ structuredInputs ] = processInputs(varargin)
    args = varargin{1};

    defaultSettings = defaults();
    
    if(numel(args)<3)
        error('Not enough inputs see "help plotBarsWithErrors" for syntax');
    end
    
    if(~ismatrix(args{1}))
        error('First input variable is incorrectly formatted see "help plotBarsWithErrors" for syntax');
    end
    
    if(~ismatrix(args{2}))
        error('Second input variable is incorrectly formatted see "help plotBarsWithErrors" for syntax');
    end
    
    if(~ismatrix(args{3}))
        error('Third input variable is incorrectly formatted see "help plotBarsWithErrors" for syntax');
    end    
    
    inputs.X = args{1};
    inputs.Y = args{2};
    inputs.M = args{3};
    
    pos = 4;
    index = 1;
    
    inputs.propertyList = [];
    while(pos<=(length(args)))
        args{pos};
        if iscell(args{pos})
            names = args{pos};
            isc = true;
            for loop = 1:length(names)
                if ~ischar(names{loop})
                    isc = false;
                end
            end
            if isc
                if length(names)~=length(inputs.X)
                    error('Number of supplied names must be equal to number of supplied bars.');
                end
                inputs.names = names;
                pos = pos + 1;
            end
        elseif isnumeric(args{pos})
            colours = args{pos};
            if size(colours,2)==3
                if size(colours,1)~=length(inputs.X)
                    error('Number of supplied colours must be equal to number of supplied bars.');
                else
                    inputs.colours = colours;
                end
            end
            pos = pos + 1;
        elseif pos<(length(args)-1)           
            inputs.propertyList{index} = args{pos};
            inputs.propertyList{index+1} = args{pos+1};
            pos = pos + 2;
            index = index + 2;
        else
            error('Too many arguements.');
        end
    end
    structuredInputs = mergeStructs(defaultSettings, inputs);     
end

function [ defaultSettings ] = defaults()
    defaultSettings = struct();
    defaultSettings.width = 0.8;
end


function safeSet(handle, varargin)
    if length(varargin)==1
        attrs = varargin{1};
        for loop = 1:2:length(attrs)
            safeSet(handle, attrs{loop}, attrs{loop+1});
        end
    else
        try
            set(handle, varargin{1}, varargin{2});
        catch me
        end
    end
end