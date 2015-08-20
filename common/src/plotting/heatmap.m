% General purpose function for generating and displaying Heatmaps.
% Calculates the joint (or conditional) distribution of two data sets and
% displays as a heatmap.
%
% Basic Syntax
%   heatmap(distribution)
%   heatmap(x_data, y_data)
%   heatmap(distribution, command_list)
%   heatmap(x_data, y_data, command_list)
%   
%   distribution = heatmap()
%   distribution = heatmap(gridData)
%   distribution = heatmap(gridData, command_list)
%   distribution = heatmap(x_data, y_data)
%   distribution = heatmap(distribution, command_list)
%   distribution = heatmap(x_data, y_data, command_list)
%
%
% inputs/outputs
%   x_data - vector of finite (numerical) values, first distribution.
%   y_data - vector of finite (numerical) values, second distribution.
%   distribution - structure of data about the distribution - described
%           below.
%  
% Command list
%   The command list is an unordered list of optional properties to control
%   the generation and display of the joint distribution.
%   
%   In the event of multiple instances of the same property being supplied
%   the chosen property is selected with the following priority.
%
%(highest) command_list -> distribution (input variable) -> default (lowest)
%
%   Priority in the command list is from right (highest) to left (lowest)
%   The commands are pairs of property name followed by property values.
%   e.g
%   heatmap(x_data, y_data, 'ncellx', 25)
%
%   Property            Description
%   ----------------|-----------------
%   cell_scaling    |  A scaling to be applied to bin counts after
%                   |  computation of the heatmap.
%                   |  (string) *one* of 'linear', 'log', 'log10'
%                   |   Default: 'linear'
%   display         |  Type of heatmap to display.
%                   |   (string) *one* of 'polar','polarX','polarY',
%                   | 'heat', 'box''off'
%                   |   Default 'heat'
%   XLabel          |  (String) label to display on the X-axis
%                   |   Default: empty string ''
%   YLabel          |  (String) label to display on the Y-axis
%                   |   Default: empty string ''
%   mode            |
%   ncellx          |  Number of horizontal bins (columns) in the heatmap
%                   |   Default: calculated from data.
%   ncelly          |  Number of vertical bins (rows) in the heatmap
%                   |   Default: calculated from data
%   cutoffsX        |  Vector of bin centers for the x-axis. Actual bin
%                   |  content is ignored. The first value in the vector is
%                   |  taken as the start of the first bin, the last value 
%                   |  as the end of the final bin. The length of the 
%                   |  vector is taken as the number of bins. The centers 
%                   |  are recalculated. This is because the internal
%                   |  binning algorithm assumes identical bin sizes.
%                   |   Default: calculated from ncellx
%   cutoffsY        | Vector of bin centers for the y-axis (see cutoffsX)
%                   |   Default: calculated from ncelly
%   probability     | Type of probability operation. A Joint distribution
%                   | is simply a 2D binning operation. A conditional 
%                   | distribution are joint distributions normallised by
%                   | rows of columns.
%                   | (String) *one* of 'conditional', 'conditionalX',
%                   |   'conditionalY', 'conditionalXY', 'joint'
%                   |   Default: 'joint'
%   merge           | Merge two distributions. The distibutions must be
%                   | identically sized (same number of bins). If 'merge'
%                   | is combined with x_data and y_data input the bin
%                   | sizes of the merged structure are used.
%                   | (distribution structure) the structure created by a
%                   | previous heatmap function to merge with.
%   color_map       | Matlab color map to use to colour the heatmap plot
%                   | (string) any matlab colormap e.g. 'jet', 'hsv'
%                   |   Default: 'jet'
%
% Dodgy, not well implemented commands.
%   x_scaling       |  Scale x_data before computing heatma.
%                   |  (string) *one* of 'linear' 'log'
%                   |   Default: 'linear'
%   y_scaling       |  Scale y_data before computing heatma.
%                   |  (string) *one* of 'linear' 'log'
%                   |   Default: 'linear'
%
%
%  Output: Distribution structure.
%   distribution.map    - The processed bin counts (after optional
%               conditional probability and log transforms).
%   distribution.cutoffsX - The bin edges (not centers) of the x-axis.
%               Length is always number of bins plus one.
%   distribution.cutoffsY - The bin edges (not centers) of the y-axis.
%               Length is always number of bins plus one.
%   distribution.probability - probability type (see properties)
%   distribution.labels.x_axis_label - x axis label
%   distribution.labels.y_axis_label - y axis label
%   distribution.settings.cell_scaling - cell_scalling property.
%   distribution.settings.chart_type - chart_type property.
%   distribution.settings.color_map - color_map property.
%   distribution.settings.display - display property.
%   distribution.settings.x_scaling - x_scaling property.
%   distribution.settings.y_scaling - y_scaling property.
%

