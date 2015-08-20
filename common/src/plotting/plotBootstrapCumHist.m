function [ handle, distribution, CI, bins ] = plotBootstrapCumHist(data, boxes, minimum, maximum, func)
    if(nargin<5)
        func = [];
    end
    if nargin<4
        if(isa(func, 'function_handle'))
            maximum = max(func(data(:)));
        elseif(all(islogical(func)))
            maximum = max(data(func));            
        else
            maximum = max(data(:));            
        end
    end
    if nargin<3
        if(isa(func, 'function_handle'))
            minimum = min(func(data(:)));
        elseif(all(islogical(func)))
            minimum = min(data(func));
        else
            minimum = min(data(:));
        end
    elseif nargin==3 && numel(minimum)>1
        func = minimum;
        if(isa(func, 'function_handle'))
            minimum = min(func(data(:)));
            maximum = max(func(data(:)));
        elseif(all(islogical(func)))
            minimum = min(data(func));
            maximum = max(data(func));            
        else
            minimum = min(data(:));
            maximum = max(data(:));            
        end        
    end



    noSamples = size(data,2);
    noBootstraps = size(data,1);

    % get appropriate bin centers
    if(isscalar(boxes))
        noBoxes = boxes;
        if(isa(func, 'function_handle'))
            [~,bins] = cumHist(func(data(:)), noBoxes, minimum, maximum);
        elseif(all(islogical(func)))
            [~,bins] = cumHist(data(func), noBoxes, minimum, maximum);
        else
            [~, bins ] = cumHist(data(:), noBoxes, minimum, maximum);
        end
    else
        bins = boxes;
        noBoxes = length(bins);
    end

    for loop = 1:noBootstraps
        if(isa(func, 'function_handle'))
            h(loop,:) = cumHist(func(data(loop,:)), bins);
        elseif(all(islogical(func)))
            h(loop,:) = cumHist(data(loop, func(loop,:))', bins);
        else
            h(loop,:) = cumHist(data(loop, :)', bins);
        end
    end
    h = [zeros(noBootstraps, 1) h];
    bins = [minimum bins];

    sorted_h = sort(h,1);
    distribution = median(sorted_h,1);
    CI = [ sorted_h(ceil(noBootstraps.*0.025),:) ; sorted_h(ceil(noBootstraps.*0.975),:)];

    isheld = ishold(gca);

    handle = plot(bins, distribution, 'k-', 'LineWidth', 1);
    px=[bins,fliplr(bins)]; % make closed patch
    py=[CI(1,:), fliplr(CI(2,:))];
    ph = patch(px,py,1,'FaceColor','r','EdgeColor','r');

    alpha(ph, 0.5);
    hold on;
    set(handle, 'Color', [0 0 0 ]);
    set(handle, 'LineWidth', 1);

    if isheld
        hold on;
    else
        hold off;
    end
    colormap jet;
end