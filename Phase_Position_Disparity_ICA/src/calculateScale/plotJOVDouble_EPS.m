% Plotting functions, based on a figure maximised in a 1920 x 1080 display
plot_figure_13 = false;
plot_figure_14 = false;
plot_figure_15 = false;
plot_figure_16 = true;

%plotDirectory = 'F:\data\Dropbox\ICAPaper\bootstrap_plots\all\';
plotDirectory = 'C:\Users\Dave\Documents\test\';
diary('E:\Users\Dave\Google Drive\binocular\paper1\figures\scaled\highRes\dairy.txt')
diary on
histPlotType = 'lhist';
jpre = 'JOV-04026-2013R3-';
plot_size = [ 1125 1125 ];
plot_resolution = 300;
details.title_font_size = 12;
details.label_font_size = 12;
details.axis_font_size = 10;
details.thin_line_size = 0.5;
details.line_size = 1;
details.thick_line_size = 2;
details.names = names;
details.scaleNames = scaleNames;
details.scalesNum = scalesNum;
details.scalesTex = scalesTex;
details.colours = colours;
histPlotType = 'lhist';

runName = 'all';

% reset the plots
figure(1);

clf
hold off;

noBins = 100;
noBootstraps = 200;
percentile = 0.9875;
%percentile = 0.975;
% luminance ratio



%% Figure 13 The effect of image scale of the proportion of monocular
% features. The proportion, fraction of 1, of components showing a strong
% monocular tuning when calculated on images at varying scales. Images at the
% coarsest scale, 10’ per pixel, show the smallest proportion of monocular
% tuned components, images at the finest scale show a high proportion of
% monocular tuned components. Subplot A shows the bootstrapped histograms of
% the intensity ratios at each scale. The median of the bootstrapped
% distribution is shown as a thick line, the 95% CI are shown as thin-lines.
% Fine scales show strong peaks at ratios close to zero (monocular) and
% coarse scales show a bias towards a ratio of 1 (binocular). Subplot B shows
% the proportion of monocular components at each scale (in arcmin per pixel),
% the blue bars show the median proportion of monocular components, the 95% CI
% are shown by the black error bars.
if plot_figure_13
    clf
    reset(gcf)
    subplot(1,2,1);
    
    initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);
    
    %%
    % Plot intensity ratios
    
    plot_handles=[];
    ci_handles = [];
    for loop = 1:length(names)
        intensityRatioDispCIs_ArcMinutes{loop} = intensityRatioDispCIs_ArcMinutes{loop}./sum(intensityRatioDistributions_ArcMinutes{loop}(:));
        intensityRatioDistributions_ArcMinutes{loop} = intensityRatioDistributions_ArcMinutes{loop}./sum(intensityRatioDistributions_ArcMinutes{loop}(:));
        plot_handles(loop) = plot(intensityRatioBins_ArcMinutes{loop}(1:end-1), intensityRatioDistributions_ArcMinutes{loop}(1:end-1), 'Color', details.colours(loop,:),'LineWidth',details.thick_line_size, 'DisplayName', scalesTex{loop});
        hold on
        ci_handles(loop,:) = plot(intensityRatioBins_ArcMinutes{loop}(1:end-1), intensityRatioDispCIs_ArcMinutes{loop}(:,1:end-1), 'Color', details.colours(loop,:),'LineWidth',details.line_size);
    end
    stepSize = intensityRatioBins_ArcMinutes{1}(2) - intensityRatioBins_ArcMinutes{1}(1);
    [maxVal, ind] = max(intensityRatioDispCIs_ArcMinutes{1}(2,:));
    bootloop = 1;
    for loop = 1:length(intensityRatioDispCIs_ArcMinutes)
        [tempMaxVal, tempInd] = max(intensityRatioDispCIs_ArcMinutes{loop}(2,:));
        if tempMaxVal > maxVal
            ind = tempInd;
            maxVal = tempMaxVal;
            bootloop = loop;
        end
    end
    [maxVal, ind] = max(intensityRatioDispCIs_ArcMinutes{1}(2,:));
    pos = intensityRatioBins_ArcMinutes{bootloop}(ind);
    maxVal = maxVal+0.01;
    
    plot([stepSize stepSize]+pos, [0 maxVal], 'k:', 'LineWidth', details.line_size);
    plot([-stepSize -stepSize]+pos, [0 maxVal], 'k:', 'LineWidth', details.line_size);
    plot([0 0]+pos, [0 maxVal], 'k--', 'LineWidth', details.line_size);
    
    hold on
    axis tight
    %title('Distributions of left/right intensity ratio.', 'FontName', 'Helvetica', 'FontSize', details.title_font_size);
    %set(gca,'XTick',-5:5);
    xlabel('Binocular intensity ratio', 'FontName', 'Helvetica', 'FontSize', details.label_font_size);
    ylabel('Proportion of components', 'FontName', 'Helvetica', 'FontSize', details.label_font_size);
    l = legend(plot_handles, 'Location', 'Best');
    set(l, 'FontName', 'Helvetica');
    set(l, 'FontSize', details.axis_font_size);
    %set(l,'Interpreter','latex');
    set(l,'Box','off');
    position = get(l,'Position');
    position(1) = 0.25;
    position(2) = 0.55;
    %position(4) = position(4).*1.33333;
    position(3) = 0.1;
    position(4) = 0.1;
    set(l,'Position',position);
    %v = get(l,'title');
    %set(v,'string','Scale-arcmin per pixel','FontName', 'Helvetica', 'FontSize', details.axis_font_size,'Interpreter','latex');
    set(gca, 'FontName','Helvetica','FontSize',details.axis_font_size);
