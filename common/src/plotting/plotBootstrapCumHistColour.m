function [ handle, distribution, CI, bins ] = plotBootstrapCumHistColour(data, boxes, colour)

        func = [];

            maximum = max(data(:));            

            minimum = min(data(:));

            

    noSamples = size(data,2);
    noBootstraps = size(data,1);

    % get appropriate bin centers
    if(isscalar(boxes))
        noBoxes = boxes;
            [~, bins ] = cumHist(data(:), noBoxes, minimum, maximum);
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
    ph = patch(px,py,1,'FaceColor',colour,'EdgeColor',colour);

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