function [ distribution ] = heatmap(varargin)



    [distribution, temporaries] = processInputs(varargin);
    
    if(nargin==0)
        return
    end
    

    
    %% compute
    switch(temporaries.command)
        case {'calculated', 'creating'}
            % already calculated do nothing
            map = distribution.map;
            cutoffsX = distribution.cutoffsX;
            cutoffsY = distribution.cutoffsY;
        case {'normal', 'merge'}
            switch(distribution.settings.chart_type)
                case {'heat', 'hist'}
                    switch(distribution.settings.x_scaling)
                        case 'log'
                            temporaries.x_data = log(temporaries.x_data);
                            inds = ~(isinf(temporaries.x_data) | isnan(temporaries.x_data));
                            temporaries.x_data = temporaries.x_data(inds);
                            temporaries.y_data = temporaries.y_data(inds);
                            %x_data(isinf(x_data)) = 0.00001;
                            %x_data(x_data < 0.0001) = 0.00001;   
                    end

                    switch(distribution.settings.y_scaling)
                        case 'log'
                            temporaries.y_data = log(temporaries.y_data);
                            %y_data(isinf(y_data)) = 0.00001;
                            inds = ~(isinf(y_data) | isnan(y_data));
                            temporaries.x_data = temporaries.x_data(inds);
                            temporaries.y_data = temporaries.y_data(inds);            
                            %y_data(y_data < 0.0001) = 0.00001;             
                    end            

                    [ map , cutoffsX, cutoffsY ] = histogram2(distribution, temporaries);
                case 'maximum_y'
                    error('depreciated');
         %           [ distribution , cutoffsX, cutoffsY ] = histogram2(distribution, temporaries);
         %           
         %           [~, inds] = max(distribution);
         %           
         %           distribution = cutoffsY(inds);
         %           
         %           plot(cutoffsY(inds));
         %           
         %           xlabel(x_axis_label);
         %           ylabel(y_axis_label);
         %           set(gca,'XTick', 1:length(cutoffsX)/5:length(cutoffsX));
         %           set(gca,'XTickLabel', cutoffsX(round(1:length(cutoffsX)/5:end)));            
                otherwise
                    error('depreciated');            
         %           [ distribution , descriptor, cutoffsX, cutoffsY ] = binOnX(distribution, temporaries);
         %           sums = feval_to_vector('sum', distribution);
         %           distribution = feval_over_vector('rdivide', distribution , sums);
         %           distribution = feval_to_vector(chart_type, distribution);
         %           plot(distribution);
         %           xlabel(x_axis_label);
         %           ylabel(y_axis_label);
         %           set(gca,'XTick', 0:length(distribution)/5:length(distribution));
         %           set(gca,'XTickLabel', roundsd(descriptor(1,:),3, 'round'));
            end
    end
    
    %%
    switch(distribution.probability)
        case {'conditional', 'conditionalX'}
            temp = map;
            temp(~isfinite(map)) = 0;
            map = map ./  (sum(temp,2) *ones(1,size(temp,2)));
        case 'conditionalY'
            temp = map;
            temp(~isfinite(map)) = 0;  
            map = map ./  (ones(size(temp,1),1) * sum(temp,1));
        case 'conditionalXY'
            for loop = 1:10
            temp = map;
            temp(~isfinite(map)) = 0;  
            map = map ./  (ones(size(temp,1),1) * sum(temp,1));
            temp = map;
            temp(~isfinite(map)) = 0;             
            map = map ./  (sum(temp,2) *ones(1,size(temp,2)));
            end
    end
            
    if(strcmp(distribution.probability,'conditional')==1)
        map = map ./  (sum(map,2) *ones(1,size(map,2)));
    end
    

    switch(distribution.settings.cell_scaling)
        case 'log'        
            map = log(map);
        case 'log10'
            map = log10(map);
    end     
    
    %%
    switch(temporaries.command)
        case 'merge'
            if(isfield(distribution, 'map') && isfield(distribution, 'cutoffsX') && isfield(distribution, 'cutoffsY') && ...
                    ~isempty(distribution.map) && ~isempty(distribution.cutoffsX) && ~isempty(distribution.cutoffsY))
    
                xcellSize = max(distribution.cutoffsX(2:end)- distribution.cutoffsX(1:end-1));
                ycellSize = max(distribution.cutoffsY(2:end)- distribution.cutoffsY(1:end-1));
                assert(all((cutoffsX - distribution.cutoffsX)./xcellSize < 0.01), 'Cell boundaries on X do not match');
                assert(all((cutoffsY - distribution.cutoffsY)./ycellSize < 0.01), 'Cell boundaries on Y do not match');            
                assert(all(size(map)==size(distribution.map)), 'Cell counts of the two maps do not match');
            
                distribution.map = distribution.map + map;
                distribution.cutoffsX = cutoffsX;
                distribution.cutoffsY = cutoffsY;
            else
                distribution.map = map;
                distribution.cutoffsX = cutoffsX;
                distribution.cutoffsY = cutoffsY;
            end
        otherwise
            distribution.map = map;
            distribution.cutoffsX = cutoffsX;
            distribution.cutoffsY = cutoffsY;            
    end
    

    %% display
    switch(temporaries.command)
        case 'creating'
            return
        otherwise
        temp = distribution;
        switch(distribution.settings.display)
            case 'off'
            otherwise
                temp.map(~isfinite(temp.map)) = min(temp.map(isfinite(temp.map)));
                display_heatmap(distribution);
        end
    end
            
