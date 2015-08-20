% Plotting functions, based on a figure maximised in a 1920 x 1080 display
plot_figure_2 = true;
plot_figure_3 = true;
plot_figure_4 = true;
plot_figure_5 = true;
plot_figure_6 = true;
plot_figure_7 = true;
plot_figure_8 = true;
plot_figure_9 = true;
plot_figure_10 = true;
plot_figure_11 = true;
plot_figure_12_old = true;
plot_figure_12 = true;
plot_figure_13_old = true;
plot_figure_13 = false;
do_KS_test_combined_disparity = true;
do_circ_stats = true;
do_bandwidth_stats = true;

%plotDirectory = 'F:\data\Dropbox\ICAPaper\bootstrap_plots\all\';
%plotDirectory = 'E:\Users\Dave\Google Drive\binocular\paper1\figures\unified\highRes\';

workingDirectory = '../../working/';
experimentDirectory = 'unified/';
experimentDirectory =  [ experimentDirectory 'random/'];
plotDirectory = '../../plot/';
diary('results.txt')
diary on
histPlotType = 'lhist';
jpre = 'JOV-04026-2013R3-';
plot_size = [ 1125 1125 ];
plot_resolution = 300;
title_font_size = 12;
label_font_size = 12;
axis_font_size = 10;
thin_line_size = 0.5;
line_size = 1;
thick_line_size = 2;
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
nonZero = rightSICA ~= 0;
Lratio = leftSICA ./ rightSICA;
Lratio(:,:,2) = rightSICA ./ leftSICA;
Lratio = min(Lratio, [], 3);

% remove components centred outside the image patch
inds = (leftXCICA>0 & leftXCICA<patchSize & leftYCICA>0 & leftYCICA<patchSize ...
    & rightXCICA>0 & rightXCICA<patchSize & rightYCICA>0 & rightYCICA<patchSize) ...
    & Lratio > 0.5;


%%
% Figure 2 
% Sub plot A. Histogram plot of intensity ratio
% Sub plot B. Cumumulative distribution of intensity ratios.
if plot_figure_2
clf
subplot(2,2,1);
    
initialiseJOVPlot(gca, plot_size.*[2 2], plot_resolution);

Lratio = leftSICA ./ rightSICA;
Lratio(:,:,2) = rightSICA ./ leftSICA;
Lratio = min(Lratio, [], 3);