%     handles = setTicksTex(gca);
%     set(handles.ylabel, 'VerticalAlignment', 'middle');
%     shiftObject(handles.ylabel, -0.05, -0.1);
%     shiftObject(handles.title, -0.2, 0);
%     set(gca, 'LineWidth',details.line_size);
    
    text(-0.25,-0.1,'A', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    subplot(1,2,2);
    
    sortedProportionMonocular = sort(proportionMonocular_ArcMinutes',1);
    mProportionMonocular = median(sortedProportionMonocular,1);
    ciProportionMonocular = [ sortedProportionMonocular(ceil(noBootstraps.*0.025),:) ; ...
        sortedProportionMonocular(ceil(noBootstraps.*0.975),:)];
    marginProportionMonocular = [mProportionMonocular - ciProportionMonocular(1,:) ;...
        ciProportionMonocular(2,:) - mProportionMonocular ];
    
    handle = plotBarsWithErrors(1:length(scaleNames),mProportionMonocular, marginProportionMonocular);
    set(handle(1), 'LineWidth', details.thin_line_size);
    set(handle(2), 'LineWidth', details.line_size);
    
    %title({'\centerline{Proportion of monocular components}','\centerline{across scales}'}, 'FontName','Helvetica', 'FontSize', details.title_font_size);
    xlabel('Image scale (arcmin per pixel)', 'FontName','Helvetica', 'FontSize', details.label_font_size);
    ylabel({'Proportion of monocular','components'}, 'FontName','Helvetica', 'FontSize', details.label_font_size);
    set(gca,'FontSize', details.axis_font_size);
    set(gca,'xticklabel', 10:-1:1);
    set(gca, 'LineWidth', 0.000001);
    axis normal
%     handles = setTicksTex();
%     shiftObject(handles.title, 0, -0.04);
%     shiftObject(handles.xlabel, -0.1, 0);
%     shiftObject(handles.ylabel, 0, -0.1);
    
    text(-0.25,-0.1,'B', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');            
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c013'], plot_size.*[2 1], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',plot_resolution), [ plotDirectory, jpre ,'4c013', '.png']);
    
    
end

%% Figure 14 Results of ICA analysis at varying scales. The scales are
% measured in arc-minutes per pixel. All plots show bootstrapped histograms
% with the median shown a thick line and the 95% CI shown as thin lines. The
% edges of two of the histogram bins are shown as dashed and dotted lines.
% Subplot A shows the distribution of frequencies in cycles per pixel for
% each of the 10 scales.  The Nyquist limit is shown as a dot-dash line. Most
% of the course scaled frequencies show highly similar distributions with
% some bias towards higher frequencies at the finest scales. Subplot B shows
% the same distributions as cycles per arc-minute. The red lines show the
% bootstrapped distribution of the combined frequencies. Subplot C shows the
% natural log ratio of left/right intensity across scales. At coarse scales
% the distributions consist predominantly of log ratios of 0 (i.e. equality).
% Finer scales show a bias away from equality and towards larger left/right
% intensity ratios; this corresponds to a shift towards monocular responses.
if plot_figure_14
    clf
    reset(gcf);
    initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);
    
    subplot(1,2,1);
    
    details.title = 'Frequency distributions';
    details.xlabel = 'Wavelength, cycles per pixel';
    details.ylabel = 'Proportion of components';
    [ ~ , l] = subPlotJOVDouble( freqBins_Pixels, freqDistributions_Pixels, freqCIs_Pixels, details);
    plot([0.5 0.5], [0 0.12], 'k-.', 'LineWidth', details.line_size);
    
    %position = get(l,'Position');
    %position(2) = position(2) - 0.2;
    %set(l,'Position', position);
    
    %shiftObject(handles.ylabel, -0.05, -0.1);
    %shiftObject(handles.xlabel, -0.1, 0);
    %shiftObject(handles.title, -0.1, 0);

    text(-0.25,1,'A', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    subplot(1,2,2);
    
    details.title = 'Frequency distributions';
    details.xlabel = 'Wavelength, cycles per arcmin';
    details.ylabel = 'Proportion of components';
    [ ~ , l] = subPlotJOVDouble( freqBins_ArcMinutes, freqDistributions_ArcMinutes, freqCIs_ArcMinutes, details);
    
%     shiftObject(handles.title , -0.1,0);
%     shiftObject(handles.xlabel, -0.1,0);
%     shiftObject(handles.ylabel, -0.05, -0.1);

    text(-0.25,1,'B', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c014'], plot_size.*[2 1], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',plot_resolution), [ plotDirectory, jpre ,'4c014', '.png']);
    
