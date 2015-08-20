function [ handle, bins, median_distribution, CI, indices ] = plotBootstrappedDistribution(varargin)
% [ handle, bins, distribution, CI ] = plotBootstrappedDistribution(data, boxes, func)

    [cax, args] = axescheck(varargin{:});

    inputs = processInputs(args);

    parameters = preprocessData(inputs);
    
    distribution = computeDistribution(parameters);
    
    cax = newplot(cax);

    hold_state = ishold(cax);
    
    
    
    if isa(parameters.plot_function, 'function_handle')
        handle = parameters.plot_function(distribution);
    else
        handle = plotBarsWithErrors(distribution.bins, distribution.median, distribution.margin);
    end
    %handle = plotWithFunctionHeatmap(h);
    
    if hold_state
        hold on
    else
        hold off
    end
    
    bins =  distribution.bins;
    median_distribution = distribution.median;
    CI = distribution.CI;
end

function [ parameters ] = preprocessData(inputs)
    parameters.noSamples = size(inputs.data,2);
    parameters.noBootstraps = size(inputs.data,1);
    
    % pre-process data
    if isempty(inputs.selection)
        parameters.selection = true(size(inputs.data));
    else
        % check for value sizes of the selection parameters
        if length(inputs.selection(:))==parameters.noSamples
            parameters.selection = repmat(inputs.selection(:), 1, parameters.noSamples);
        elseif length(inputs.selection(:))==parameters.noBootstraps
            parameters.selection = repmat(inputs.selection(:), parameters.noBootstraps,1 );
        elseif length(size(inputs.selection))==length(size(inputs.data)) ...
                && all(size(inputs.selection)==size(inputs.data))
            parameters.selection = inputs.selection;
        end
    end
    
    if isempty(inputs.applyFunction)
        parameters.workingData = inputs.data;
    elseif isa(inputs.applyFunction ,  'function_handle')
        parameters.workingData = inputs.applyFunction(inputs.data);
    end
    
    parameters = mergeStructs(inputs, parameters);
end

function [ distribution ] = computeDistribution(parameters)
    distribution.noBootstraps = parameters.noBootstraps;
    % get appropriate bin centers
    if(isscalar(parameters.boxes))
        [~,distribution.bins] = parameters.histogram_func(parameters.workingData(parameters.selection), parameters.boxes);
        distribution.noBoxes = length(distribution.bins);
    else
        distribution.bins = parameters.boxes;
        distribution.noBoxes = length(distribution.bins);
    end
    
    distribution.map = []; %zeros(parameters.noBootstraps, distribution.noBoxes);
    for loop = 1:parameters.noBootstraps
        distribution.map(loop,:) = parameters.histogram_func(parameters.workingData(loop,parameters.selection(loop,:)), distribution.bins);
    end

    
    
    distribution.sorted_map = sort(distribution.map, 1);
    distribution.median = median(distribution.sorted_map,1);
    distribution.CI = [ distribution.sorted_map(ceil(parameters.noBootstraps.*0.025),:) ; ...
        distribution.sorted_map(ceil(parameters.noBootstraps.*0.975),:)];
    distribution.margin = [distribution.median - distribution.CI(1,:) ;...
        distribution.CI(2,:) - distribution.median ];
    
        distribution = mergeStructs(parameters, distribution);    

end
    
function [ inputs ] = processInputs(varargin)
% [ handle, bins, distribution, CI ] = plotBootstrappedDistribution(data, boxes, func)

    args = varargin{1};
    nargs = length(args);
    
    defaults = getDefaults();
    
    if nargs < 2
        error('Not enough inputs, see help plotBootstrappedDistribution for more info');
    end
    
    inputs.data = args{1};
    inputs.boxes = args{2};
        
    
    paramInd = 3;
    valueInd = 4;
    
    if nargs>2
        if isa(args{3}, 'function_handle')
            inputs.applyFunction = args{3};
            paramInd = paramInd + 1;
            valueInd = valueInd + 1;
        elseif all(islogical(args{3}))
            inputs.selection = args{3};
            paramInd = paramInd + 1;
            valueInd = valueInd + 1;
        end
    end
        
    inputs.fieldnames = {};
    inputs.fieldvalues = {};
    while valueInd <= nargs
        param = args{paramInd};
        value = args{valueInd};
        
        switch(lower(param))
            case {'applyfunction', 'apply_function', 'apply function', 'apply func'}
                if isa(value, 'function_handle')                   
                    inputs.applyFunction = value;
                else
                    error(['Value for ' param ' must be a function handle']);
                end
            case {'selection'}
                if all(islogical(value))
                    inputs.selection = value;
                else
                    error(['Value for ' param ' must be an matrix of logicals.']);
                end
            case {'plot','plotfunc','plot_func','plotfunction','plot_function' 'plot func', 'plot function'}
                if isa(value, 'function_handle') || ischar(value)                    
                    inputs.plot_function = value;
                else
                    error(['Value for ' param ' must be a function handle']);
                end
            case { 'anglerange', 'angle_range' }
                inputs.rose_angle_range = value;
            case unique([fieldnames(get(gca)) ; fieldnames(get(gcf))])
                inputs.fieldnames = [ inputs.fieldnames param ];
                inputs.fieldvalues = [ inputs.fieldvalues values ];
            otherwise
                error(['Unknown paramters name , ' param ]);
        end
        paramInd = paramInd + 2;
        valueInd = valueInd + 2;
    end
    
    inputs = mergeStructs(defaults, inputs);
    plotting_parameters = setupPlotting(inputs);
    inputs = mergeStructs(inputs, plotting_parameters);    
end