end

function [ ] = checkVectors(x_data, y_data)
    % Some initial tests on the input arguments

    [NRowX,NColX]=size(x_data);

    if NRowX~=1
        error('Invalid dimension of X');
    end;

    [NRowY,NColY]=size(y_data);

    if NRowY~=1
        error('Invalid dimension of Y');
    end;

    if NColX~=NColY
        error('Unequal length of X and Y');
    end;
end

function [ bins, cutoffsX, cutoffsY ] = histogram2(~, temporaries)
 
    [~,NColX]=size(temporaries.x_data);
    %if(length(temporaries.ncellx)==1)
    %    minx=min(temporaries.x_data);
    %    maxx=max(temporaries.x_data);
    %    ncellx = temporaries.ncellx;
    %else
    %    minx = temporaries.ncellx(1);
    %    maxx = temporaries.ncellx(end);
    %    ncellx = length(temporaries.ncellx);
    %end

    %if(length(temporaries.ncelly)==1)
    %    miny=min(temporaries.y_data);
    %    maxy=max(temporaries.y_data);
    %    ncelly = temporaries.ncelly;
    %else
    %    miny = temporaries.ncelly(1);
    %    maxy = temporaries.ncelly(end);
    %    ncelly = length(temporaries.ncelly);
    %end

    minx = temporaries.minx;
    maxx = temporaries.maxx;
    ncellx = temporaries.ncellx;
    
    miny = temporaries.miny;
    maxy = temporaries.maxy;
    ncelly = temporaries.ncelly;
    
    deltax=0;%(maxx-minx)/(length(temporaries.x_data)-1);
    %ncellx=ceil(length(x)^(1/3));

    deltay=0;%(maxy-miny)/(length(temporaries.y_data)-1);
    %ncelly=ncellx;
    %descriptor=[minx-deltax/2,maxx+deltax/2,ncellx;miny-deltay/2,maxy+deltay/2,ncelly];


    lowerx=minx-deltax/2;
    upperx=maxx+deltax/2;
    lowery=miny-deltay/2;
    uppery=maxy+deltay/2;


    cutoffsX = lowerx:(upperx-lowerx)/(ncellx):upperx;
    cutoffsY = lowery:(uppery-lowery)/(ncelly):uppery;

    bins(1:ncellx,1:ncelly)=0;

    xx=round( (temporaries.x_data-lowerx)/(upperx-lowerx)*ncellx + 1/2 );
    yy=round( (temporaries.y_data-lowery)/(uppery-lowery)*ncelly + 1/2 );
    
    for n=1:NColX
        indexx=xx(n);
        indexy=yy(n);
        if indexx >= 1 && indexx <= ncellx && indexy >= 1 && indexy <= ncelly
            bins(indexx,indexy)=bins(indexx,indexy)+1;
        end;
    end;         