end

%%
% Figure 15 Comparison of disparity distributions across scales. Scales
% between 3 and 10 arc-minutes per pixel are shown as bootstrapped distributions
% of varying shades. As before the thick lines denote the median of the
% distribution, thin-lines the 95% CI and the dotted and dashed lines the
% edges of histogram bins. Subplots A&B show the distribution of absolute
% position disparities across the scales measures in pixels(A) and arc-minutes(B)
% Fine scales show a strong bias towards small disparities while coarse scales
% show a wider coverage. Subplots C&D show the horizontal position disparities
% in pixels(C) and arc-minutes(D), and subplots E&F show vertical position
% disparities in pixels(E) and arc-minutes(F). As with the absolute displacements
% (A&B) fine scales shows a bias towards small disparities while coarse scales
% show a wider distribution, however in the horizontal case it is weaker. Unlike
% the frequency distributions, which are strongly tied to the size of the patches,
% the position disparities vary across scales.

if plot_figure_15
    clf
    initialiseJOVPlot(gca, plot_size.*[2 3], plot_resolution);
    
    subplot(3,2,1);
    
    details.title = 'Distribution of position disparities';
    details.ylabel = 'Proportion of components';
    details.xlabel = 'Position disparity in pixels';
    
    [ ~ , l] = subPlotJOVDouble( dispBins_Pixels, dispDistributions_Pixels, dispCIs_Pixels, details);
    
