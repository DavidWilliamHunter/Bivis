
reset(gcf)
reset(gca)

plotDirectory = 'E:\Users\Dave\Google Drive\binocular\paper1\figures\scaled\';
dataDirectory = 'E:\documents\MATLAB\binocular\scale2\';
runName = 'arcminRes';

scaleNames = { '0.1', '0.125', '0.11111', '0.14286', '0.16667', '0.2', ...
    '0.25', '0.33333'};
scalesNum = 1./(10:-1:1);
scalesTex = cell(1,10);
for loop = 1:10
    scalesTex{loop} = num2str(11-loop);
end
scalesTex{1} = sprintf('%s arcmin per pixel', scalesTex{1});

noBins = 100;
noBootstraps = 200;
percentile = 0.975;

unit = 'arcmin';

names = cell(length(scaleNames),2);
for scale = 1:length(scaleNames)
    names{scale,1} = [ dataDirectory , 'scaleICA_Fitted_', scaleNames{scale}, '.mat'];
    names{scale,2} = [ dataDirectory , 'scaleICA_', scaleNames{scale}, '.mat'];
end

colours = colourSequence('orange', length(scaleNames));

for outerloop = 1:length(names)
    names{outerloop,:}
    clear('gabors');
    load(names{outerloop,1});
    load(names{outerloop,2});
    
    correctedGabors = convertAbsGabor2Gabor(gabors, patchSize);
    leftPhaseICA = mod(correctedGabors.phi(:,1), 2*pi);
    rightPhaseICA = mod(correctedGabors.phi(:,2), 2*pi);
    leftFreqICA = correctedGabors.freq(:,1).*scalesNum(outerloop);
    rightFreqICA = correctedGabors.freq(:,2).*scalesNum(outerloop);
    leftAnglesICA = correctedGabors.theta(:,1);
    rightAnglesICA = correctedGabors.theta(:,2);
    
    leftXICA = correctedGabors.xc(:,1);
    rightXICA = correctedGabors.xc(:,2);
    leftYICA = correctedGabors.yc(:,1);
    rightYICA = correctedGabors.yc(:,2);
    
    leftSICA = correctedGabors.s(:,1);
    rightSICA = correctedGabors.s(:,2);
    
    smoothLeftFreq(outerloop,:) = leftFreqICA;
    smoothRightFreq(outerloop,:) = rightFreqICA;
        
    % correct for image scale
    disp = gaborDistance(correctedGabors)./scalesNum(outerloop);
    
    % bootstrap
    noSamples = length(leftPhaseICA);
    
    %% 
    % generate distributions
    
    Lratio = leftSICA ./ rightSICA;
    Lratio(:,:,2) = rightSICA ./ leftSICA;
    Lratio = min((Lratio), [], 3);   
    Lselected = true; %(leftSICA>=1 & rightSICA>=1);
    proportionMonocular_ArcMinutes(outerloop,:) = sum(bootstrap(Lratio, noBootstraps) < 1/10,2)./numel(Lratio);
    
    inds = leftXICA > 0 & leftXICA < 25 & rightXICA > 0 & rightXICA < 25 &...
        leftYICA > 0 & leftYICA < 25 & rightYICA > 0 & rightYICA < 25 & ...
        isfinite(leftXICA) & isfinite(leftYICA) & isfinite(rightXICA) & isfinite(rightYICA) & Lselected;
    dispAllowed = inds & ~isnan(disp);
    q = quantile(disp(dispAllowed), percentile);
    dispSelected = isfinite(disp) & abs(disp) < q & inds;
    
    [~,dispBins_ArcMinutes{outerloop}, dispDistributions_ArcMinutes{outerloop},dispCIs_ArcMinutes{outerloop}]= plotBootstrappedDistribution(bootstrap(disp(dispSelected), noBootstraps), -20:1.6:20);
    
    [~,dispBinsC_ArcMinutes{outerloop}, dispDistributionsC_ArcMinutes{outerloop},dispCIsC_ArcMinutes{outerloop}]= plotBootstrappedDistribution(bootstrap(disp(dispSelected), noBootstraps), -20:1.6:20, 'plot_function', 'histc');    

        
    phaseDiffICA = abs(leftPhaseICA - rightPhaseICA);
    phaseDiffICA(:,:,2) = (2*pi) - abs(rightPhaseICA-leftPhaseICA);
    phaseDiffICA = min(phaseDiffICA,[], 3);
    phaseSelected = isfinite(phaseDiffICA) & inds;
        
    [~,phaseDiffBins_ArcMinutes{outerloop}, phaseDiffDistributions_ArcMinutes{outerloop}, phaseDiffCIs_ArcMinutes{outerloop}] = plotBootstrappedDistribution(bootstrap(phaseDiffICA(phaseSelected), noBootstraps), noBins);
    
    angleDiffICA = abs(leftAnglesICA - rightAnglesICA);
    angleDiffICA(:,:,2) = (2*pi) - abs(rightAnglesICA-leftAnglesICA);
    angleDiffICA = min(angleDiffICA,[], 3);
    angleSelected = isfinite(angleDiffICA) & inds;
    
    [~,angleDiffBins_ArcMinutes{outerloop}, angleDiffDistributions_ArcMinutes{outerloop}, angleDiffCIs_ArcMinutes{outerloop}] = plotBootstrappedDistribution(bootstrap(angleDiffICA(angleSelected), noBootstraps), noBins);
    
    angleSelected = angleDiffICA < pi/8;%  & inds;% & isfinite(angleDiffICA);
    [~,angleDiffZoomBins_ArcMinutes{outerloop}, angleDiffZoomDistributions_ArcMinutes{outerloop}, angleDiffZoomCIs_ArcMinutes{outerloop}] = plotBootstrappedDistribution(bootstrap(angleDiffICA(angleSelected), noBootstraps), noBins);
    
    temp = ([leftFreqICA ; rightFreqICA]);
    logSelected = isfinite(temp)  & [inds ; inds];% & abs(temp)>0;
    [~,freqBins_ArcMinutes{outerloop}, freqDistributions_ArcMinutes{outerloop}, freqCIs_ArcMinutes{outerloop}] = plotBootstrappedDistribution(bootstrap(temp(logSelected), noBootstraps), 0:0.002:0.2);
    
    
    temp = log([leftFreqICA ; rightFreqICA]);
    logSelected = isfinite(temp)  & [inds ; inds];% & abs(temp)>0;
    [~,logFreqBins_ArcMinutes{outerloop}, logFreqDistributions_ArcMinutes{outerloop}, logFreqCIs_ArcMinutes{outerloop}] = plotBootstrappedDistribution(bootstrap(temp(logSelected), noBootstraps), -6:0.25:0);
    
    
    xdisp = (leftXICA - rightXICA)./scalesNum(outerloop);
    ydisp = (leftYICA - rightYICA)./scalesNum(outerloop);
    
    dispAllowed = isfinite(xdisp) & inds;
    q = quantile(xdisp(dispAllowed), percentile);
    dispSelected = isfinite(xdisp) & abs(xdisp) < q & inds;

    [~,xdispBins_ArcMinutes{outerloop}, xdispDistributions_ArcMinutes{outerloop}, xdispCIs_ArcMinutes{outerloop}] = plotBootstrappedDistribution(bootstrap(xdisp(dispSelected), noBootstraps), -15:1.2:15);
    
    dispAllowed = isfinite(ydisp) & inds;
    q = quantile(ydisp(dispAllowed), percentile);
    dispSelected = isfinite(ydisp) & abs(ydisp) < q & inds;    
    [~,ydispBins_ArcMinutes{outerloop}, ydispDistributions_ArcMinutes{outerloop}, ydispCIs_ArcMinutes{outerloop}] = plotBootstrappedDistribution(bootstrap(ydisp(dispSelected), noBootstraps), -15:1.2:15);

    iSelected = isfinite(leftSICA) & isfinite(rightSICA) & isfinite(Lratio) & inds;
    [~,intensityRatioBins_ArcMinutes{outerloop}, intensityRatioDistributions_ArcMinutes{outerloop}, intensityRatioDispCIs_ArcMinutes{outerloop}] = ...
        plotBootstrappedDistribution(bootstrap(Lratio(iSelected), noBootstraps), 0:0.02:1);    
    
    totalInds(outerloop,:) = inds;
end

    for bootloop = 1:noBootstraps
        inds = round(rand(1,noSamples).*(noSamples-1)+1);
        
        smoothFreqBootLeft(bootloop,:) = smoothLeftFreq(inds);
        smoothFreqBootRight(bootloop,:) = smoothRightFreq(inds);
    end
    
    
    temp = ([smoothLeftFreq ; smoothRightFreq]);
    logSelected = isfinite(temp) & [totalInds ; totalInds];% & abs(temp)>0;
    [~,smoothFreqBins_ArcMinutes, smoothFreqDistributions_ArcMinutes, smoothFreqCIs_ArcMinutes] = plotBootstrappedDistribution(bootstrap(temp(logSelected),noBootstraps), 0:0.002:0.2);
    
    
    temp = log([smoothLeftFreq ; smoothRightFreq]);
    logSelected = isfinite(temp) & [totalInds ; totalInds];% & abs(temp)>0;
    [~,smoothLogFreqBins_ArcMinutes, smoothLogFreqDistributions_ArcMinutes, smoothLogFreqCIs_ArcMinutes] = plotBootstrappedDistribution(bootstrap(temp(logSelected),noBootstraps), -6:0.1:0);
        
%thePlottingBit 