handle = plotBootstrappedDistribution(bootstrap(Lratio(:), noBootstraps), noBins, 'plot', histPlotType);
%title('Histogram plot of intensity ratio', 'FontName', 'Helvetica', 'FontSize', title_font_size,'Interpreter','Latex', 'HorizontalAlignment','center');
title('Binocular Patches', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Binocular Intensity Ratio', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca, 'FontSize', axis_font_size);
set(gca, 'LineWidth', line_size);
set(handle, 'LineWidth', line_size);
%handles = setTicksTex(gca);
%set(handles.ylabel, 'VerticalAlignment', 'middle');
%shiftObject(handles.ylabel, -0.05, -0.1);
%shiftObject(handles.title, -0.2, 0);

text(-0.15,1.05,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
subplot(2,2,2);
initialiseJOVPlot(gca, plot_size.*[2 2], plot_resolution);
% Plot cumulative intensity ratios

[ handle, distribution, CI, bins ] = plotBootstrapCumHist(bootstrap(Lratio(:), noBootstraps), noBins);
hold on
upperLuminanceCutOff = roundsd(interp1(bins, distribution, 0.8),2);
lowerLuminanceCutOff = roundsd(interp1(bins, distribution, 0.2),2);

val3 = roundsd(interp1(bins, distribution, 0.5),2);
plot([0.5 0.5] , [0 val3],'k-', 'LineWidth', line_size);
plot([0 0.5] , [val3 val3],'k-', 'LineWidth', line_size);

% plot CIs
ci3l = interp1(bins,CI(1,:),0.5) - val3;
ci3u = interp1(bins,CI(2,:),0.5) - val3;
errorbar(0.5, val3, -ci3l, ci3u, 'k.', 'LineWidth', line_size);
errorbar(0, val3, -ci3l, ci3u, 'r.', 'LineWidth', thick_line_size);

set(gca,'XTick', union(0:1:7, [0.25, 0.5 , 1]));
    tickx = get(gca,'XTickLabel');
    if ischar(tickx);
        temp = tickx;
        tickx = cell(1,size(temp,1));
        for j=1:size(temp,1);
            tickx{j} = strtrim( temp(j,:) );
        end;
    end;
    tickx{2} = '0.25';
    tickx{3} = '0.5';
    set(gca,'XTickLabel',tickx);
set(gca,'YTick', union(0:0.2:1, [val3]));
%set(gca, 'LineWidth',3);
%set(gca, 'FontSize',8);
%title('Cumulative distribution of intensity ratios', 'FontName', 'Helvetica', 'FontSize', title_font_size,'Interpreter','Latex');
xlabel('Binocular Intensity ratio', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Cumulative proportion', 'FontName', 'Helvetica', 'FontSize', label_font_size);

set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
% handles = setTicksTex(gca);
% shiftObject(handles.ylabel, -0.05, -0.1);
% shiftObject(handles.title, -0.2, 0);
% set(handles.ylabel, 'VerticalAlignment', 'middle');

text(-0.15,1.05,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
subplot(2,2,3);
initialiseJOVPlot(gca, plot_size.*[2 2], plot_resolution);

randGabors = load([workingDirectory, experimentDirectory, 'fittedGabors_', 'test', '.mat'], 'results','fvals', 'statii');

randGabors.correctedGabors = convertAbsGabor2Gabor(randGabors.results, patchSize);

randGabors.leftSICA = correctedGabors.s(:,1);
randGabors.rightSICA = correctedGabors.s(:,2);

randGabors.nonZero = randGabors.rightSICA ~= 0;
randGabors.Lratio = randGabors.leftSICA ./ randGabors.rightSICA;
randGabors.Lratio(:,:,2) = randGabors.rightSICA ./ randGabors.leftSICA;
randGabors.Lratio = min(randGabors.Lratio, [], 3);

handle = plotBootstrappedDistribution(bootstrap(randGabors.Lratio(:), noBootstraps), noBins, 'plot', histPlotType);
%title('Histogram of intensity ratio between random pairs', 'FontName', 'Helvetica', 'FontSize', title_font_size, 'HorizontalAlignment','center');
title('Randomised Patches', 'FontName', 'Helvetica', 'FontSize', title_font_size);    
xlabel('Binocular Intensity Ratio', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'FontSize', axis_font_size);
    set(gca, 'LineWidth', line_size);
    set(handle, 'LineWidth', line_size);
    
    text(-0.15,1.05,'C', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
    subplot(2,2,4);
    initialiseJOVPlot(gca, plot_size.*[2 2], plot_resolution);
    [ handle, distribution, CI, bins ] = plotBootstrapCumHist(bootstrap(randGabors.Lratio(:), noBootstraps), noBins);
    hold on
    upperLuminanceCutOff = roundsd(interp1(bins, distribution, 0.8),2);
    lowerLuminanceCutOff = roundsd(interp1(bins, distribution, 0.2),2);

    val3 = roundsd(interp1(bins, distribution, 0.125),2);
    plot([0.125 0.125] , [0 val3],'k-', 'LineWidth', line_size);
    plot([0 0.125] , [val3 val3],'k-', 'LineWidth', line_size);

    % plot CIs
    ci3l = interp1(bins,CI(1,:),0.125) - val3;
    ci3u = interp1(bins,CI(2,:),0.125) - val3;
    errorbar(0.125, val3, -ci3l, ci3u, 'k.', 'LineWidth', line_size);
    errorbar(0, val3, -ci3l, ci3u, 'r.', 'LineWidth', thick_line_size);

    set(gca,'XTick', [0.125, 0.25, 0.5]);
        tickx = get(gca,'XTickLabel');
        if ischar(tickx);
            temp = tickx;
            tickx = cell(1,size(temp,1));
            for j=1:size(temp,1);
                tickx{j} = strtrim( temp(j,:) );
            end;
        end;
        tickx{2} = '0.25';
        tickx{3} = '0.5';
        set(gca,'XTickLabel',tickx);
    set(gca,'YTick', union([0, 0.4:0.2:0.8], [val3]));
    %set(gca, 'LineWidth',3);
    %set(gca, 'FontSize',8);
    %title('Cumulative distribution', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Binocular intensity ratio', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Cumulative proportion', 'FontName', 'Helvetica', 'FontSize', label_font_size);

    set(gca, 'LineWidth', line_size);
    set(gca, 'FontSize', axis_font_size);
    
    text(-0.25,1.05,'D', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        


    
saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c002'], plot_size.*[2 2], plot_resolution);    
print(gcf,'-dpng',sprintf('-r%d-painters',plot_resolution), [ plotDirectory, jpre ,'4c002', '.png']);

end
%%
% Figure 3
% Log Heatmap for Gabor centre locations
% Log Heatmap of window sizes
% Rose plot of orientation distribution
% Polar plot of combined Phase distribution
% Frequecies.

if plot_figure_3
% plot of x,y locations
clf
subplot(3,2,1);
heatmap([leftYCICA(:) ; rightYCICA(:)],[leftXCICA(:) ; rightXCICA(:)], 'cell_scaling','log10');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', axis_font_size);
set(gca, 'LineWidth', line_size);
%title('$$Log_{10}$$ heatmap of Gabor centre locations.', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabels = str2num(get(gca,'XTickLabel'));
xlabels(1) = 0;
set(gca,'XTickLabel', xlabels);
ylabels = str2num(get(gca,'YTickLabel'));
ylabels(1) = 0;
set(gca,'YTickLabel', ylabels);
xlabel('X-axis offset in pixels', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Y-axis offset in pixels', 'FontName', 'Helvetica', 'FontSize', label_font_size);
axis tight
% shifts = struct();
% shifts.yAxisShift = [0.1,0];
% handles = setTicksTex(gca, shifts);
% shiftObject(handles.ylabel, 0.0, -0.2);
% shiftObject(handles.xlabel, 0, 0.1);
% shiftObject(handles.title, 0.0, 0);
% set(handles.ylabel, 'VerticalAlignment', 'middle');

text(0,1.2,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

% plot of window sizes
subplot(3,2,2);
leftWidths = leftSigmaXICA(inds).*leftFreqICA(inds)./2;     % divide by 2 to correct for doubled frequency values
leftHeight = leftSigmaYICA(inds).*leftFreqICA(inds)./2;
rightWidths = rightSigmaXICA(inds).*rightFreqICA(inds)./2;
rightHeight = rightSigmaYICA(inds).*rightFreqICA(inds)./2;
%dist = heatmap([leftSigmaXICA(inds) ; rightSigmaXICA(inds)], [leftSigmaYICA(inds) ; rightSigmaYICA(inds)], 'cell_scaling', 'log10','cutoffsX', 0:0.25:25, 'cutoffsY', 0:0.25:25);
dist = heatmap([leftWidths(isfinite(leftWidths)) ; rightWidths(isfinite(rightWidths))], ...
    [leftHeight(isfinite(leftHeight)) ; rightHeight(isfinite(rightHeight))], 'cell_scaling', 'log10','cutoffsX', 0:0.05:4, 'cutoffsY', 0:0.05:4);
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', axis_font_size);
set(gca, 'LineWidth', line_size);
%title('$$Log_{10}$$ heatmap of window sizes.','Interpreter','LaTex', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('RF width (cycles)','FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('RF height (cycles)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
hold on
plot([0 size(dist.map,1)], [0 size(dist.map,2)], 'k--', 'LineWidth', line_size);
axis tight
% shifts = struct();
% shifts.yAxisShift = [0.1,0];
% handles = setTicksTex(gca, shifts);
% shiftObject(handles.ylabel, -0.05, -0.075);
% shiftObject(handles.xlabel, 0, 0.1);
% shiftObject(handles.title, -0.05,0);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% hold off

text(0,1.2,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

% polar plot of orientation distribution
subplot(3,2,3);
handle = plotBootstrappedDistribution(bootstrap([leftAnglesICA(inds(:)) rightAnglesICA(inds(:))], noBootstraps), noBins, 'plot','rose', 'angle_range', 0:pi/6:pi);
set(gca, 'LineWidth', line_size);
%title('Polar plot of orientation distribution', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Number of components','(1000s)'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel({'Orientation','(Radians)'}, 'FontName', 'Helvetica', 'FontSize', label_font_size, 'Position', [-0.1368614654427671, 0.0644019491305379]);
axis tight
set(gca, 'XTick', []);
set(gca, 'YTick', []);
% handles = setTicksTex(gca);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% shiftObject(handles.xlabel, 0.1,-0.4);
% shiftObject(handles.ylabel, -0.15,-0.2);
% shiftObject(handles.title, -0.1, 0);

text(0,1.2,'C', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

% polar plot of phase distribution
subplot(3,2,4);
handle = plotBootstrappedDistribution(bootstrap([leftPhaseICA(inds) rightPhaseICA(inds)], noBootstraps), noBins, 'plot','rose');
set(gca, 'LineWidth', line_size);
%title('Polar plot of phase distribution', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Phase (Radians)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
axis tight
% set(gca, 'XTick', []);
% set(gca, 'YTick', []);
% handles = setTicksTex(gca);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% shiftObject(handles.ylabel, 0, -0.1);

text(-0.2,1.2,'D', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

% Plot frequency distributions
subplot(3,2,5:6);
combined = [leftFreqICA ; rightFreqICA]./4;
combinedSelected = isfinite(combined);
handle = plotBootstrappedDistribution(bootstrap(combined(combinedSelected), noBootstraps), noBins, 'plot', histPlotType);
set(handle, 'LineWidth', line_size);
set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
%title('Frequencies(ICA)', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Frequency, Reciprocal of wavelength in cycles/arcmin', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
%set(gca, 'YTick', 0:1000:5000);
% shifts = struct();
% shifts.yAxisShift = [0.4,0];
% handles = setTicksTex(gca, shifts);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% shiftObject(handles.ylabel, -0.04, -0.2);
% shiftObject(handles.xlabel, -0.1, 0.1);

text(0,1.2,'E', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c003'], plot_size.*[2 3], plot_resolution);
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c003', '.png']);


end
%%
% Figure 4. Comparisons of frequency and orientation between left/right pairs 
% of Gabor functions fitted to ICA components. Subplot A shows the relationship 
% between the orientations of the left and right parts of the components. 
% Subplot B shows a bootstrapped histogram on the angle differences between
% left and right fitted Gabors. The bars show the median bootstrapped 
% distribution with the error bars showing the 95% confidence intervals. 
% Most fits produce Gabor functions with similar orientations. The left 
% right pairs also exhibit similar frequencies as can be seen from a scatter 
% plot of left and right frequencies. The bootstrapped histogram of frequency 
% difference (subplot D) shows that most have a difference close to zero. 
% The 95% CI indicates that this is significant. Figure 4. Comparisons of 
% frequency and orientation between left/right pairs of Gabor functions 
% fitted to ICA components. Subplot A shows the relationship between the 
% orientations of the left and right parts of the components. Subplot B 
% shows a bootstrapped histogram on the angle differences between left and 
% right fitted Gabors. The bars show the median bootstrapped distribution 
% with the error bars showing the 95% confidence intervals. Most fits produce
% Gabor functions with similar orientations. The left right pairs also exhibit 
% similar frequencies as can be seen from a scatter plot of left and right 
% frequencies. The bootstrapped histogram of frequency difference (subplot D) 
% shows that most have a difference close to zero. The 95% CI indicates 
% that this is significant. 
if plot_figure_4
clf
initialiseJOVPlot(gca, plot_size.*[3 1], plot_resolution);

subplot(1,3,1);
handle = plot(abs(leftAnglesICA(:)), abs(rightAnglesICA(:)), 'k+');
set(gca, 'FontSize', axis_font_size);
set(gca, 'LineWidth', line_size);
%title('Left vs. right component orientation', 'FontName', 'Helvetica', 'FontSize', title_font_size);
set(gca,'XTick',0:pi/2:pi)
set(gca,'XTickLabel',{'$$0$$','$$\pi/2$$','$$\pi$$'})
set(gca,'YTick',0:pi/2:pi)
set(gca,'YTickLabel',{'$$0$$','$$\frac{\pi}{2}$$','$$\pi$$'})
set(gca,'TickLabelInterpreter','Latex');
set(handle,'MarkerSize',0.5);
xlabel('Left orientation (radians)' , 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Right orientation (radians)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
axis tight
% handles = setTicksTex(gca);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% shiftObject(handles.title, -0.05,0);
% shiftObject(handles.ylabel, 0.5, -0.2);
% shiftObject(handles.xlabel, -0.1,  0);

text(-0.3,-0.1,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

%
subplot(1,3,2);
angleDiffICA = [abs(leftAnglesICA(:) - rightAnglesICA(:)), (2*pi) - abs(leftAnglesICA(:)-rightAnglesICA(:))];
angleDiffICA = min(angleDiffICA');
handle = plotBootstrappedDistribution(bootstrap(angleDiffICA, noBootstraps), noBins,  'plot','rose', 'angle_range', 0:pi/6:pi);
set(gca, 'LineWidth', line_size);
%title({'Orientation','disparity distribution'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
ylabel({'Orientation Disparity','(Radians)'}, 'FontName', 'Helvetica', 'FontSize', label_font_size, 'Position', [-1,0.4868835508823397]);
xlabel('Proportion', 'FontName', 'Helvetica', 'FontSize', label_font_size);
axis tight
set(gca, 'XTick', []);
set(gca, 'YTick', []);
% handles = setTicksTex(gca);
% shiftObject(handles.xlabel, 0, -0.1);
% shiftObject(handles.ylabel, 0, -0.3);
% set(handles.ylabel, 'VerticalAlignment', 'middle');

text(-0.0,-1.05,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

subplot(1,3,3);
angleDiffICA = leftAnglesICA(:) - rightAnglesICA(:);
angleDiffICA = angleDiffICA + pi;
angleDiffICA = mod(angleDiffICA, 2*pi);
angleDiffICA = angleDiffICA - pi;
angleSelected = abs(angleDiffICA)<(1/16*pi);
handle = plotBootstrappedDistribution(bootstrap(angleDiffICA(angleSelected), noBootstraps), noBins, 'plot', histPlotType);

set(handle, 'LineWidth', line_size);
set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
%title('Orientation disparity distribution', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Orientation disparity (Radians)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);

set(gca, 'FontSize', axis_font_size);
set(gca, 'LineWidth', line_size);
%set(gca, 'XTick', 0:0.1:0.5);
%set(gca, 'YTick', 0:0.1:0.5);
shifts = struct();
shifts.yAxisShift = [0.4,0];
props.FontSize = axis_font_size;
v = axis();
axis([-pi/16 pi/16+0.00001 v(3) v(4)]);
% handles = setTicksTex(get(gca,'Xtick'), num2tex(-pi/32:pi/32:pi/32,'\pi',pi), props,  shifts);
% %handles = setTicksTex(gca, shifts);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% shiftObject(handles.ylabel, -0.05, -0.2);
% shiftObject(handles.xlabel, -0.1, 0);
% shiftObject(handles.title, -0.1, 0);

text(-0.25,-0.10,'C', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        


saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c004'], plot_size.*[3 1], plot_resolution.*(3/2));
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c004', '.png']);

end
%% Figure 5
if plot_figure_5
    clf
initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);
subplot(1,2,1);
dispAllowed = isfinite(leftFreqICA) & isfinite(rightFreqICA) & inds;
handle = plot(leftFreqICA(dispAllowed), rightFreqICA(dispAllowed), 'k+');
axis([0 0.5 0 0.5])
set(gca, 'FontSize', axis_font_size);
set(gca, 'LineWidth', line_size);
set(handle, 'MarkerSize', 0.1);
%title('Left vs. right component orientation', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Left frequency (cycles per arcmin)' , 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Right frequency (cycles per arcmin)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
%set(gca, 'XTick', 0:0.1:0.5);
%set(gca, 'YTick', 0:0.1:0.5);
% shifts = struct();
% shifts.yAxisShift = [0.4,0];
% handles = setTicksTex(gca, shifts);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% shiftObject(handles.ylabel, -0.1, -0.2);
% shiftObject(handles.xlabel, -0.1, 0.00);
% shiftObject(handles.title, -0.1, 0);

text(-0.15,-0.1,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

    
%
subplot(1,2,2);
freqDiffICA = leftFreqICA./rightFreqICA;
freqDiffICA(:,:,2) = rightFreqICA./leftFreqICA;
freqDiffICA = min(freqDiffICA, [], 3);

freqSelected = isfinite(freqDiffICA) & freqDiffICA<1;
handle = plotBootstrappedDistribution(bootstrap(freqDiffICA(freqSelected), noBootstraps), noBins,  'plot', histPlotType);
set(gca, 'YTick', 0:0.1:0.4);
set(gca, 'XTick', 0:0.2:1);
set(gca, 'FontSize', axis_font_size);
set(handle, 'LineWidth', line_size);
set(gca, 'LineWidth', line_size);
%title('Distribution of ratio of frequencies.', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Ratio of component pair frequencies','        (cycles per arcmin)'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
% shifts = struct();
% shifts.yAxisShift = [0.4 0];
set(gca, 'YLim', [-0.00005, 0.4]);
% handles = setTicksTex(gca, shifts);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% set(handles.xlabel, 'HorizontalAlignment', 'center');
% shiftObject(handles.ylabel, -0.05, -0.2);
% shiftObject(handles.xlabel, -0.1, 0);
% shiftObject(handles.title, -0.1, 0);

text(-0.15,-0.1,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c005'], plot_size.*[2 1], plot_resolution);
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c005', '.png']);
end

% Figure 6. Distribution of absolute phase disparity in the components. 
% Plotted as a polar histogram of the angular distance between left and right
% phases (A), the black boxes show the median of the bootstrapped distribution
% for each angular cell, the red boxes show the 95% CI for each cell. Subplot
%     B shows bootstrapped histogram plot of the same results with 95% CI 
%     shown as black bars. A bimodal distribution can be clearly seen in the 
%     two plots, with the difference between peak and trough that is clearly 
%     larger than the estimated error in the distribution.
if plot_figure_6
clf
initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);

subplot(1,2,1);
phaseDiffICA = abs(leftPhaseICA - rightPhaseICA);
phaseDiffICA(:,:,2) = (2*pi) - abs(rightPhaseICA-leftPhaseICA);
phaseDiffICA = min(phaseDiffICA,[], 3);
handle = plotBootstrappedDistribution(phaseDiffICA, 100, 'plot','rose', 'angle_range', 0:pi/6:pi);
set(gca, 'FontSize', axis_font_size);
set(gca, 'LineWidth', line_size);
%title({'Polar plot of phase','disparity distribution'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Phase disparity', 'FontName', 'Helvetica', 'FontSize', label_font_size);
axis tight
set(gca,'XTick',[]);
set(gca,'YTick',[]);
% shifts = struct();
% shifts.xAxisShift = [ 0 , -0.2];
% handles = setTicksTex(gca, shifts);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% set(handles.xlabel, 'HorizontalAlignment', 'center');
% shiftObject(handles.ylabel, 0.0, -0.2);
% shiftObject(handles.xlabel, 0, -0.2);

text(-0.25,1.5,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

%
subplot(1,2,2);

handle = plotBootstrappedDistribution(phaseDiffICA, noBins, 'plot', histPlotType);
set(gca, 'FontSize', axis_font_size);
set(handle, 'LineWidth', line_size);
set(gca, 'LineWidth', line_size);
%title('Phase Differences between pairs (ICA)', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Phase disparity', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca,'XTick',0:pi/2:pi);
set(gca,'XTickLabel',{'$$0$$','$$\pi/2$$','$$\pi$$'});
set(gca,'TickLabelInterpreter','Latex');
axis square
% shifts = struct();
% shifts.xAxisShift = [ 0 , -0.2];
% handles = setTicksTex(gca, shifts);set(handles.ylabel, 'VerticalAlignment', 'middle');
% set(handles.xlabel, 'HorizontalAlignment', 'center');
% shiftObject(handles.ylabel, -0.1, -0.2);
% shiftObject(handles.xlabel, 0, -0.02);
% shiftObject(handles.title, -0.1,0);

text(-0.25,1,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c006'], plot_size.*[2 1], plot_resolution);
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c006', '.png']);
end

% Figure 6. (A,B) Marginal distributions of the horizontal and vertical
% disparities between left and right view fitted Gabor functions, computed
% as bootstrapped histograms with 100 bins. In plots A-F the distributions
% are limited to 98.25% double sided quintiles. The distributions are clearly
% peaked at 0, broadly symmetric and highly kurtotic. C&D show the displacements
% as a function of the frequencies of the fitted functions. E&F show the 
% cumulative distributions of the horizontal and vertical displacements 
% respectively. The median of the computed distributions is shown as a black
% line, the 95% CI intervals are shown as a thick red polygon. The proportions
% of the distributions with disparities of less than ¼, ½, 1 cycles are marked
% along with the CI of proportions shown as red lines on the vertical axis. 
% G&H show the joint distributions of the horizontal and vertical position 
% disparities as a ratio of wavelength, G shows a scatter plot of all the 
% computed locations (27661 in total), H shows a 2D heat-map of the 
% distribution with each cell colour coded to show the natural log of the 
% cell count. (White shows a cell count of zero)
if plot_figure_7
clf
plot_size7 = [ 1200 1200 ];
initialiseJOVPlot(gca, plot_size.*[3 2], plot_resolution);
subplot(2,3,1);

hdisp = (leftXCICA - rightXCICA);
dispAllowed = ~isnan(hdisp) & inds;
q = quantile(abs(hdisp(dispAllowed)), percentile);
dispSelected = ~isnan(hdisp) & abs(hdisp)<q & inds;

%Distribution of horizontal displacements
[handle,bins, distribution,CI]= plotBootstrappedDistribution(bootstrap(hdisp(dispSelected), noBootstraps), noBins, 'plot', histPlotType);
set(gca, 'LineWidth', line_size);
set(handle(1), 'LineWidth', line_size, 'Color', [ 0.5 0.5 0.5]);
set(handle(2), 'LineWidth', thin_line_size);
set(gca, 'FontSize', axis_font_size);
v = axis;
%axis([ -5 5 0 1700]);
%set(gca, 'YLim', [-0.005, 1700]);
axis([ -5 5 0 0.07]);
set(gca, 'YLim', [-0.000005, 0.0700001]);
set(gca,'XTick',-5:1:5)
set(gca,'YTick',0:0.02:0.07);
%title({'\centerline{Distribution of horizontal}','\centerline{position disparity}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
title({'Horizontal'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
%set(gca,'XTick',-5:1:5)
%set(gca,'YTick',0:500:1500);
%set(gca,'YTick',0:0.2:1);
xlabel('Horizontal displacement in pixels', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
% handles = setTicksTex(gca);
% shiftObject(handles.title, 0.2,0);
% shiftObject(handles.xlabel, -0.1, 0.05);
% shiftObject(handles.ylabel, 0.04 ,-0.15);

text(-0.1,1.1,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

% Distribution of vertical displacements
subplot(2,3,4);
vdisp = (leftYCICA - rightYCICA);
dispAllowed = ~isnan(vdisp) & inds;
q = quantile(abs(vdisp(dispAllowed)), percentile);
dispSelected = ~isnan(vdisp) & abs(vdisp)<q & inds;

[handle,bins, distribution,CI]= plotBootstrappedDistribution(bootstrap(vdisp(dispSelected), noBootstraps), noBins, 'plot', histPlotType);
set(gca, 'LineWidth', line_size);
set(handle(1), 'LineWidth', line_size, 'Color', [ 0.5 0.5 0.5]);
set(handle(2), 'LineWidth', thin_line_size);
set(gca, 'FontSize', axis_font_size);
v = axis;
%axis([ -5 5 0 1700]);
%set(gca, 'YLim', [-0.005, 1700]);
%title({'\centerline{Distribution of vertical}','\centerline{position disparity}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
title({'Vertical'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
%set(gca,'XTick',-5:1:5)
%set(gca,'YTick',0:500:1500);
xlabel('Vertical displacement in pixels', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
axis([ -5 5 0 0.07]);
set(gca, 'YLim', [-0.000005, 0.0700001]);
set(gca,'XTick',-5:1:5)
set(gca,'YTick',0:0.02:0.07);
% handles = setTicksTex(gca);
% shiftObject(handles.title, 0.2,0);
% shiftObject(handles.xlabel, -0.1, 0.05);
% shiftObject(handles.ylabel, 0.04 ,-0.15);
% set(gca,'XTick',[]);
% set(gca,'YTick',[]);

text(-0.1,1.1,'D', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
%
subplot(2,3,2);
hdispF = hdisp.*rightFreqICA;
dispAllowed = ~isnan(hdispF) & inds;
q = quantile(abs(hdispF(dispAllowed)), percentile);
dispSelected = ~isnan(hdispF) & abs(hdispF)<q & inds;

handle = plotBootstrappedDistribution(bootstrap(hdispF(dispSelected), noBootstraps), noBins, 'plot', histPlotType);
set(gca, 'LineWidth', line_size);
set(handle(1), 'LineWidth', line_size, 'Color', [ 0.5 0.5 0.5]);
set(handle(2), 'LineWidth', thin_line_size);
set(gca, 'FontSize', axis_font_size);

v = axis;
%axis([ -1.5 1.5 0 1700]);
%set(gca, 'YLim', [-0.005, 1700]);
%set(gca, 'XLim', [-1.50005, 1.50005]);
%title({'\centerline{Distribution of horizontal}','\centerline{position disparity}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
%title('Horizontal', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Displacement disparity','as a ratio of wavelength'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
%set(gca,'XTick',-1.5:1:1.5)
%set(gca,'YTick',0:500:1500);v = axis;
axis([ -1.5 1.5 v(3:4)]);
set(gca, 'YLim', [-0.0000001, v(4).*1.000001]);
set(gca,'XTick',-1.5:0.5:1.5)
set(gca,'YTick',0:0.02:v(4));
%setTicksTex(gca);
% handles = setTicksTex(gca);
% shiftObject(handles.title, 0.2,0);
% shiftObject(handles.xlabel, 0.1, 0.05);
% shiftObject(handles.ylabel, 0.04 ,-0.15);

text(-0.1,1.1,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
%
subplot(2,3,5);
vdispF = vdisp.*rightFreqICA;
dispAllowed = ~isnan(vdispF) & inds;
q = quantile(abs(vdispF(dispAllowed)), percentile);
dispSelected = ~isnan(vdispF) & abs(vdispF)<q & inds;

handle = plotBootstrappedDistribution(bootstrap(vdispF(dispSelected), noBootstraps), noBins, 'plot', histPlotType);
set(gca, 'LineWidth', line_size);
set(handle(1), 'LineWidth', line_size, 'Color', [ 0.5 0.5 0.5]);
set(handle(2), 'LineWidth', thin_line_size);
set(gca, 'FontSize', axis_font_size);
%v = axis;
%axis([ -1.5 1.5 0 1700]);
%set(gca, 'YLim', [-0.005, 1700]);
%set(gca, 'XLim', [-1.50005, 1.50005]);
%title({'\centerline{Distribution of vertical}','\centerline{position disparity}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Displacement disparity','as a ratio of wavelength'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
%set(gca,'XTick',-1.5:0.5:1.5);
%set(gca,'YTick',0:500:1500);
v = axis;
axis([ -1.5 1.5 v(3:4)]);
set(gca, 'YLim', [-0.0000001, v(4).*1.000001]);
set(gca,'XTick',-1.5:0.5:1.5)
set(gca,'YTick',0:0.02:v(4));
%setTicksTex(gca);
% handles = setTicksTex(gca);
% shiftObject(handles.title, 0.2,0);
% shiftObject(handles.xlabel, 0.1, 0.05);
% shiftObject(handles.ylabel, 0.04 ,-0.15);
% set(gca,'XTick',[]);
% set(gca,'YTick',[]);

text(-0.1,1.1,'E', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
%
subplot(2,3,3);
%dispSelected = ~isnan(hdispF) & inds & hdispF~=0;

sum(dispAllowed(:))
[ handle, distribution, CI, bins ] = plotBootstrapCumHist(abs(bootstrap(hdispF(dispAllowed), noBootstraps)), noBins);
set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
hold on

val1 = interp1(bins, distribution, 1);
plot([1 1] , [0 val1],'k-', 'LineWidth', thin_line_size);
plot([0 1] , [val1 val1],'k-', 'LineWidth', thin_line_size);

val2 = interp1(bins, distribution, 0.25);
plot([0.25 0.25] , [0 val2],'k-', 'LineWidth', thin_line_size);
plot([0 0.25] , [val2 val2],'k-', 'LineWidth', thin_line_size);

val3 = interp1(bins, distribution, 0.5);
plot([0.5 0.5] , [0 val3],'k-', 'LineWidth', thin_line_size);
plot([0 0.5] , [val3 val3],'k-', 'LineWidth', thin_line_size);

% plot CIs
ci1l = interp1(bins,CI(1,:),1) - val1;
ci1u = interp1(bins,CI(2,:),1) - val1;
errorbar(1, val1, ci1l, ci1u, 'k.', 'LineWidth', thick_line_size);
errorbar(0, val1, ci1l, ci1u, 'r.', 'LineWidth', thick_line_size);
ci2l = interp1(bins,CI(1,:),0.25) - val2;
ci2u = interp1(bins,CI(2,:),0.25) - val2;
errorbar(0.25, val2, ci2l, ci2u, 'k.', 'LineWidth', thick_line_size);
errorbar(0, val2, ci2l, ci2u, 'r.', 'LineWidth', thick_line_size);
ci3l = interp1(bins,CI(1,:),0.5) - val3;
ci3u = interp1(bins,CI(2,:),0.5) - val3;
errorbar(0.5, val3, -ci3l, ci3u, 'k.', 'LineWidth', line_size);
errorbar(0, val3, -ci3l, ci3u, 'r.', 'LineWidth', thick_line_size);
%title({'\centerline{Distribution of horizontal}','\centerline{position disparity}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Displacement disparity','as a ratio of wavelength'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca,'XTick', union(0:1:3, [0.25, 0.5 , 1]));
set(gca,'XTickLabel', num2tex(union(0:1:3, [0.25, 0.5 , 1])), 'TickLabelInterpreter', 'Latex');
val1 = roundsd(val1,2);
val2 = roundsd(val2,2);
val3 = roundsd(val3,2);
set(gca,'fontsize', axis_font_size);
%set(gca,'XTickLabel',tickx);
set(gca,'YTick', union(0:0.2:0.6, [val1, val2, val3]));
axis([ 0 3 0 1]);
set(gca, 'YLim', [-0.005, 1.005]);
%setTicksTex(gca);
% handles = setTicksTex(gca);
% shiftObject(handles.title, 0.2,0);
% shiftObject(handles.xlabel, 0.1, 0.05);
% shiftObject(handles.ylabel, 0.04 ,-0.15);
% shiftObject(handles.xTicks(2), -0.025, 0);
% set(gca,'XTick',[]);
% set(gca,'YTick',[]);
%set(gca,'XTickLabel', {'-1,','-0.75','-0.5','-0.25','0', '0.25', '0.5', '0.75', '1'})

text(-0.1,1.1,'C', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
%
subplot(2,3,6);
hold off
dispSelected = ~isnan(vdispF) & inds & vdispF~=0;

sum(dispAllowed(:))
[ handle, distribution, CI, bins ] = plotBootstrapCumHist(abs(bootstrap(vdispF(dispAllowed), noBootstraps)), noBins);

set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
hold on
val1 = interp1(bins, distribution, 1)
plot([1 1] , [0 val1],'k-', 'LineWidth', thin_line_size);
plot([0 1] , [val1 val1],'k-', 'LineWidth', thin_line_size);

val2 = interp1(bins, distribution, 0.25)
plot([0.25 0.25] , [0 val2],'k-', 'LineWidth', thin_line_size);
plot([0 0.25] , [val2 val2],'k-', 'LineWidth', thin_line_size);

val3 = interp1(bins, distribution, 0.5)
plot([0.5 0.5] , [0 val3],'k-', 'LineWidth', thin_line_size);
plot([0 0.5] , [val3 val3],'k-', 'LineWidth', thin_line_size);

% plot CIs
ci1l = interp1(bins,CI(1,:),1) - val1;
ci1u = interp1(bins,CI(2,:),1) - val1;
errorbar(1, val1, -ci1l, ci1u, 'k.', 'LineWidth', line_size);
errorbar(0, val1, -ci1l, ci1u, 'r.', 'LineWidth', thick_line_size);
ci2l = interp1(bins,CI(1,:),0.25) - val2;
ci2u = interp1(bins,CI(2,:),0.25) - val2;
errorbar(0.25, val2, -ci2l, ci2u, 'k.', 'LineWidth', line_size);
errorbar(0, val2, -ci2l, ci2u, 'r.', 'LineWidth', thick_line_size);
ci3l = interp1(bins,CI(1,:),0.5) - val3;
ci3u = interp1(bins,CI(2,:),0.5) - val3;
errorbar(0.5, val3, -ci3l, ci3u, 'k.', 'LineWidth', line_size);
errorbar(0, val3, -ci3l, ci3u, 'r.', 'LineWidth', thick_line_size);
%title({'\centerline{Distribution of vertical}','\centerline{position disparity}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Displacement disparity','as a ratio of wavelength'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
val1 = roundsd(val1,2);
val2 = roundsd(val2,2);
val3 = roundsd(val3,2);

set(gca, 'FontSize',axis_font_size);
set(gca,'YTick', union(0:0.2:0.8, [val2, val3]));

axis([0 3 0 1]);
set(gca, 'XLim', [-0.0005, 3.0005]);
set(gca,'XTick', union(0:1:3, [0.25, 0.5 , 1]));
set(gca,'XTickLabel', num2tex(union(0:1:3, [0.25, 0.5 , 1])), 'TickLabelInterpreter', 'Latex');

%setTicksTex(gca);
% handles = setTicksTex(gca);
% shiftObject(handles.title, 0.2,0);
% shiftObject(handles.xlabel, 0.1, 0.05);
% shiftObject(handles.ylabel, 0.04 ,-0.15);
% shiftObject(handles.xTicks(2), -0.025, 0);
% set(gca,'XTick',[]);
% set(gca,'YTick',[]);

text(-0.1,1.1,'F', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c007'], plot_size7.*[3 2], plot_resolution*(3/2));
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c007', '.png']);
end

%%
% Figure 8 The joint distributions of the horizontal and vertical position 
% disparities as a ratio of wavelength, A shows a scatter plot of all the 
% computed locations (27661 in total), B shows a 2D heat-map of the 
% distribution with each cell colour coded to show the natural log of the 
%  cell count. (White shows a cell count of zero)
if plot_figure_8
clf
initialiseJOVPlot(gca, plot_size.*[1 2], plot_resolution);
subplot(1,2,1);

vdispF = vdisp.*rightFreqICA;
dispAllowedV = ~isnan(vdispF) & inds;
q = quantile(abs(vdispF(dispAllowedV)), percentile);
dispSelectedV = ~isnan(vdispF) & abs(vdispF)<q & inds;

hdispF = hdisp.*rightFreqICA;
dispAllowedH = ~isnan(hdispF) & inds;
q = quantile(abs(hdispF(dispAllowedV)), percentile);
dispSelectedH = ~isnan(hdispF) & abs(hdispF)<q & inds;

dispAllowed = dispAllowedV & dispAllowedH;
dispSelected = dispSelectedV & dispSelectedH;

handle = plot(hdispF(dispAllowed), vdispF(dispAllowed), 'k+');
%title('Scatter plot of position disparity.', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Horizontal position disparity', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Vertical position disparity', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(handle, 'MarkerSize',0.1);
set(gca,'FontSize',axis_font_size);
%set(gca,'XTickLabel', {'-1,','-0.75','-0.5','-0.25','0', '0.25', '0.5', '0.75', '1'})
set(gca,'XTick',-2:0.5:2)
set(gca,'XLim', [-2.00001,2.000001]);
set(gca,'YTick',-2:0.5:2)
set(gca,'YLim', [-2.00001,2.000001]);
% handles = setTicksTex(gca);
% shiftObject(handles.title, -0.1,0.005);
% shiftObject(handles.xlabel, -0.1, -0.015);
% shiftObject(handles.ylabel, -0.05 ,-0.15);

text(-0.1,1.05,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

subplot(1,2,2);
heatmap(hdispF(dispAllowed), vdispF(dispAllowed), 'cell_scaling','log10', 'cutoffsX', -2:0.05:2, 'cutoffsY', -2:0.05:2 );
%title('Joint distribution of position disparities', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Horizontal position disparity', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Vertical position disparity', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca,'fontsize', axis_font_size);
% handles = setTicksTex(gca);
% shiftObject(handles.title, -0.1,0.005);
% shiftObject(handles.xlabel, -0.1, -0.025);
% shiftObject(handles.ylabel, -0.05 ,-0.15);

text(-0.1,1.4,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c008'], plot_size.*[2 1], plot_resolution);
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4f008', '.png']);
end

% % Figure 8. Distribution of position disparities as a ratio of wavelength.
% Subplots A,C shows bootstrapped histrograms of the component oriented
% displacement disparities (A) and the orthogonal to component orientation
% disparities respectively (C). Subplots B,C show the bootstrapped cumulative
% distributions for component oriented and component orthogonal oriented
% position disparity respectively. All distances are ratios of the component
% wavelength.  Positive disparities indicate components tuned to detect ‘near’
% type disparities, negative disparities indicate components tuned to detect
% ‘far’ type disparities. As can be seen from the two figures the vast
% majority of components are tuned to functions less than the wavelength.
% Some 88% have disparities of less than ¼ of the wavelength, 93% have
% wavelength less than ½ of the wavelength.
if plot_figure_9
clf

initialiseJOVPlot(gca, plot_size.*[2 2], plot_resolution);
subplot(2,2,1);

dispF = disp.*rightFreqICA;
dispAllowed = ~isnan(dispF) & inds;
q = quantile(abs(dispF(dispAllowed)), percentile);
dispSelected = ~isnan(dispF) & abs(dispF)<q & inds;

[handle,bins, distribution,CI]= plotBootstrappedDistribution(bootstrap(dispF(dispSelected), noBootstraps), noBins, 'plot', histPlotType);
set(handle, 'LineWidth', line_size);
set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
set(handle(1), 'LineWidth', line_size, 'Color', [ 0.5 0.5 0.5]);
set(handle(2), 'LineWidth', thin_line_size);
title('Orthogonal position disparities', 'FontName', 'Helvetica', 'FontSize', title_font_size);
v = axis;
axis([ -0.5 0.5 v([3,4])])
set(gca,'XTick',-0.5:0.25:0.5)
xlabel('Position disparity as a ratio of wavelength', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca, 'FontSize', axis_font_size);

% handles = setTicksTex(gca);
% shiftObject(handles.title, -0.05,0.005);
% shiftObject(handles.xlabel, -0.1, 0.01);
% shiftObject(handles.ylabel, 0 ,-0.15);

text(-0.25,1,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
%
subplot(2,2,2)
[ handle, distribution, CI, bins ] = plotBootstrapCumHist(abs(bootstrap(dispF(dispAllowed), noBootstraps)), noBins);
set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);

hold on
val1 = roundsd(interp1(bins, distribution, 1),2);
plot([1 1] , [0 val1],'k-', 'LineWidth', thin_line_size);
plot([0 1] , [val1 val1],'k-', 'LineWidth', thin_line_size);

val2 = roundsd(interp1(bins, distribution, 0.25),2);
plot([0.25 0.25] , [0 val2],'k-', 'LineWidth', thin_line_size);
plot([0 0.25] , [val2 val2],'k-', 'LineWidth', thin_line_size);

val3 = roundsd(interp1(bins, distribution, 0.5),2);
plot([0.5 0.5] , [0 val3],'k-', 'LineWidth', thin_line_size);
plot([0 0.5] , [val3 val3],'k-', 'LineWidth', thin_line_size);

% plot CIs
ci1l = interp1(bins,CI(1,:),1) - val1;
ci1u = interp1(bins,CI(2,:),1) - val1;
errorbar(1, val1, -ci1l, ci1u, 'k.', 'LineWidth', thin_line_size);
errorbar(0, val1, -ci1l, ci1u, 'r.', 'LineWidth', thin_line_size);
ci2l = interp1(bins,CI(1,:),0.25) - val2;
ci2u = interp1(bins,CI(2,:),0.25) - val2;
errorbar(0.25, val2, -ci2l, ci2u, 'k.', 'LineWidth', thin_line_size);
errorbar(0, val2, -ci2l, ci2u, 'r.', 'LineWidth', thin_line_size);
ci3l = interp1(bins,CI(1,:),0.5) - val3;
ci3u = interp1(bins,CI(2,:),0.5) - val3;
errorbar(0.5, val3, -ci3l, ci3u, 'k.', 'LineWidth', thin_line_size);
errorbar(0, val3, -ci3l, ci3u, 'r.', 'LineWidth', thin_line_size);
%title('Distribution of orthogonal position disparities', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Absolute position disparity','as a ratio of wavelength'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca,'XTick', union(0:1:7, [0.25, 0.5 , 1]));
    tickx = get(gca,'XTickLabel');
    if ischar(tickx);
        temp = tickx;
        tickx = cell(1,size(temp,1));
        for j=1:size(temp,1);
            tickx{j} = strtrim( temp(j,:) );
        end;
    end;
    tickx{2} = '$$\frac{1}{4}$$'; %'0.25';
    tickx{3} = '$$\frac{1}{2}$$'; %'0.5';
    set(gca,'XTickLabel',tickx);
    set(gca,'TickLabelInterpreter','Latex');
set(gca,'YTick', union(0:0.2:0.8, [val2, val3]));
set(gca, 'FontSize',axis_font_size);
axis([0 3 -0.0000001, 1.0000001]);
% handles = setTicksTex(gca);
% shiftObject(handles.title, -0.05,0.005);
% shiftObject(handles.xlabel, -0.1, 0.01);
% shiftObject(handles.ylabel, 0 ,-0.15);

text(-0.25,1,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
%
subplot(2,2,3)
% Plot orthoginal distributions
%
odispF = odisp .* rightFreqICA;
dispAllowed = ~isnan(odispF) & inds;
q = quantile(odispF(dispAllowed), percentile);
dispSelected = ~isnan(odispF) & abs(odispF)<q & inds;


[handle,bins, distribution,CI]= plotBootstrappedDistribution(bootstrap(odispF(dispSelected), noBootstraps), noBins, 'plot', histPlotType);
set(handle, 'LineWidth', line_size);
set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
set(handle(1), 'LineWidth', line_size, 'Color', [ 0.5 0.5 0.5]);
set(handle(2), 'LineWidth', thin_line_size);
v = axis;
axis([ -0.5 0.5 v([3,4])])
title('Parallel position disparities', 'FontName', 'Helvetica', 'FontSize', title_font_size);
%set(gca,'XTick',-5:1:5)
xlabel('Position disparity as a ratio of wavelength', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca, 'FontSize', axis_font_size);
set(gca,'XTick', -0.5:0.25:0.5);
% handles = setTicksTex(gca);
% shiftObject(handles.title, -0.05,0.005);
% shiftObject(handles.xlabel, -0.1, 0.01);
% shiftObject(handles.ylabel, 0 ,-0.15);

text(-0.25,1,'C', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
%
subplot(2,2,4);
[ handle, distribution, CI, bins ] = plotBootstrapCumHist(abs(bootstrap(odispF(dispAllowed), noBootstraps)), noBins*4);
hold on
val1 = roundsd(interp1(bins, distribution, 1),2);
plot([1 1] , [0 val1],'k-', 'LineWidth', thin_line_size);
plot([0 1] , [val1 val1],'k-', 'LineWidth', thin_line_size);

val2 = roundsd(interp1(bins, distribution, 0.25),2);
plot([0.25 0.25] , [0 val2],'k-', 'LineWidth', thin_line_size);
plot([0 0.25] , [val2 val2],'k-', 'LineWidth', thin_line_size);

val3 = roundsd(interp1(bins, distribution, 0.5),2);
plot([0.5 0.5] , [0 val3],'k-', 'LineWidth', thin_line_size);
plot([0 0.5] , [val3 val3],'k-', 'LineWidth', thin_line_size);

% plot CIs
ci1l = interp1(bins,CI(1,:),1) - val1;
ci1u = interp1(bins,CI(2,:),1) - val1;
errorbar(1, val1, -ci1l, ci1u, 'k.', 'LineWidth', thin_line_size);
errorbar(0, val1, -ci1l, ci1u, 'r.', 'LineWidth', thin_line_size);
ci2l = interp1(bins,CI(1,:),0.25) - val2;
ci2u = interp1(bins,CI(2,:),0.25) - val2;
errorbar(0.25, val2, -ci2l, ci2u, 'k.', 'LineWidth', thin_line_size);
errorbar(0, val2, -ci2l, ci2u, 'r.', 'LineWidth', thin_line_size);
ci3l = interp1(bins,CI(1,:),0.5) - val3;
ci3u = interp1(bins,CI(2,:),0.5) - val3;
errorbar(0.5, val3, -ci3l, ci3u, 'k.', 'LineWidth', thin_line_size);
errorbar(0, val3, -ci3l, ci3u, 'r.', 'LineWidth', thin_line_size);
%title('Distribution of parallel position disparities', 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel({'Absolute position disparity','as a ratio of wavelength'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca,'XTick', union(0:1:7, [0.25, 0.5 , 1]));
    tickx = get(gca,'XTickLabel');
    if ischar(tickx);
        temp = tickx;
        tickx = cell(1,size(temp,1));
        for j=1:size(temp,1);
            tickx{j} = strtrim( temp(j,:) );
        end;
    end;
    tickx{2} = '$$\frac{1}{4}$$';%'0.25';
    tickx{3} = '$$\frac{1}{2}$$';%'0.5';
    set(gca,'XTickLabel',tickx);
    set(gca,'TickLabelInterpreter','Latex');
set(gca,'YTick', union(0:0.2:0.8, [val1, val2, val3]));
axis([0 3 -0.0000001, 1.0000001]);
set(gca,'FontSize', axis_font_size);
set(gca,'LineWidth', line_size);
%set(gca,'XTickLabel', {'-1,','-0.75','-0.5','-0.25','0', '0.25', '0.5', '0.75', '1'})
% handles = setTicksTex(gca);
% shiftObject(handles.title, -0.05,0.005);
% shiftObject(handles.xlabel, -0.1, 0.01);
% shiftObject(handles.ylabel, 0 ,-0.15);

text(-0.25,1,'D', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        

saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c009'], plot_size.*[2 2], plot_resolution);
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c009', '.png']);

end

%%
% Figure 10. Distribution of direction of disparity. Subplot A shows a rose 
% plot of the distribution of disparities between left and right fitted 
% components. The blue lines show the median counts in each bin, the red bars
% show the range of the 95% CI of the bootstrapped distributions. An angle of
% 0 radians indicates a vertically oriented Gabor function with positive 
% angels indicating counter-clockwise rotation. Similarly, a displacement 
% angle of 0 radians indicates a vertically oriented displacement. A strong 
% bias can be seen towards grid aligned horizontal and vertical directions, 
% this is likely due to the structure of the sampling grid (see main text). 
% A clear and consistent effect of a bias towards horizontal rather than 
% vertical disparities is also visible, with the distributions showing a 
% smooth transition in between the horizontal and vertical directions. 
% Subplot B shows a (Natural) Log heatmap showing the joint distribution of 
% the orientation of the components (?) against the direction of disparity. 
% Again the strong bias towards grid aligned horizontal and vertical can be 
% seen as a cross shape on the distribution.  Any link between component 
% orientation and disparity direction is masked by the horizontal and 
% vertical grid alignment. 

if plot_figure_10

    initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);
    
vdisp = (leftYCICA - rightYCICA);
dispAllowed = ~isnan(vdisp) & inds;
q = quantile(abs(vdisp(dispAllowed)), percentile);
dispSelected = ~isnan(vdisp) & abs(vdisp)<q & inds;


hdisp = (leftXCICA - rightXCICA);
dispAllowed = ~isnan(hdisp) & inds;
q = quantile(abs(hdisp(dispAllowed)), percentile);
dispSelected = ~isnan(hdisp) & abs(hdisp)<q & inds;
    
    angleDisp = atan2(vdisp, hdisp);

    angleSelected = ~isnan(angleDisp);
    orientationSelected = isfinite(leftAnglesICA) & isfinite(rightAnglesICA);
    combinedSelected = inds & angleSelected & orientationSelected;

    
   clf
subplot(1,2,1);

handle = plotBootstrappedDistribution(bootstrap(angleDisp(combinedSelected), noBootstraps), noBins, 'plot','rose');
%title({'\centerline{Rose plot of distribution of}','\centerline{position disparity orientation}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Proportion of distribution', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel({'Phase disparity','(Radians)'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca, 'LineWidth', line_size);
set(gca, 'FontSize', axis_font_size);
axis tight
% set(gca,'XTick',[]);
% set(gca,'YTick',[]);
% shifts = struct();
% shifts.xAxisShift = [ 0 , -0.2];
% handles = setTicksTex(gca, shifts);
% set(handles.ylabel, 'VerticalAlignment', 'middle');
% set(handles.xlabel, 'HorizontalAlignment', 'center');
% shiftObject(handles.ylabel, 0.0, -0.1);
% shiftObject(handles.xlabel, -0.05, -0.0);
% shiftObject(handles.title, 0.1, 0);

text(-0.25,1.1,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
subplot(1,2,2)

angleDisp = atan2(vdisp, hdisp);
%angleDisp(angleDisp<-pi/2) = angleDisp(angleDisp<-pi/2) + pi;
%angleDisp(angleDisp>pi/2) = angleDisp(angleDisp>pi/2) - pi;

angleDisp2 = [ angleDisp angleDisp ];
angleSelected = ~isnan(angleDisp2);
orientations = [ leftAnglesICA rightAnglesICA ];
orientationSelected = ~isnan(orientations);
combinedSelected = [inds inds ] & angleSelected & orientationSelected;

%combinedSelected = combinedSelected & angleDisp2 ~=0 & angleDisp2 ~= -pi/2 & angleDisp2 ~= pi/2 & orientations~=pi;
heatmap(orientations(combinedSelected), angleDisp2(combinedSelected), 'cell_scaling', 'log10');
%title({'\centerline{Heatmap of displacement direction}','\centerline{vs. component orientation.}'}, 'FontName', 'Helvetica', 'FontSize', title_font_size);
xlabel('Direction of displacement (Radians)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
ylabel({'Orientation of components','(Radians)'}, 'FontName', 'Helvetica', 'FontSize', label_font_size);
set(gca, 'FontSize', axis_font_size);
labels = get(gca, 'XTickLabel');
labels(1,:) = ' ';
labels(1,1) = '0';
set(gca,'XTickLabel', labels);

axis tight
% handles = setTicksTex(gca, shifts);
% shiftObject(handles.title, 0.1,0);
% shiftObject(handles.ylabel, 0, -0.1);
% shiftObject(handles.xlabel, -0.15, 0);

text(-0.225,1.2,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');

saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c0010'], plot_size.*[2 1], plot_resolution);
print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c0010', '.png']);


end

%%
% Figure 11. Phase displacement in radians against position disparity as a 
% fraction of wavelength. The lines that appear suggest a link between phase 
% and position disparity. The central cluster shows correlated binocular 
% components, the left and right clusters show anti-correlated components.
if plot_figure_11
clf

    initialiseJOVPlot(gca, plot_size.*[2 2], plot_resolution);

    subplot(2,1,1);
    
    phaseDiffICA = (leftPhaseICA - rightPhaseICA);

    dispAllowed = isfinite(phaseDiffICA) & isfinite(dispF);
    
    q = quantile(abs(dispF(dispAllowed)), percentile);
    
    dispSelected = dispAllowed & abs(dispF) < 1;
    
    small_selection_phases = phaseDiffICA(dispSelected);
    small_selection_disp = dispF(dispSelected);
    
    selection = randi(length(small_selection_phases),1,10000);
    
    handle = plot(small_selection_phases(selection), small_selection_disp(selection), 'k.');
    
    %title('Phase disparity vs. absolute position disparity', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    ylabel('Position disparity (ratio of wavelength)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    xlabel('Phase disparity (Radians)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);
    set(handle, 'MarkerSize', 0.1);
    
%     handles = setTicksTex(gca);
%     shiftObject(handles.ylabel, -0.025, -0.15);
%     shiftObject(handles.xlabel, -0.05, 0);
%     shiftObject(handles.title, -0.05, 0);
%     
     ratio = get(gca, 'DataAspectRatio');

     text(-0.05,1.1,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
     
    subplot(2,1,2)
    
    heatmap(phaseDiffICA(dispSelected), dispF(dispSelected), 'cell_scaling','log10');
    
    %title('Phase disparity vs. absolute position disparity', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    ylabel('Position disparity (ratio of wavelength)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    xlabel('Phase disparity (Radians)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);
    set(gca, 'DataAspectRatio', [ ratio(2) ratio(1) ratio(3)]);
    labels = get(gca, 'XTickLabel');
    labels(3,:) = ' ';
    labels(3,1) = '0';
    set(gca,'XTickLabel', labels);
    labels = get(gca, 'YTickLabel');
    labels(3,:) = ' ';
    labels(3,1) = '0';
    set(gca,'YTickLabel', labels);    
    axis normal
    
    
%     handles = setTicksTex(gca);
%     shiftObject(handles.ylabel, 0, -0.2);
%     shiftObject(handles.xlabel, -0.05, 0);
%     shiftObject(handles.title, -0.05, 0);

    text(-0.05,1.1,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c011'], plot_size.*[2 2], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c011', '.png']);
    
end

%%
% Figure 12. Phase displacement in radians against position disparity as a 
% fraction of wavelength. The lines that appear suggest a link between phase 
% and position disparity. The central cluster shows correlated binocular 
% components, the left and right clusters show anti-correlated components.
%
% old version
if plot_figure_12
clf

    initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);

    subplot(1,2,1);
    
    physDispF = physDisp.*rightFreqICA;
    shapeDiffF = shapeDiff.* rightFreqICA;

    dispAllowed = isfinite(physDispF) & isfinite(shapeDiffF) & inds;
    
    q = quantile(abs(physDispF(dispAllowed)), percentile);
    
    %dispSelected = dispAllowed & abs(shapeDiffF) < 2.*pi;
    dispSelected = dispAllowed & abs(physDispF)<5 & abs(shapeDiffF)<5;
    
    small_selection_position = physDispF(dispSelected);
    small_selection_shape = shapeDiffF(dispSelected);
    
    selection = randi(length(small_selection_position),1,10000);
    
    handle = plot(small_selection_position(selection), small_selection_shape(selection), 'k.');
    
    %title('Phase disparity vs. absolute position disparity', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Combined Disparity (wavelengths)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Residual', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);
    set(gca, 'XTick', -2:1:2);
    set(gca, 'XTickLabel', -1:0.5:1);
    set(gca, 'XGrid', 'on');
    set(handle, 'MarkerSize', 0.1);
    
%     handles = setTicksTex(gca);
%     shiftObject(handles.ylabel, -0.025, -0.1);
%     shiftObject(handles.xlabel, -0.05, 0);
%     shiftObject(handles.title, 0.5, 0);
%     
     ratio = get(gca, 'DataAspectRatio');

     text(-0.25,0.975,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
     
    subplot(1,2,2)
    
    
    dispMap = heatmap(physDispF(dispSelected), shapeDiffF(dispSelected), 'cell_scaling','log10', 'ncellx', 1000, 'ncelly', 100);
    
    %title('Phase disparity vs. absolute position disparity', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Combined Disparity (wavelengths)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Residual', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);
    set(gca, 'DataAspectRatio', [ ratio(2) ratio(1) ratio(3)]);
        
    xTicks = -2:1:2;
    xTickLocs = [];
    for loop = 1:numel(xTicks)
        xTickLocs(loop) = find(dispMap.cutoffsX > xTicks(loop),1);
    end
    
    hold on
    

    axis normal
    
    haxesHeat = gca; % handle to axes    
    haxesHeat_pos = get(haxesHeat,'Position'); % store position of first axes
    haxesBar = axes('Position',haxesHeat_pos,...
                    'XAxisLocation','top',...
                    'YAxisLocation','right',...
                    'Color','none');   
                
    h = hist(physDispF(dispSelected), xTicks);
    % some manual bootstrapping
    physDispFBoot = bootstrap(physDispF(dispSelected), noBootstraps);
    phyDispFHist = [];
    CIPhyDispFHist = [];
    for loop = 1:size(physDispFBoot,1)
        phyDispFHist(loop,:) = hist(physDispFBoot(loop,:), xTicks);
    end
    phyDispFHist = sort(phyDispFHist,1);
    medPhyDispFHist = phyDispFHist(round(size(phyDispFHist,1)/2),:);
    CIPhyDispFHist(1,:) = phyDispFHist(round(size(phyDispFHist,1).*0.025),:)-medPhyDispFHist;
    CIPhyDispFHist(2,:) = phyDispFHist(round(size(phyDispFHist,1).*0.975),:)-medPhyDispFHist;
   
    
    bar(haxesBar, [0 xTickLocs 1001] , [ 0 medPhyDispFHist./500 0], 'LineWidth',line_size, 'FaceColor', 'none');
    hold on
    errorbar(haxesBar, xTickLocs, medPhyDispFHist./500, CIPhyDispFHist(1,:)./500, CIPhyDispFHist(2,:)./500,'k.', 'LineWidth',line_size);
    hold off
    set(haxesBar, 'XAxisLocation','top',...
                    'YAxisLocation','right',...
                    'Color','none');
    
    xTicks = xTicks ./ 2;
    set(haxesHeat, 'XTick', xTickLocs);
    set(haxesHeat, 'XTickLabel', num2tex(xTicks));
    set(haxesHeat, 'TickLabelInterpreter', 'Latex');
    set(haxesHeat, 'XGrid', 'on');
    
    set(haxesBar, 'XTick', []); %xTickLocs);
    set(haxesBar, 'XTickLabel', []); %num2tex(xTicks));
    set(haxesBar, 'TickLabelInterpreter', 'Latex');
    set(haxesBar, 'XGrid', 'on')
    yBarTicks = 0:5:20;
    set(haxesBar, 'YTick', yBarTicks);
    set(haxesBar, 'YTickLabel', roundsd((yBarTicks.*500)./sum(h),1));
    set(haxesBar, 'LineWidth', line_size);
    set(haxesBar, 'FontName', 'Helvetica');
    set(haxesBar, 'FontSize', axis_font_size);    
    axis normal
    
    v = axis(haxesHeat);
    axis(haxesBar, v);
    set(haxesBar,'Position', get(haxesHeat,'Position'));
    
%     handles = setTicksTex(haxesHeat);
%     shiftObject(handles.ylabel, 0, -0.1);
%     shiftObject(handles.xlabel, -0.05, 0);
%     shiftObject(handles.title, -0.05, 0);
%     handles = setTicksTex(haxesBar);
%     for loop = 1:numel(handles.xTicks)
%         set(handles.xTicks(loop), 'Visible', 'off');
%     end
%     shiftObject(handles.yTicks, -0.15, 0.0);
%     shiftObject(handles.xlabel, -0.05, 0);
%     shiftObject(handles.title, -0.05, 0);    

    children = get(gcf, 'Children');
    for loop = 1:numel(children)
        if  isa(children(loop),'matlab.graphics.illustration.ColorBar');
            pos = get(children(loop), 'Position');
            pos(1) = pos(1) + 0.035;
            set(children(loop), 'Position', pos);
        end
    end
    
    set(haxesHeat,'Position', get(haxesBar,'Position'));
    
    text(1.025, 0.8, 'Proportion of Responses', 'Rotation', 270, 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');
    text(-0.25,0.975,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    drawnow;
    
    set(haxesHeat,'Position', get(haxesBar,'Position'));    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c012'], plot_size.*[2 1], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c012', '.png']);
    
end

%%
% Figure 13. Phase displacement in radians against position disparity as a 
% function of pixels. The lines that appear suggest a link between phase 
% and position disparity. The central cluster shows correlated binocular 
% components, the left and right clusters show anti-correlated components.
%
% old version
if plot_figure_13
clf

    initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);

    subplot(1,2,1);
    
    physDispF = physDisp;
    shapeDiffF = shapeDiff;

    dispAllowed = isfinite(physDispF) & isfinite(shapeDiffF) & inds;   
    
    %dispSelected = dispAllowed & abs(shapeDiffF) < 2.*pi;
    dispSelected = dispAllowed & abs(physDispF)<10 & abs(shapeDiffF)<10;
    
    small_selection_position = physDispF(dispSelected);
    small_selection_shape = shapeDiffF(dispSelected);
    
    selection = randi(length(small_selection_position),1,10000);
    
    plot(small_selection_position(selection), small_selection_shape(selection), 'k.');
    
    %title('Phase disparity vs. absolute position disparity', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Combined Disparity (pixels)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Residual', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);
    set(gca, 'XTick', -6:2:6);
    set(gca, 'XTickLabel', -3:1:3);
    set(gca, 'XGrid', 'on');
    
    handles = setTicksTex(gca);
    shiftObject(handles.ylabel, -0.025, -0.1);
    shiftObject(handles.xlabel, -0.05, 0);
    shiftObject(handles.title, 0.5, 0);
    
     ratio = get(gca, 'DataAspectRatio');

     text(-0.25,0.975,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
     
    subplot(1,2,2)
    
    
    dispMap = heatmap(physDispF(dispSelected), shapeDiffF(dispSelected), 'cell_scaling','log10', 'ncellx', 1000, 'ncelly', 100);
    
    %title('Phase disparity vs. absolute position disparity', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Combined Disparity (wavelengths)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Residual', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);
    set(gca, 'DataAspectRatio', [ ratio(2) ratio(1) ratio(3)]);
        
    xTicks = -6:1:6;
    xTickLocs = [];
    for loop = 1:numel(xTicks)
        xTickLocs(loop) = find(dispMap.cutoffsX > xTicks(loop),1);
    end
    
    hold on
    

    axis normal
    
    haxesHeat = gca; % handle to axes    
    haxesHeat_pos = get(haxesHeat,'Position'); % store position of first axes
    haxesBar = axes('Position',haxesHeat_pos,...
                    'XAxisLocation','top',...
                    'YAxisLocation','right',...
                    'Color','none'); 
                
    h = hist(physDispF(dispSelected), xTicks);
    % some manual bootstrapping
    physDispFBoot = bootstrap(physDispF(dispSelected), noBootstraps);
    phyDispFHist = [];
    CIPhyDispFHist = [];
    for loop = 1:size(physDispFBoot,1)
        phyDispFHist(loop,:) = hist(physDispFBoot(loop,:), xTicks);
    end
    phyDispFHist = sort(phyDispFHist,1);
    medPhyDispFHist = phyDispFHist(round(size(phyDispFHist,1)/2),:);
    CIPhyDispFHist(1,:) = phyDispFHist(round(size(phyDispFHist,1).*0.025),:)-medPhyDispFHist;
    CIPhyDispFHist(2,:) = phyDispFHist(round(size(phyDispFHist,1).*0.975),:)-medPhyDispFHist;
   
    
    bar(haxesBar, [0 xTickLocs 1001] , [ 0 medPhyDispFHist./500 0], 'LineWidth',line_size, 'FaceColor', 'none');
    hold on
    errorbar(haxesBar, xTickLocs, medPhyDispFHist./500, CIPhyDispFHist(1,:)./500, CIPhyDispFHist(2,:)./500,'k.', 'LineWidth',line_size);
    hold off
    set(haxesBar, 'XAxisLocation','top',...
                    'YAxisLocation','right',...
                    'Color','none');
   
    xTicks = -6:2:6;
    xTickLocs = [];
    for loop = 1:numel(xTicks)
        xTickLocs(loop) = find(dispMap.cutoffsX > xTicks(loop),1);
    end  
    
    xTicks = xTicks ./ 2;
    set(haxesHeat, 'XTick', xTickLocs);
    set(haxesHeat, 'XTickLabel', xTicks);
    set(haxesHeat, 'XGrid', 'on');
     
    set(haxesBar, 'XTick', xTickLocs);
    set(haxesBar, 'XTickLabel', xTicks);
    set(haxesBar, 'XGrid', 'on')
    yBarTicks = 0:5:20;
    set(haxesBar, 'YTick', yBarTicks);
    set(haxesBar, 'YTickLabel', roundsd((yBarTicks.*500)./sum(h),1));
    set(haxesBar, 'LineWidth', line_size);
    set(haxesBar, 'FontName', 'Helvetica');
    set(haxesBar, 'FontSize', axis_font_size);    
    axis normal
    
    v = axis(haxesHeat);
    axis(haxesBar, v);
    
    handles = setTicksTex(haxesHeat);
    shiftObject(handles.ylabel, 0, -0.1);
    shiftObject(handles.xlabel, -0.05, 0);
    shiftObject(handles.title, -0.05, 0);
    handles = setTicksTex(haxesBar);
    for loop = 1:numel(handles.xTicks)
        set(handles.xTicks(loop), 'Visible', 'off');
    end
    shiftObject(handles.yTicks, -0.15, 0.0);
    shiftObject(handles.xlabel, -0.05, 0);
    shiftObject(handles.title, -0.05, 0);    

    text(0.96, 0.25, 'Proportion of Responses', 'Rotation', 90, 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');
    text(-0.25,0.975,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c013'], plot_size.*[2 1], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c013', '.png']);
    
end
%%
% Figure 12. Phase displacement in radians against position disparity as a 
% fraction of wavelength. The lines that appear suggest a link between phase 
% and position disparity. The central cluster shows correlated binocular 
% components, the left and right clusters show anti-correlated components.
%
% old version
if plot_figure_12_old
clf

    initialiseJOVPlot(gca, plot_size.*[2 2], plot_resolution);
    
    subplot(2,1,2)
    
    physDispF = physDisp.*rightFreqICA;

    dispAllowed = isfinite(physDispF) & inds;
    
    q = quantile(abs(physDispF(dispAllowed)), percentile);
    
    %dispSelected = dispAllowed & abs(shapeDiffF) < 2.*pi;
    dispSelected = dispAllowed & abs(physDispF)<5 & rightFreqICA > 0.25;
    
    handle = plotBootstrappedDistribution(bootstrap(physDispF(dispSelected), noBootstraps), 100);

    %hist(physDispF(dispSelected), 200, 'Colour', 'none');
    
    %title('Distribution of combined disparities.', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Combined Disparity (wavelengths)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Proportion', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'XTick', -2:1:2);
    set(gca, 'XTickLabel', -1:0.5:1);
    set(gca, 'XGrid', 'on');
    ticks = get(gca, 'YTick');
    %set(gca, 'YTickLabels', roundd(ticks ./ numel(physDispF(dispSelected)),-2));
    set(gca, 'LineWidth', line_size);
    set(handle, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);    
    
%     handles = setTicksTex(gca);
%     shiftObject(handles.ylabel, -0.01, -0.0);
%     shiftObject(handles.yTicks, -0.00, -0.0);
%     shiftObject(handles.xlabel, -0.1, 0);
%     shiftObject(handles.title, -0.1, -0.02);

    text(-0.15, 1.1,'B', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    subplot(2,1,1)
    
    physDispF = physDisp;

    dispAllowed = isfinite(physDispF) & inds;
        
    %dispSelected = dispAllowed & abs(shapeDiffF) < 2.*pi;
    dispSelected = dispAllowed & abs(physDispF)<7;
    
    handle = plotBootstrappedDistribution(bootstrap(physDispF(dispSelected), noBootstraps), 100);

    %hist(physDispF(dispSelected), 200, 'Colour', 'none');
    
    %title('Distribution of combined disparities.', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Combined Disparity (pixels)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Proportion', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'XTick', -4:1:4);
    set(gca, 'XTickLabel', -2:0.5:2);
    set(gca, 'XGrid', 'on');
    ticks = get(gca, 'YTick');
    %set(gca, 'YTickLabels', roundd(ticks ./ numel(physDispF(dispSelected)),-2));
    set(gca, 'LineWidth', line_size);
    set(handle, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);    
    
%     handles = setTicksTex(gca);
%     shiftObject(handles.ylabel, -0.01, 0.07);
%     shiftObject(handles.yTicks, -0.00, -0.0);
%     shiftObject(handles.xlabel, -0.1, 0);
%     shiftObject(handles.title, -0.1, 0);
%     
    text(-0.15,1.1,'A', 'FontName','Helvetica','FontSize',title_font_size,'Units','normalized', 'Interpreter','Latex');        
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c012'], plot_size.*[2 1], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c012', '.png']);
    
end

%%
% Figure 13. Phase displacement in radians against position disparity as a 
% fraction of wavelength. The lines that appear suggest a link between phase 
% and position disparity. The central cluster shows correlated binocular 
% components, the left and right clusters show anti-correlated components.
%
% old version
if plot_figure_13_old
clf

    initialiseJOVPlot(gca, plot_size.*[2 1], plot_resolution);
    
    physDispF = physDisp;

    dispAllowed = isfinite(physDispF) & inds;
        
    %dispSelected = dispAllowed & abs(shapeDiffF) < 2.*pi;
    dispSelected = dispAllowed & abs(physDispF)<7;
    
    handle = plotBootstrappedDistribution(bootstrap(physDispF(dispSelected), noBootstraps), 100);

    %hist(physDispF(dispSelected), 200, 'Colour', 'none');
    
    title('Distribution of combined disparities.', 'FontName', 'Helvetica', 'FontSize', title_font_size);
    xlabel('Combined Disparity (pixels)', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    ylabel('Proportion', 'FontName', 'Helvetica', 'FontSize', label_font_size);
    set(gca, 'XTick', -4:1:4);
    set(gca, 'XTickLabel', -2:0.5:2);
    set(gca, 'XGrid', 'on');
    ticks = get(gca, 'YTick');
    %set(gca, 'YTickLabels', roundd(ticks ./ numel(physDispF(dispSelected)),-2));
    set(gca, 'LineWidth', line_size);
    set(handle, 'LineWidth', line_size);
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', axis_font_size);    
    
    handles = setTicksTex(gca);
    shiftObject(handles.ylabel, -0.01, -0.0);
    shiftObject(handles.yTicks, -0.00, -0.0);
    shiftObject(handles.xlabel, -0.1, 0);
    shiftObject(handles.title, -0.1, 0);
    
    saveJOVPlot(gcf, [ plotDirectory, jpre ,'4c013_old'], plot_size.*[2 1], plot_resolution);
    print(gcf,'-dpng',sprintf('-r%d-painters',150), [ plotDirectory, jpre ,'4c013_old', '.png']);
    
end

if do_KS_test_combined_disparity
    % calculate correlation in pixel space between phase and position
    % disparities
    phaseDiffICA = (leftPhaseICA - rightPhaseICA);
    %phaseDiffICA(:,:,2) = (2*pi) - abs(rightPhaseICA-leftPhaseICA);
    %phaseDiffICA = min(phaseDiffICA,[], 3);

    phaseDispPixels = phaseDiffICA./(rightFreqICA .*pi);
    selected = inds & isfinite(disp) & isfinite(phaseDispPixels) & abs(phaseDispPixels)<pi/2;
    
    [ r, p] = corr(phaseDispPixels(selected), disp(selected))
    
    physDispF = physDisp.*rightFreqICA;

    dispAllowed = isfinite(physDispF) & inds;
    
    dispSelected = dispAllowed & abs(physDispF)<3;
    
    hist(physDispF(dispSelected), -3:1:3);
    b = hist(physDispF(dispSelected), -3:1:3);
    
    data = physDispF(dispSelected);
    data = data(abs(mod(data,1))<0.1);
    [H,P,KSSTAT] = kstest(data);
    
    fprintf('KS test for normality of discrete (peaks only)\n combined disparity distribution H=%d , P=%f, KSstat = %f\n', H,P,KSSTAT);
    
    [H,P,KSTAT,CRITVAL]  = lillietest(data);
    fprintf('Lillie test for normality of discrete (peaks only)\n combined disparity distribution H=%d , P=%f, Kstat = %f, CRITVAL=%f\n', H,P,KSTAT,CRITVAL);
end

if do_circ_stats
        angleDisp = atan2(vdisp, hdisp);
        %angleDisp(angleDisp<-pi/2) = angleDisp(angleDisp<-pi/2) + pi;
    %angleDisp(angleDisp>pi/2) = angleDisp(angleDisp>pi/2) - pi;

    angleDisp2 = [ angleDisp angleDisp ];
    angleSelected = ~isnan(angleDisp);
    orientations = [ leftAnglesICA rightAnglesICA ];
    orientationSelected = isfinite(leftAnglesICA) & isfinite(rightAnglesICA);
    combinedSelected = inds & angleSelected & orientationSelected;
        
    circ_otest(angleDisp(combinedSelected(:)))
end

if do_bandwidth_stats
    % rotate the band
    ratio = [ leftSigmaXICA.*leftFreqICA./2 rightSigmaXICA.*rightFreqICA./2 leftSigmaYICA.*leftFreqICA./2 rightSigmaYICA.*rightFreqICA./2 ];
    c = sqrt(log(2)/2)/pi;
    freqBandwidth = log2( (ratio+c)./(ratio-c));

    
    inds2 = [ inds inds inds inds];
%     subplot(1,3,1)
    hist(freqBandwidth(inds2),100);
%     subplot(1,3,2)
%     hist(ratio(inds2),100);
%     subplot(1,3,3)
%     hist(c.*((2.^bandwidth(inds2)+1)./(2.^bandwidth(inds2)-1)),100);
    b = bootstrp(200,@median, bandwidth(isfinite(bandwidth)));
    b = sort(b);
    b(ceil(b.*0.025))
    b(ceil(b.*0.975))
end