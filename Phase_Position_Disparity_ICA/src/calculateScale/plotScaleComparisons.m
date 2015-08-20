reset(gcf)
reset(gca)

plotDirectory = 'E:\Users\Dave\Google Drive\binocular\paper1\figures\scaled\';
dataDirectory = 'E:\documents\MATLAB\binocular\scale2\';
runName = 'combinedRes';

scaleNames = { '0.1', '0.125', '0.11111', '0.14286', '0.16667', '0.2', ...
    '0.25', '0.33333'};
scalesNum = (10:-1:1);
scalesTex = cell(1,10);
for loop = 1:10
    scalesTex{loop} = num2str(11-loop);
end
scalesTex{1} = sprintf('%s arcmin per pixel', scalesTex{1});

noBins = 100;
noBootstraps = 200;
percentile = 0.975;

unit = 'pixels';

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
    leftFreqICA = correctedGabors.freq(:,1);
    rightFreqICA = correctedGabors.freq(:,2);
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
    disp = gaborDistance(correctedGabors);
    
    % bootstrap
    noSamples = length(leftPhaseICA);
    
    %% 
    % generate distributions    
    
    Lratio = leftSICA ./ rightSICA;
    Lratio(:,:,2) = rightSICA ./ leftSICA;
    Lratio = min((Lratio), [], 3);   
    Lselected = (leftSICA>=1 & rightSICA>=1);
    proportionMonocular_Pixels(outerloop,:) = sum(bootstrap(Lratio, noBootstraps) < 1/10,2)./numel(Lratio);
    
    inds = leftXICA > 0 & leftXICA < 25 & rightXICA > 0 & rightXICA < 25 &...
        leftYICA > 0 & leftYICA < 25 & rightYICA > 0 & rightYICA < 25 & ...
        isfinite(leftXICA) & isfinite(leftYICA) & isfinite(rightXICA) & isfinite(rightYICA) & Lselected;
    dispAllowed = inds & ~isnan(disp);
    q = quantile(disp(dispAllowed), percentile);
    dispSelected = isfinite(disp) & abs(disp) < q & inds;    
    [~,dispBins_Pixels{outerloop}, dispDistributions_Pixels{outerloop},dispCIs_Pixels{outerloop}]= plotBootstrappedDistribution(bootstrap(disp(dispSelected), noBootstraps), -2:0.16:2);
    
    [~,dispBinsC_Pixels{outerloop}, dispDistributionsC_Pixels{outerloop},dispCIsC_Pixels{outerloop}]= plotBootstrappedDistribution(bootstrap(disp(dispSelected), noBootstraps), -2:0.16:2, 'plot_function', 'histc');    
    
    phaseDiffICA = abs(leftPhaseICA - rightPhaseICA);
    phaseDiffICA(:,:,2) = (2*pi) - abs(rightPhaseICA-leftPhaseICA);
    phaseDiffICA = min(phaseDiffICA,[], 3);
    
    [~,phaseDiffBins_Pixels{outerloop}, phaseDiffDistributions_Pixels{outerloop}, phaseDiffCIs_Pixels{outerloop}] = plotBootstrappedDistribution(bootstrap(phaseDiffICA(Lselected), noBootstraps), noBins);
    
    angleDiffICA = abs(leftAnglesICA - rightAnglesICA);
    angleDiffICA(:,:,2) = (2*pi) - abs(rightAnglesICA-leftAnglesICA);
    angleDiffICA = min(angleDiffICA,[], 3);
    
    [~,angleDiffBins_Pixels{outerloop}, angleDiffDistributions_Pixels{outerloop}, angleDiffCIs_Pixels{outerloop}] = plotBootstrappedDistribution(bootstrap(angleDiffICA(Lselected), noBootstraps), noBins);
    
    selected = angleDiffICA < pi/4  & Lselected;% & isfinite(angleDiffICA);
    [~,angleDiffZoomBins_Pixels{outerloop}, angleDiffZoomDistributions_Pixels{outerloop}, angleDiffZoomCIs_Pixels{outerloop}] = plotBootstrappedDistribution(bootstrap(angleDiffICA(selected), noBootstraps), noBins);
    
    temp = ([leftFreqICA ; rightFreqICA]);
    logSelected = isfinite(temp)  & [Lselected ; Lselected];% & abs(temp)>0;
    [~,freqBins_Pixels{outerloop}, freqDistributions_Pixels{outerloop}, freqCIs_Pixels{outerloop}] = plotBootstrappedDistribution(bootstrap(temp(logSelected), noBootstraps), 0:0.01:0.6);
    
    
    temp = log([leftFreqICA ; rightFreqICA]);
    logSelected = isfinite(temp)  & [Lselected ; Lselected];% & abs(temp)>0;
    [~,logFreqBins_Pixels{outerloop}, logFreqDistributions_Pixels{outerloop}, logFreqCIs_Pixels{outerloop}] = plotBootstrappedDistribution(bootstrap(temp(logSelected), noBootstraps), -6:0.1:0);
    
    
    xdisp = (leftXICA - rightXICA);
    ydisp = (leftYICA - rightYICA);
    
    dispAllowed = isfinite(xdisp) & inds;
    q = quantile(xdisp(dispAllowed), percentile);
    dispSelected = isfinite(xdisp) & abs(xdisp) < q & inds;
    
    [~,xdispBins_Pixels{outerloop}, xdispDistributions_Pixels{outerloop}, xdispCIs_Pixels{outerloop}] = plotBootstrappedDistribution(bootstrap(xdisp(dispSelected), noBootstraps), -3:0.24:3);
    
    dispAllowed = isfinite(ydisp) & inds;
    q = quantile(ydisp(dispAllowed), percentile)
    dispSelected = isfinite(ydisp) & abs(ydisp) < q & inds;  
    [~,ydispBins_Pixels{outerloop}, ydispDistributions_Pixels{outerloop}, ydispCIs_Pixels{outerloop}] = plotBootstrappedDistribution(bootstrap(ydisp(dispSelected),noBootstraps), -2:0.16:2);
    
    iSelected = isfinite(leftSICA) & isfinite(rightSICA) & isfinite(Lratio) & inds;
    [~,intensityRatioBins_Pixels{outerloop}, intensityRatioDistributions_Pixels{outerloop}, intensityRatioDispCIs_Pixels{outerloop}] = ...
        plotBootstrappedDistribution(bootstrap(Lratio(iSelected), noBootstraps), 0:0.1:5);   
    
        totalInds(outerloop,:) = inds;
end


    for bootloop = 1:noBootstraps
        inds = round(rand(1,noSamples).*(noSamples-1)+1);
        
        smoothFreqBootLeft_Pixels(bootloop,:) = smoothLeftFreq(inds);
        smoothFreqBootRight_Pixels(bootloop,:) = smoothRightFreq(inds);
    end
    
    
    temp = ([smoothLeftFreq ; smoothRightFreq]);
    logSelected = isfinite(temp) & [totalInds ; totalInds];% & abs(temp)>0;
    [~,smoothFreqBins_Pixels, smoothFreqDistributions_Pixels, smoothFreqCIs_Pixels] = plotBootstrappedDistribution(bootstrap(temp(logSelected),noBootstraps), 0:0.002:0.2);
    
    
    temp = log([smoothLeftFreq ; smoothRightFreq]);
    logSelected = isfinite(temp) & [totalInds ; totalInds];% & abs(temp)>0;
    [~,smoothLogFreqBins_Pixels, smoothLogFreqDistributions_Pixels, smoothLogFreqCIs_Pixels] = plotBootstrappedDistribution(bootstrap(temp(logSelected),noBootstraps), -6:0.1:0);
        