function [ defaults ] = getDefaults()
    defaults.plot_function = 'hist'; %@plotBarsWithErrors;
    defaults.applyFunction = [];
    defaults.selection = [];
    defaults.histogram_func = @percHist;
end


%%
% select the correct plotting function and setup any ancilary variables
function [ plot_parameters ] = setupPlotting(inputs)
    if isa(inputs.plot_function,'function_handle')
        type = exist(func2str(inputs.plot_function));
        if ~(type == 2 || type == 3 || type == 5)
            error('Function handle does not point to a valid functin');
        end
    else
        if ~ischar(inputs.plot_function)
            error('Invalid type of plot function, valid types are function_handle or String');
        end
        switch lower(inputs.plot_function)
            case { 'hist', 'errorbars' }
                plot_parameters.plot_function = @plotWithErrorBars;
            case { 'lhist'}
                plot_parameters.plot_function = @plotLinesErrorBars;
            case { 'chist', 'histc' }
                plot_parameters.plot_function = @plotWithErrorBars;
                plot_parameters.histogram_func = @cHistDist;
            case { 'manylines' }
                plot_parameters.plot_function = @plotWithManyLines;
            case { 'cmanylines', 'manylinesc' }
                plot_parameters.plot_function = @plotWithManyLines;  
                plot_parameters.histogram_func = @cHistDist;                
            case { 'rose' }
                plot_parameters.plot_function = @plotAsRose;
                plot_parameters.histogram_func = @roseDist;
                
                if isfield(inputs, 'rose_angle_range')
                    plot_parameters.rose_angle_range = unique(mod(inputs.rose_angle_range,2*pi));
                else
                    plot_parameters.rose_angle_range = 0:pi/6:2*pi;
                end
            otherwise
                error('Unknown type of plotting function');
        end
    end
end
    
    

%%
% A collection of plotting functions
%
function [ handle ] = plotWithErrorBars(distribution)
    handle = plotBarsWithErrors(distribution.bins, distribution.median, distribution.margin);
end

function [ handle ] = plotLinesErrorBars(distribution)
    handle = plotLinesWithErrors(distribution.bins, distribution.median, distribution.margin);
end

function [ handle ] = plotWithManyLines(distribution)
    %handle = plotWithFunctionHeatmap(distribution.bins, distribution.median, distribution.margin);
    handle = plotWithFunctionHeatmap(distribution.bins, distribution.map);
end

function [ handle ] = plotAsRose(distribution)
    % turn distribution into triangle
    stepSize = (distribution.bins(2)- distribution.bins(1));
    halfStepSize = stepSize ./2;
    triBins = zeros(length(distribution.bins).*3,4);
    triBins(2:3:length(triBins),1) = distribution.bins-halfStepSize;
    triBins(3:3:length(triBins),1) = distribution.bins+halfStepSize;
    triBins(2:3:length(triBins),2) = distribution.median;
    triBins(3:3:length(triBins),2) = distribution.median;
        
    dataRange = linspace(0, max(triBins(:,2)), 4);
    if any(dataRange>1000)
        dataRange = dataRange./1000;
    end
    polarR('value_range', linspace(0,max(distribution.CI(:)),5), 'angle_range' , distribution.rose_angle_range, 'a labels', distribution.rose_angle_range , 'r labels', dataRange);
    %polarR('value_range', linspace(0,max(distribution.CI(:)),5), 'angle_range' , distribution.rose_angle_range);
    
    rectBins = zeros(length(distribution.bins).*4,2);
    
    rectBins(1:4:size(rectBins,1),1) = distribution.bins - halfStepSize;
    rectBins(2:4:size(rectBins,1),1) = distribution.bins + halfStepSize;
    rectBins(3:4:size(rectBins,1),1) = distribution.bins + halfStepSize;
    rectBins(4:4:size(rectBins,1),1) = distribution.bins - halfStepSize;
    
    rectBins(1:4:size(rectBins,1),2) = distribution.CI(1,:);
    rectBins(2:4:size(rectBins,1),2) = distribution.CI(1,:);
    rectBins(3:4:size(rectBins,1),2) = distribution.CI(2,:);
    rectBins(4:4:size(rectBins,1),2) = distribution.CI(2,:);
    
    [x , y] = pol2cart(rectBins(:,1), rectBins(:,2));
        
    %px=[x(1,inds1),fliplr(x(2,inds2))]; % make closed patch
    %py=[y(1,inds1), fliplr(y(2,inds2))];
    %ph = patch(px,py,1,'FaceColor','r','EdgeColor','r');
    for loop = 1:4:length(x)
        ph = patch(x(loop:loop+3),y(loop:loop+3),1,'FaceColor','r','EdgeColor','r');
        alpha(ph, 0.5)
    end
    
    hold on
    
    handle = polarR(triBins(:,1), triBins(:,2), 'k-');
    set(handle.func, 'Color', [0 0 0 ]);
    set(handle.func, 'LineWidth', 0.5);
end

%%

function [ dist, bins ] = roseDist(theta,n)
    theta = mod(theta, 2*pi);
    
    if length(n)==1,
        n = (0:n-1)*2*pi/n + pi/n;
    else
        n = sort(mod(n(:)',2*pi));
    end   
    
    [ dist, bins ] = hist(theta, n);
    s = sum(dist(:));
    dist = dist./s;
end

%%
function [ dist, bins ] = cHistDist(data, n)
    [ dist, bins ] = hist(data,n);
    s = sum(dist(:));
    dist = cumsum(dist);
    dist = dist./s;
end

%%
function [ dist, bins ] = percHist(data, n)
    [ dist, bins ] = hist(data,n);
    s = sum(dist(:));
    dist = dist./s;
end
