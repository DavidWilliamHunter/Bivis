function [ handles , l ] = subPlotJOVDouble( bins, distributions, CIS, details)
%SUBPLOTJOVDOUBLE Summary of this function goes here
%   Detailed explanation goes here
for loop = 1:length(details.names)
    CIS{loop} = CIS{loop}./sum(distributions{loop}(:));
    distributions{loop} = distributions{loop}./sum(distributions{loop}(:));
    h(loop) = plot(bins{loop}, distributions{loop}, 'Color', ...
        details.colours(loop,:), 'LineWidth', details.thick_line_size, ...
        'DisplayName', details.scalesTex{loop});
    hold on
    plot(bins{loop}, CIS{loop}, 'Color', details.colours(loop,:),'LineWidth',details.line_size);
end
stepSize = bins{1}(2) - bins{1}(1);
[maxVal, ind] = max(CIS{1}(2,:));
bootloop = 1;
for loop = 1:length(CIS)
    [tempMaxVal, tempInd] = max(CIS{loop}(2,:));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
    
%[maxVal, ind] = max(freqDistributions{:}(1,:));
pos = bins{bootloop}(ind);
maxVal = maxVal+0.01;
plot([stepSize stepSize]+pos, [0 maxVal], 'k:', 'LineWidth', details.line_size);
plot([-stepSize -stepSize]+pos, [0 maxVal], 'k:', 'LineWidth', details.line_size);
plot([0 0]+pos, [0 maxVal], 'k--', 'LineWidth', details.line_size);

axis tight
%title(details.title,'FontName', 'Helvetica', 'FontSize', details.title_font_size);
%set(gca,'XTick',0:pi/2:pi)
%set(gca,'XTickLabel',{'0','pi/2','pi'})
xlabel(details.xlabel, 'FontName', 'Helvetica', 'FontSize', details.label_font_size);
ylabel(details.ylabel, 'FontName', 'Helvetica', 'FontSize', details.label_font_size);

l = legend(h, 'Location', 'Best');
%position = get(l,'Position');
%position(2) = position(2) - 0.05;
%position(4) = position(4).*2;
%set(l,'Position', position);
set(l, 'Box','off');
%set(l,'Interpreter','latex'); 
set(l,'FontSize',8);%details.axis_font_size);
%v = get(l,'title');
%set(v,'string','Scale-arcmin per pixel','Interpreter','latex');

set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', details.axis_font_size);
set(gca, 'LineWidth', details.line_size);

% handles = setTicksTex(gca);
handles = [];
end

