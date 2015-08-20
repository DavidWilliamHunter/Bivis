clear all
clear 

dataDirectory = '';
%dataDirectory = 'C:\data\bootstrapped\';
%dataDirectory = 'C:\Users\David Hunter\Documents\MATLAB\binocular\bootstrapped\';
dirList = dir([ dataDirectory '*.mat' ])

load([dataDirectory dirList(1).name]);
noFiles = length(dirList);

leftPhaseICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightPhaseICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftFreqICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightFreqICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftAnglesICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightAnglesICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftGThetaICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightGThetaICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftXCICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightXCICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftYCICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightYCICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftSigmaXICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightSigmaXICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftSigmaYICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightSigmaYICA = zeros(noFiles, size(gabors.phi(:,1),1));
leftSICA = zeros(noFiles, size(gabors.phi(:,1),1));
rightSICA = zeros(noFiles, size(gabors.phi(:,1),1));
disp = zeros(noFiles, size(gabors.phi(:,1),1));
odisp = zeros(noFiles, size(gabors.phi(:,1),1));
physDisp = zeros(noFiles, size(gabors.phi(:,1),1));
shapeDiff = zeros(noFiles, size(gabors.phi(:,1),1));

for loop = 1:noFiles
    [dataDirectory dirList(loop).name]
    load([dataDirectory dirList(loop).name], 'gabors');
    
    correctedGabors = convertAbsGabor2Gabor(gabors, patchSize);
    leftPhaseICA(loop,:) = mod(correctedGabors.phi(:,1), 2*pi);
    rightPhaseICA(loop,:) = mod(correctedGabors.phi(:,2), 2*pi);
    leftFreqICA(loop,:) = correctedGabors.freq(:,1);
    rightFreqICA(loop,:) = correctedGabors.freq(:,2);
    leftAnglesICA(loop,:) = correctedGabors.theta(:,1);
    rightAnglesICA(loop,:) = correctedGabors.theta(:,2);
    leftGThetaICA(loop,:) = correctedGabors.gtheta(:,1);
    rightGThetaICA(loop,:) = correctedGabors.gtheta(:,2);
    leftSigmaXICA(loop,:) = correctedGabors.sigmax(:,1);
    rightSigmaXICA(loop,:) = correctedGabors.sigmax(:,2);
    leftSigmaYICA(loop,:) = correctedGabors.sigmay(:,1);
    rightSigmaYICA(loop,:) = correctedGabors.sigmay(:,2);    
    
    leftXCICA(loop,:) = correctedGabors.xc(:,1);
    rightXCICA(loop,:) = correctedGabors.xc(:,2);
    leftYCICA(loop,:) = correctedGabors.yc(:,1);
    rightYCICA(loop,:) = correctedGabors.yc(:,2);
    
    leftSICA(loop,:) = correctedGabors.s(:,1);
    rightSICA(loop,:) = correctedGabors.s(:,2);
        
    [ disp(loop,:), odisp(loop,:)] = gaborDistance(correctedGabors);
    
    [ physDisp(loop,:), shapeDiff(loop,:) ] = physicalDisparity( correctedGabors );

end