%     shiftObject(handles.title , -0.1,-0.05);
%     shiftObject(handles.xlabel, -0.1,0.15);
%     shiftObject(handles.ylabel, -0.05, -0.15);
  
    text(-0.25,1.1,'A', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');    
    subplot(3,2,2)
    text(0,0,'B');
    
    details.title = 'Distribution of position disparities';
    details.ylabel = 'Proportion of components';
    details.xlabel = 'Position disparity in arcmin';
    
    [ ~ , l] = subPlotJOVDouble( dispBins_ArcMinutes, dispDistributions_ArcMinutes, dispCIs_ArcMinutes, details);
    
%     shiftObject(handles.title , -0.1,-0.05);
%     shiftObject(handles.xlabel, -0.1,0.15);
%     shiftObject(handles.ylabel, -0.05, -0.15);

    text(-0.2,1.1,'B', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');        
    subplot(3,2,3)
    
    details.title = {'\centerline{Distributions of horizontal}','\centerline{position disparities}'};
    details.ylabel = 'Proportion of components';
    details.xlabel = 'Position disparity in pixels';
    
    [ ~ , l] = subPlotJOVDouble( xdispBins_Pixels, xdispDistributions_Pixels, xdispCIs_Pixels, details);
    
%     shiftObject(handles.title , 0.1,-0.05);
%     shiftObject(handles.xlabel, -0.1,0.15);
%     shiftObject(handles.ylabel, -0.05, -0.15);
    
    text(-0.25,1.1,'C', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');        
    subplot(3,2,4)
    
    details.title = {'\centerline{Distributions of horizontal}','\centerline{position disparities}'};
    details.ylabel = 'Proportion of components';
    details.xlabel = 'Position disparity in arcmin';
    
    [ ~ , l] = subPlotJOVDouble( xdispBins_ArcMinutes, xdispDistributions_ArcMinutes, xdispCIs_ArcMinutes, details);
    
%     shiftObject(handles.title , 0.1,-0.05);
%     shiftObject(handles.xlabel, -0.1,0.15);
%     shiftObject(handles.ylabel, -0.05, -0.15);
    
    text(-0.25,1.1,'D', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');        
    subplot(3,2,5)
    
    details.title = {'\centerline{Distributions of vertical}','\centerline{position disparities}'};
    details.ylabel = 'Proportion of components';
    details.xlabel = 'Position disparity in pixels';
    
    [ ~ , l] = subPlotJOVDouble( ydispBins_Pixels, ydispDistributions_Pixels, ydispCIs_Pixels, details);
%     
%     shiftObject(handles.title , 0.1,-0.05);
%     shiftObject(handles.xlabel, -0.1,0.15);
%     shiftObject(handles.ylabel, -0.05, -0.15);
    
    text(-0.25,1.1,'E', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');        
    subplot(3,2,6)
    
    details.title = {'\centerline{Distributions of vertical}','\centerline{position disparities}'};
    details.ylabel = 'Proportion of components';
    details.xlabel = 'Position disparity in arcmin';
    
    [ ~ , l] = subPlotJOVDouble( ydispBins_ArcMinutes, ydispDistributions_ArcMinutes, ydispCIs_ArcMinutes, details);
    
%     shiftObject(handles.title , 0.1,-0.05);
%     shiftObject(handles.xlabel, -0.1,0.15);
%     shiftObject(handles.ylabel, -0.05, -0.15);

    text(-0.25,1.1,'F', 'FontName','Helvetica','FontSize',details.title_font_size,'Units','normalized', 'Interpreter','Latex');    
    
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c015'], plot_size.*[2 3], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',plot_resolution), [ plotDirectory, jpre ,'4c015', '.png']);
    
end

%% Figure 16 Bootstrapped distributions of phase differences across scales.
% The phase distributions follow the same bimodal pattern across the selected
% scales.

if plot_figure_16
    clf
    initialiseJOVPlot(gca, plot_size.*[1 1], plot_resolution);
    
    
    details.title = 'Phase Differences between pairs (ICA)';
    details.xlabel = 'Phase difference (Radians)';
    details.ylabel = 'Proportion of components';
    [ ~ , l] = subPlotJOVDouble( phaseDiffBins_Pixels, phaseDiffDistributions_Pixels, phaseDiffCIs_Pixels, details);
    
    position = get(l,'Position');
    position(2) = position(2) - 0.2;
    set(l,'Position', position);
    
%     shiftObject(handles.ylabel, -0.05, -0.1);
%     shiftObject(handles.xlabel, -0.1, 0);
%     shiftObject(handles.title, -0.1, 0);
%     shiftObject(handles.yTicks, -0.01,0);
    
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c016'], plot_size.*[1 1], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',plot_resolution), [ plotDirectory, jpre ,'4c016', '.png']);
    
end