end


function [ result, descriptor, cutoffsX, cutoffsY ] = binOnX(x,y)
  
    [~,NColX]=size(x);

    minx=min(x);
    maxx=max(x);
    deltax=(maxx-minx)/(length(x)-1);
    ncellx=ceil(length(x)^(1/4));
    miny=min(y);
    maxy=max(y);
    deltay=(maxy-miny)/(length(y)-1);
    ncelly=ncellx;
    %descriptor=[minx-deltax/2,maxx+deltax/2,ncellx;miny-deltay/2,maxy+deltay/2,ncelly];


    lowerx=minx-deltax/2;
    upperx=maxx+deltax/2;
    lowery=miny-deltay/2;
    uppery=maxy+deltay/2;


    descriptor(1,:) = lowerx:(upperx-lowerx)/5:upperx;
    descriptor(2,:) = lowery:(uppery-lowery)/5:uppery;
    result(1:ncellx,1:ncelly)=0;
    
    cutoffsX = lowerx:(upperx-lowerx)/(ncellx):upperx;
    cutoffsY = lowery:(uppery-lowery)/(ncelly):uppery;
    
    xx=round( (x-lowerx)/(upperx-lowerx)*ncellx + 1/2 );
    yy=round( (y-lowery)/(uppery-lowery)*ncelly + 1/2 );
    
    % memory managment is expensive so calculate the bin sizes in advance    
    for n=1:NColX
        indexx=xx(n);
        indexy=yy(n);
        if indexx >= 1 && indexx <= ncellx && indexy >= 1 && indexy <= ncelly
            result(indexx,indexy)=result(indexx,indexy)+1;
        end;
    end;
    
    counts = sum(result,2);
    result = cell(1,ncellx);
    for n=1:ncellx
        result{n} = inf(1,counts(n));
    end
    counts = ones(1,ncellx);

    for n=1:NColX
        indexx=xx(n);
        indexy=yy(n);
        if indexx >= 1 && indexx <= ncellx && indexy >= 1 && indexy <= ncelly
            result{indexx}(counts(indexx)) = y(n);
            counts(indexx) = counts(indexx) + 1;
        end;
    end;
end

function [ result ] = feval_to_vector(varargin)
    if nargin==1
        cells = varargin{1};
        result = zeros(size(cells));
        for n = 1:numel(cells)
            result(n) = cells{n};
        end
    elseif nargin==2
        function_handle = varargin{1};
        cells = varargin{2};
        results = cell(size(cells));
        for n = 1:numel(cells)
            results{n} = feval(function_handle, cells{n});
        end

        result = feval_to_vector(results);
    end
end
    
function [ results ] = feval_over_vector(varargin)
    if nargin==2
        function_handle = varargin{1};
        cells = varargin{2};
        results = cell(size(cells));
        for n = 1:numel(cells)
            results{n} = feval(function_handle, cells{n});
        end
    elseif nargin==3
        function_handle = varargin{1};
        cells = varargin{2};
        results = cell(size(cells));
        for n = 1:numel(cells)
            results{n} = feval(function_handle, cells{n}, varargin{3}(n));
        end
    end
end

