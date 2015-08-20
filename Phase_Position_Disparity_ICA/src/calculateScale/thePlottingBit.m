    %%
reset(gcf);
clf
for loop = 1:length(names)
    dispCIs{loop} = dispCIs{loop}./sum(dispDistributions{loop}(:));
    dispDistributions{loop} = dispDistributions{loop}./sum(dispDistributions{loop}(:));
    h(loop) = plot(dispBins{loop}(2:end-1), dispDistributions{loop}(2:end-1), 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(dispBins{loop}(2:end-1), dispCIs{loop}(:,2:end-1), 'Color', colours(loop,:),'LineWidth',1);
end
stepSize = dispBins{1}(2) - dispBins{1}(1);
[maxVal, ind] = max(dispCIs{1}(2,2:end-1));
bootloop = 1;
for loop = 1:length(dispCIs)
    [tempMaxVal, tempInd] = max(dispCIs{loop}(2,2:end-1));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
    
%[maxVal, ind] = max(freqDistributions{:}(1,:));
pos = dispBins{bootloop}(ind+1);
maxVal = maxVal+0.01;
plot([stepSize stepSize], [0 maxVal], 'k:');
plot([-stepSize -stepSize], [0 maxVal], 'k:');
plot([0 0], [0 maxVal], 'k--');

axis tight
title('Distribution of position disparities');
ylabel('Proportion of components');
xlabel(['Position disparity in ' unit]);
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICADisp_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICADisp_', runName, '.fig'], 'fig');

  %%
reset(gcf);
clf
for loop = 1:length(names)
    dispCIsC{loop} = dispCIsC{loop}./(dispDistributionsC{loop}(end));
    dispDistributionsC{loop} = dispDistributionsC{loop}./(dispDistributionsC{loop}(end));
    h(loop) = plot(dispBinsC{loop}(2:end-1), dispDistributionsC{loop}(2:end-1), 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(dispBinsC{loop}(2:end-1), dispCIsC{loop}(:,2:end-1), 'Color', colours(loop,:),'LineWidth',1);
end
stepSize = dispBinsC{1}(2) - dispBinsC{1}(1);
[maxVal, ind] = max(dispCIsC{1}(2,2:end-1));
bootloop = 1;
for loop = 1:length(dispCIsC)
    [tempMaxVal, tempInd] = max(dispCIsC{loop}(2,2:end-1));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
    
%[maxVal, ind] = max(freqDistributions{:}(1,:));
pos = dispBinsC{bootloop}(ind+1);
maxVal = maxVal+0.01;
plot([stepSize stepSize], [0 maxVal], 'k:');
plot([-stepSize -stepSize], [0 maxVal], 'k:');
plot([0 0], [0 maxVal], 'k--');

axis tight
title('Cumulative distribution of position disparities');
ylabel('Proportion of components');
xlabel(['Position disparity in ' unit]);
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICACDisp_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICACDisp_', runName, '.fig'], 'fig');

%%

clf
for loop = 1:length(names)
    phaseDiffCIs{loop} = phaseDiffCIs{loop}./sum(phaseDiffDistributions{loop}(:));
    phaseDiffDistributions{loop} = phaseDiffDistributions{loop}./sum(phaseDiffDistributions{loop}(:));
    h(loop) = plot(phaseDiffBins{loop}, phaseDiffDistributions{loop}, 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(phaseDiffBins{loop}, phaseDiffCIs{loop}, 'Color', colours(loop,:),'LineWidth',1);
end
title('Phase Differences between pairs (ICA)');
set(gca,'XTick',0:pi/2:pi)
set(gca,'YTick',0:0.05:0.2)
%set(gca,'XTickLabel',{'0','pi/2','pi'})
xlabel('Phase difference (Radians)');
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
props.FontSize = 12;
setTicksTex(0:pi/2:pi, num2tex(0:pi/2:pi,'\pi',pi), props);

set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICAPhaseDiff_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAPhaseDiff_', runName, '.fig'], 'fig');

%%
clf
for loop = 1:length(names)
    angleDiffCIs{loop} = angleDiffCIs{loop}./sum(angleDiffDistributions{loop}(:));
    angleDiffDistributions{loop} = angleDiffDistributions{loop}./sum(angleDiffDistributions{loop}(:));
    h(loop) = plot(angleDiffBins{loop}, angleDiffDistributions{loop}, 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(angleDiffBins{loop}, angleDiffCIs{loop}, 'Color', colours(loop,:),'LineWidth',1);
end
%axis tight
title('Angle Differences between pairs (ICA)');
set(gca,'XTick',0:pi/2:pi)
set(gca,'XTickLabel',{'0','pi/2','pi'})
xlabel('Angle difference (Radians)');
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
setTicksTex(0:pi/2:pi, num2tex(0:pi/2:pi,'\pi',pi), props);
saveas(gcf, [ plotDirectory, 'ICAAngleDiff_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAAngleDiff_', runName, '.fig'], 'fig');

%%
clf
for loop = 1:length(names)
    angleDiffZoomCIs{loop} = angleDiffZoomCIs{loop}./sum(angleDiffZoomDistributions{loop}(:));
    angleDiffZoomDistributions{loop} = angleDiffZoomDistributions{loop}./sum(angleDiffZoomDistributions{loop}(:));
    h(loop) = plot(angleDiffZoomBins{loop}, angleDiffZoomDistributions{loop}, 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(angleDiffZoomBins{loop}, angleDiffZoomCIs{loop}, 'Color', colours(loop,:),'LineWidth',1);
end
%axis tight
title('Angle Differences between pairs (ICA)');
set(gca,'XTick',0:pi/8:pi/4)
set(gca,'XTickLabel',{'0','pi/8','pi/4'})
xlabel('Phase difference (Radians)');
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
setTicksTex(0:pi/16:pi/8, num2tex(0:pi/16:pi/8,'\pi',pi), props);
saveas(gcf, [ plotDirectory, 'ICAAngleZoomDiff_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAAngleZoomDiff_', runName, '.fig'], 'fig');

%%
clf
for loop = 1:length(names)
    freqCIs{loop} = freqCIs{loop}./sum(freqDistributions{loop}(:));
    freqDistributions{loop} = freqDistributions{loop}./sum(freqDistributions{loop}(:));
    h(loop) = plot(freqBins{loop}, freqDistributions{loop}, 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(freqBins{loop}, freqCIs{loop}, 'Color', colours(loop,:),'LineWidth',1);
end
stepSize = freqBins{1}(2) - freqBins{1}(1);
[maxVal, ind] = max(freqCIs{1}(2,:));
bootloop = 1;
for loop = 1:length(freqCIs)
    [tempMaxVal, tempInd] = max(freqCIs{loop}(2,:));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
    
%[maxVal, ind] = max(freqDistributions{:}(1,:));
pos = freqBins{bootloop}(ind);
maxVal = maxVal+0.01;
plot([stepSize stepSize]+pos, [0 maxVal], 'k:');
plot([-stepSize -stepSize]+pos, [0 maxVal], 'k:');
plot([0 0]+pos, [0 maxVal], 'k--');
%plot([0.5 0.5], [0 maxVal], 'k-.');

axis tight
title('Frequency distributions');
%set(gca,'XTick',0:pi/2:pi)
%set(gca,'XTickLabel',{'0','pi/2','pi'})
xlabel(['Wavelength, cycles per ' unit]);
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICAFreq_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAFreq_', runName, '.fig'], 'fig');


    %%
hold on
    smoothFreqCIs = smoothFreqCIs./sum(smoothFreqDistributions(:));
    smoothFreqDistributions = smoothFreqDistributions./sum(smoothFreqDistributions);
    h(length(h)+1) = plot(smoothFreqBins, smoothFreqDistributions, 'Color', [ 1 0 0 ],'LineWidth',3, 'DisplayName', 'combined');
    hold on
    plot(smoothFreqBins, smoothFreqCIs, 'Color', [ 0.8 0 0 ],'LineWidth',1);

stepSize = smoothFreqBins(2) - smoothFreqBins(1);
[maxVal, ind] = max(smoothFreqCIs(2,:));
pos = smoothFreqBins(ind);
maxVal = maxVal+0.01;
plot([stepSize stepSize]+pos, [0 maxVal], 'k:');
plot([-stepSize -stepSize]+pos, [0 maxVal], 'k:');
plot([0 0]+pos, [0 maxVal], 'k--');

axis tight
title('Frequency distributions');
%set(gca,'XTick',0:pi/2:pi)
%set(gca,'XTickLabel',{'0','pi/2','pi'})
xlabel(['Wavelength, cycles per ' unit]);
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICASmoothFreq_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICASmoothFreq_', runName, '.fig'], 'fig');
    
%%
h = [];
clf
for loop = 1:length(names)
    logFreqCIs{loop} = logFreqCIs{loop}./sum(logFreqDistributions{loop}(:));
    logFreqDistributions{loop} = logFreqDistributions{loop}./sum(logFreqDistributions{loop}(:));
    h(loop) = plot(logFreqBins{loop}, logFreqDistributions{loop}, 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(logFreqBins{loop}, logFreqCIs{loop}, 'Color', colours(loop,:),'LineWidth',1);
end
stepSize = logFreqBins{1}(2) - logFreqBins{1}(1);
[maxVal, ind] = max(logFreqCIs{1}(2,:));
bootloop = 1;
for loop = 1:length(logFreqCIs)
    [tempMaxVal, tempInd] = max(logFreqCIs{loop}(2,:));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
    
%[maxVal, ind] = max(freqDistributions{:}(1,:));
pos = logFreqBins{bootloop}(ind);
maxVal = maxVal+0.01;
plot([stepSize +stepSize]+pos, [0 maxVal], 'k:');
plot([-stepSize -stepSize]+pos, [0 maxVal], 'k:');
plot([0 0]+pos, [0 maxVal], 'k--');

axis tight
title('Log frequency distributions');
%set(gca,'XTick',0:pi/2:pi)
%set(gca,'XTickLabel',{'0','pi/2','pi'})
xlabel(['Wavelength, log cycles per ' unit]);
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICALogFreq_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICALogFreq_', runName, '.fig'], 'fig');


    %%
hold on
    smoothLogFreqCIs = smoothLogFreqCIs./sum(smoothLogFreqDistributions(:));
    smoothLogFreqDistributions = smoothLogFreqDistributions./sum(smoothLogFreqDistributions);
    h(length(h)+1) = plot(smoothLogFreqBins, smoothLogFreqDistributions, 'Color', [ 1 0 0 ],'LineWidth',3, 'DisplayName', 'combined');
    hold on
    plot(smoothLogFreqBins, smoothLogFreqCIs, 'Color', [ 0.8 0 0 ],'LineWidth',1);

stepSize = smoothLogFreqBins(2) - smoothLogFreqBins(1);
[maxVal, ind] = max(smoothLogFreqCIs(2,:));
pos = smoothLogFreqBins(ind);
maxVal = maxVal+0.01;
plot([stepSize +stepSize], [0 maxVal], 'k:');
plot([-stepSize -stepSize], [0 maxVal], 'k:');
plot([0 0], [0 maxVal], 'k--');

axis tight
title('Log frequency distributions');
%set(gca,'XTick',0:pi/2:pi)
%set(gca,'XTickLabel',{'0','pi/2','pi'})
xlabel(['Wavelength, log cycles per ' unit]);
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICASmoothLogFreq_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICASmoothLogFreq_', runName, '.fig'], 'fig');
    

%%
h = [];
clf
for loop = 1:length(names)
    xdispCIs{loop} = xdispCIs{loop}./sum(xdispDistributions{loop}(:));
    xdispDistributions{loop} = xdispDistributions{loop}./sum(xdispDistributions{loop}(:));
    h(loop) = plot(xdispBins{loop}(2:end-1), xdispDistributions{loop}(2:end-1), 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(xdispBins{loop}(2:end-1), xdispCIs{loop}(:,2:end-1), 'Color', colours(loop,:),'LineWidth',1);
end
stepSize = xdispBins{1}(2) - xdispBins{1}(1);
[maxVal, ind] = max(xdispCIs{1}(2,2:end-1));
bootloop = 1;
for loop = 1:length(xdispCIs)
    [tempMaxVal, tempInd] = max(xdispCIs{loop}(2,2:end-1));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
pos = xdispBins{bootloop}(ind+1);
maxVal = maxVal+0.01;

plot([stepSize stepSize], [0 maxVal], 'k:');
plot([-stepSize -stepSize], [0 maxVal], 'k:');
plot([0 0], [0 maxVal], 'k--');
axis tight
title('Distributions of horizontal position disparities');
set(gca,'XTick',unique([-15:1:15 pos]));
xlabel(['Horizontal Position Disparity (' unit ')']);
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); 
set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICAHPosDisp_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAHPosDisp_', runName, '.fig'], 'fig');

%%
clf
for loop = 1:length(names)
    ydispCIs{loop} = ydispCIs{loop}./sum(ydispDistributions{loop}(:));
    ydispDistributions{loop} = ydispDistributions{loop}./sum(ydispDistributions{loop}(:));
    h(loop) = plot(ydispBins{loop}(2:end-1), ydispDistributions{loop}(2:end-1), 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(ydispBins{loop}(2:end-1), ydispCIs{loop}(:,2:end-1), 'Color', colours(loop,:),'LineWidth',1);
end
stepSize = ydispBins{1}(2) - ydispBins{1}(1);
[maxVal, ind] = max(ydispCIs{1}(2,2:end-1));
bootloop = 1;
for loop = 1:length(ydispCIs)
    [tempMaxVal, tempInd] = max(ydispCIs{loop}(2,2:end-1));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
pos = ydispBins{bootloop}(ind+1);
maxVal = maxVal+0.01;

plot([stepSize stepSize], [0 maxVal], 'k:');
plot([-stepSize -stepSize], [0 maxVal], 'k:');
plot([0 0], [0 maxVal], 'k--');
hold on
axis tight
title('Distributions of vertical position disparities.');
set(gca,'XTick',unique([-15:2:15, pos]));
xlabel(['Vertical Position Disparity (' unit ')']);
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); set(l,'Interpreter','latex'); set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICAVPosDisp_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAVPosDisp_', runName, '.fig'], 'fig');

%%
% Plot intensity ratios
clf
h=[];
for loop = 1:length(names)
    intensityRatioDispCIs{loop} = intensityRatioDispCIs{loop}./sum(intensityRatioDistributions{loop}(:));
    intensityRatioDistributions{loop} = intensityRatioDistributions{loop}./sum(intensityRatioDistributions{loop}(:));
    h(loop) = plot(intensityRatioBins{loop}(1:end-1), intensityRatioDistributions{loop}(1:end-1), 'Color', colours(loop,:),'LineWidth',3, 'DisplayName', scalesTex{loop});
    hold on
    plot(intensityRatioBins{loop}(1:end-1), intensityRatioDispCIs{loop}(:,1:end-1), 'Color', colours(loop,:),'LineWidth',1);
end
stepSize = intensityRatioBins{1}(2) - intensityRatioBins{1}(1);
[maxVal, ind] = max(intensityRatioDispCIs{1}(2,:));
bootloop = 1;
for loop = 1:length(intensityRatioDispCIs)
    [tempMaxVal, tempInd] = max(intensityRatioDispCIs{loop}(2,:));
    if tempMaxVal > maxVal
        ind = tempInd;
        maxVal = tempMaxVal;
        bootloop = loop;
    end
end
[maxVal, ind] = max(intensityRatioDispCIs{1}(2,:));
pos = intensityRatioBins{bootloop}(ind);
maxVal = maxVal+0.01;

plot([stepSize stepSize]+pos, [0 maxVal], 'k:');
plot([-stepSize -stepSize]+pos, [0 maxVal], 'k:');
plot([0 0]+pos, [0 maxVal], 'k--');

hold on
axis tight
title('Distributions of left/right intensity ratio.');
%set(gca,'XTick',-5:5);
xlabel('Intensity ratio');
ylabel('Proportion of components');
l = legend(h, 'Location', 'Best'); set(l,'Interpreter','latex')
set(l,'Interpreter','latex');
set(l,'FontSize',8);
v = get(l,'title');
set(v,'string','Scale-arcmin per pixel');
saveas(gcf, [ plotDirectory, 'ICAIlluminanceRatioHist_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAIlluminanceRatioHist_', runName, '.fig'], 'fig');

%%
% Plot monocular proportions bar-chart
clf
sortedProportionMonocular = sort(proportionMonocular',1);
mProportionMonocular = median(sortedProportionMonocular,1);
ciProportionMonocular = [ sortedProportionMonocular(ceil(noBootstraps.*0.025),:) ; ...
        sortedProportionMonocular(ceil(noBootstraps.*0.975),:)];
marginProportionMonocular = [mProportionMonocular - ciProportionMonocular(1,:) ;...
        ciProportionMonocular(2,:) - mProportionMonocular ];
        
handle = plotBarsWithErrors(1:length(scaleNames),mProportionMonocular, marginProportionMonocular);
title('Proportion of Monocular components across scales', 'FontSize', 16);
xlabel('Image scale (arcmin per pixel)')
ylabel('Proportion of monocular components');
props.FontSize = 12;
set(gca,'xticklabel', 10:-1:1)
setTicksTex(props);
saveas(gcf, [ plotDirectory, 'ICAMonocularPropsHist_', runName, '.png'], 'png');
saveas(gcf, [ plotDirectory, 'ICAMonocularPropsHist_', runName, '.fig'], 'fig');


%     distribution.sorted_map = sort(distribution.map, 1);
%     distribution.median = median(distribution.sorted_map,1);
%     distribution.CI = [ distribution.sorted_map(ceil(parameters.noBootstraps.*0.025),:) ; ...
%         distribution.sorted_map(ceil(parameters.noBootstraps.*0.975),:)];
%     distribution.margin = [distribution.median - distribution.CI(1,:) ;...
%         distribution.CI(2,:) - distribution.median ];
%     
%         distribution = mergeStructs(parameters, distribution);   