function [] = display_heatmap(distribution)

    reset(gca)    
    
    switch(distribution.settings.display)
        case {'polar', 'polarX'} 
            x_size = size(distribution.map,1)-1;
            y_size = size(distribution.map,2)-1;
            [xs,ys] = meshgrid(0:x_size,0:y_size);
            XS = cos((2*pi)/x_size .* xs) .*ys;
            YS = sin((2*pi)/x_size .* xs) .*ys;
            h = surf(XS, YS, distribution.map', 'EdgeColor','none','LineStyle','none');
        case 'polarY'
            x_size = size(distribution.map,1)-1;
            y_size = size(distribution.map,2)-1;
            [xs,ys] = meshgrid(0:x_size,0:y_size);
            XS = cos((2*pi)/y_size .* ys) .* (xs);
            YS = sin((2*pi)/y_size .* ys) .* (xs);
            h = surf(XS, YS, distribution.map', 'EdgeColor','none','LineStyle','none');            
        otherwise
            plotMap = distribution.map';
            %plotMap(end+1,:) = zeros(size(plotMap,2),1);
            %plotMap(:,end+1) = zeros(1,size(plotMap,1));
            plotMap = plotMap./max(plotMap(isfinite(plotMap(:)))) .* 256;
            %h = surf(distribution.map', 'EdgeColor','none','LineStyle','none');
            im_h = image(uint8(round(plotMap)));
            set(gca,'YDir','normal')
            %h = surf(plotMap, 'EdgeColor','none','LineStyle','none');
    end
    view(0,90);
    xlabel(distribution.labels.x_axis_label);
    ylabel(distribution.labels.y_axis_label);
    
    %x_scale = distribution.cutoffsX(1):(distribution.cutoffsX(end)-distribution.cutoffsX(1))/5:distribution.cutoffsX(end);
    %y_scale = distribution.cutoffsY(1):(distribution.cutoffsY(end)-distribution.cutoffsY(1))/5:distribution.cutoffsY(end);
    x_scale = linspace(distribution.cutoffsX(1),distribution.cutoffsX(end),5);
    y_scale = linspace(distribution.cutoffsY(1),distribution.cutoffsY(end),5);
    inds = isfinite(distribution.map);
    z_scale = min(distribution.map(inds)):(max(distribution.map(inds))-min(distribution.map(inds)))/5:max(distribution.map(inds));
    set(gca,'XTick', linspace(1,size(plotMap,2),5));
    set(gca,'YTick', linspace(1,size(plotMap,1),5));
    set(gca,'XTickLabel', roundsd(x_scale,2, 'round'));
    set(gca,'YTickLabel', roundsd(y_scale,2, 'round'));
    set(gca,'XGrid','off');
    set(gca,'YGrid','off');
    %set(gca,'Color', [0 0 143/256]);
    set(gcf,'Renderer','Zbuffer')
    %set(h, 'FaceLighting', 'flat');
        
    h = colorbar();
    
    map = colormap (distribution.settings.color_map);
    
    newMap(:,1) = interp1((1:size(map,1))-1, map(:,1), (0:255)./256.*size(map,1));
    newMap(:,2) = interp1((1:size(map,1))-1, map(:,2), (0:255)./256.*size(map,1));
    newMap(:,3) = interp1((1:size(map,1))-1, map(:,3), (0:255)./256.*size(map,1));
    
    colormap(newMap);
    axis square 
    minz = 0;%(z_scale(1));
    maxz = (z_scale(end));
    r = (maxz - minz)/10;
    r = 10^(floor(log10(r)));
    z_scale = minz:10^(floor(log10(r))):maxz;
    
    if(length(z_scale) > 7)
        z_scale = z_scale(ceil(linspace(1,length(z_scale),7)));
    end
    
    set(h, 'YTick', (z_scale./maxz).*256);

    switch(distribution.settings.cell_scaling)
        case 'log'
            z_labels = cell(size(z_scale));
            for loop = 1:numel(z_scale)
                z_labels{loop} = sprintf('$$e^{%0.1f}$$', z_scale(loop));
            end
        case 'log10'
            z_labels = cell(size(z_scale));
            for loop = 1:numel(z_scale)
                z_labels{loop} = sprintf('$$10^{%0.1f}$$', z_scale(loop));
            end  
        otherwise
            z_labels = z_scale;
    end
    if iscell(z_labels)
        z_labels{1} = ['$$<=$$ ' z_labels{1}];
    end
    set(h, 'YTickLabel', z_labels, 'TickLabelInterpreter','latex');
    axis tight
    
    holdAxes = gca;
    set(h, 'FontSize', 10);
    shifts = struct();
    shifts.yAxisShift = [0 0];
    %setTicksTex(h, shifts);
    set(gcf, 'CurrentAxes', holdAxes);
            
end

function [ distribution , temporaries ] = processInputs(varargin)
    args = varargin{1};
    default.settings.cell_scaling = 'linear';
    default.settings.x_scaling = 'linear';
    default.settings.y_scaling = 'linear';
    default.settings.chart_type = 'heat';
    default.settings.display = 'box';
    default.settings.color_map = 'jet';
    default.labels.x_axis_label = '';
    default.labels.y_axis_label = '';
    default.probability = 'joint';

    default.map = [];
    default.cutoffsX = [];
    default.cutoffsY = [];
    
    temporaries.command = 'normal';

    if(nargin==0)
        error('no inputs');
    end
    
    distribution = struct();
    input = struct();    
    
    if(isempty(args))
        distribution = default;
        return;
    end
    
    if(isstruct(args{1}))
        input  = args{1};
        input.settings.chart_type = 'heat';
        temporaries.command = 'calculated';
    end
    

    if(length(args)==1)
        if(isstruct(args{1}))            
%            display_heatmap(args{1});
            
%            return

        elseif ismatrix(args{1})
            input = heatmap('ncellx', 1:size(args{1}), 'ncelly', 1:size(args{1}));
            input.map = args{1};
            input.settings.chart_type = 'heat';
            temporaries.command = 'calculated';            
        else            
            error('Single inputs must be a distribution structure from a previous call to heatmap.');
        end
    else
        
        startIndex = 3;
        
        if(~isstruct(args{1}))
            if(ischar(args{1}))
                startIndex = 1;
                temporaries.command = 'creating';

            else
                temporaries.x_data = args{1};
                temporaries.y_data = args{2};

                if(size(temporaries.x_data,2)==1)
                    temporaries.x_data = temporaries.x_data';
                end
                if(size(temporaries.y_data,2)==1)
                    temporaries.y_data = temporaries.y_data';
                end  


                checkVectors(temporaries.x_data, temporaries.y_data);

                temporaries.minx=min(temporaries.x_data);
                temporaries.maxx=max(temporaries.x_data);

                temporaries.miny=min(temporaries.y_data);
                temporaries.maxy=max(temporaries.y_data);        

                temporaries.ncellx=ceil(length(temporaries.x_data)^(1/3));
                temporaries.ncelly=ceil(length(temporaries.y_data)^(1/3));                
            end
        else
            startIndex = 2;
        end

        for index = startIndex:2:length(args)
            key = args{index};
            value = args{index+1};
            switch(key)
                case 'cell_scaling'
                    input.settings.cell_scaling = value;
                case 'x_scaling'
                    input.settings.x_scaling = value;
                case 'y_scaling'
                    input.settings.y_scaling = value;
                case 'type'
                    input.settings.chart_type = value;
                case 'display'
                    input.settings.display = value;
                case 'XLabel'
                    input.labels.x_axis_label = value;
                case 'YLabel'
                    input.labels.y_axis_label = value;
                case 'mode'                   
                    if(strcmp(temporaries.command,'merge'))
                        if(input.settings.chart_type~=value)
                            error('Cannot change chart type when merging');
                        end
                    end
                    
                    input.labels.chart_type = value;
                case 'ncellx'
                    temporaries.ncellx = value;
                    
                    if(isvector(value) && length(value)>1)
                        temporaries.minx = value(1);
                        temporaries.maxx = value(end);
                        temporaries.ncellx = length(value);
                        
                        lowerx = temporaries.minx;
                        upperx = temporaries.maxx;
                        ncellx = temporaries.ncellx;
                        distribution.cutoffsX = lowerx:(upperx-lowerx)/(ncellx):upperx;                        
                    end
                case 'cutoffsX'
                        temporaries.minx = value(1);
                        temporaries.maxx = value(end);
                        temporaries.ncellx = length(value)-1;
                case 'cutoffsY'
                        temporaries.miny = value(1);
                        temporaries.maxy = value(end);
                        temporaries.ncelly = length(value)-1;                    
                case 'ncelly'
                    temporaries.ncelly = value;
                    
                    if(isvector(value)  && length(value)>1)
                        temporaries.miny = value(1);
                        temporaries.maxy = value(end);
                        temporaries.ncelly = length(value);
                        
                        lowery = temporaries.miny;
                        uppery = temporaries.maxy;
                        ncelly = temporaries.ncelly;                        
                        distribution.cutoffsY = lowery:(uppery-lowery)/(ncelly):uppery;
                    end                    
                case 'probability'
                    input.probability = value;
                case 'distribution'
                    distribution = value;
                case 'command'
                    temporaries.command = value;
                case 'merge'
                    temporaries.command = 'merge';
                    distribution = value;
                    if(isfield(distribution, 'cutoffsX') && ~isempty(distribution.cutoffsX) && ...
                            isfield(distribution, 'cutoffsY') && ~isempty(distribution.cutoffsY))
                        temporaries.minx = distribution.cutoffsX(1);
                        temporaries.miny = distribution.cutoffsY(1);
                        temporaries.maxx = distribution.cutoffsX(end);
                        temporaries.maxy = distribution.cutoffsY(end);
                        temporaries.ncellx = length(distribution.cutoffsX)-1;
                        temporaries.ncelly = length(distribution.cutoffsX)-1;
                    end
                case {'color_map', 'colormap', 'colour_map'}
                    distribution.settings.color_map = value;
                otherwise
                    error(['invalid property: ' key ]);
            end
        end
    end
 
    distribution = mergeStructs(default, distribution, input);
end

function [] = dump()
   switch(distribution.settings.chart_type)
        case 'heat'            
            [ distribution.map , distribution.cutoffsX, distribution.cutoffsY ] = histogram2(distribution, temporaries);
                    
            if(~suppressDrawing)
                temp = distribution;
                
                temp.map(~isfinite(temp.map)) = min(temp.map(isfinite(temp.map)));
                display_heatmap(distribution);
            end
        case 'hist'
            [ distribution , descriptor, cutoffsX, cutoffsY ] = histogram2(temporaries.x_data, temporaries.y_data, ncellx, ncellx, probability, cell_scaling);            

            
            temp = distribution;
            temp(~isfinite(temp)) = 0;
            subplot(2,2,1);            
            %hist(y_data, ncellx)
            %hold on
            plot(cutoffsY(1:end-1), sum(temp), 'b-');
            %hold off
            subplot(2,2,4);
            %hist(x_data, ncellx);
            %hold on           
            plot(cutoffsX(1:end-1), sum(temp,2), '-b');
            %hold off
            
            
            subplot(2,2,2)
            display_heatmap(distribution, descriptor, x_axis_label, y_axis_label, cell_scaling);
            h = colorbar();
    
            switch(cell_scaling)
                case 'log'
                    set(h, 'YScale', 'log')
            end
            
        case 'maximum_y'
            [ distribution , cutoffsX, cutoffsY ] = histogram2(distribution, temporaries);
            
            [~, inds] = max(distribution);
            
            distribution = cutoffsY(inds);
            
            plot(cutoffsY(inds));
            
            xlabel(x_axis_label);
            ylabel(y_axis_label);
            set(gca,'XTick', 1:length(cutoffsX)/5:length(cutoffsX));
            set(gca,'XTickLabel', cutoffsX(round(1:length(cutoffsX)/5:end)));            
        otherwise
            [ distribution , descriptor, cutoffsX, cutoffsY ] = binOnX(distribution, temporaries);
            sums = feval_to_vector('sum', distribution);
            distribution = feval_over_vector('rdivide', distribution , sums);
            distribution = feval_to_vector(chart_type, distribution);
            plot(distribution);
            xlabel(x_axis_label);
            ylabel(y_axis_label);
            set(gca,'XTick', 0:length(distribution)/5:length(distribution));
            set(gca,'XTickLabel', roundsd(descriptor(1,:),3, 'round'));
   end
end

function [ ret ] = roundsd(varargin)
%
% Round to a specified number of significant digits
%
% output = roundd(data, digits)
% output = roundd(data, digits, direction)
%
% data - values to round
% digits - number of digits to round to
% direction - 'round' (default) round to nearest (0.5 rounds up)
%             'floor' round up
%             'ceil' round down


narginchk(2,3)

data = varargin{1};
if(nargin>=2)
    digits = varargin{2};
else
    digits = 0;
end

if(nargin>=3)
    direction = varargin{3};
else
    direction = 'round';
end

if ~isnumeric(digits) || digits<0 || mod(digits, 1) ~= 0
    error('digits must be a scalar positive integer');
end

og = 10.^(floor(log10(abs(data)) - digits + 1));

ret = feval(direction, data./og).*og;
ret(data==0) = 0;

end