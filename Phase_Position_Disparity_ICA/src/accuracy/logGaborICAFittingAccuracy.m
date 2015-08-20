clear all
clear 

dataDirectory = 'C:\Users\Dave\Documents\MATLAB\binocular\paper1\unified\fitted\';
initialGabors ='bootstrap_accuracy_test_ica_gabor3.mat';
fittedGaborFileName = 'bootstrap_accuracy_test_ica_gabor_fit3.mat';
fittingLogGaborFileName = 'bootstrap_accuracy_test_ica_log_gabor_fitting3.mat';
fittedLogGaborFileName = 'bootstrap_accuracy_test_ica_log_gabor_fitted3.mat';
%dataDirectory = 'C:\data\bootstrapped\';
%dataDirectory = 'C:\Users\David Hunter\Documents\MATLAB\binocular\bootstrapped\';
dirList = dir([ dataDirectory '*.mat' ])

%load([dataDirectory dirList(1).name]);
noFiles = length(dirList);

noBootstraps = 1;

loop = 1;

components = cell(1,noFiles);
resultsGabor = cell(1, noFiles);

delete(initialGabors,  fittedLogGaborFileName);

for loop = 1:noFiles
    [dataDirectory dirList(loop).name]
    load([dataDirectory dirList(loop).name], 'componentsICA', 'gabors', 'patchSize');
    
    components{loop} = componentsICA;
    resultsGabor{loop} = gabors;
    clear componentsICA
    clear gabors
    
    noPatches = size(components, 1);
    
    save(initialGabors, 'resultsGabor', 'patchSize', 'noPatches', 'noBootstraps');
    
    delete(fittingLogGaborFileName);
    
    [ resultsLogGabor{loop}, fvalsLogGabors{loop}, statiiLogGabors{loop}] = bootstrapLogGaborFitPatches(noBootstraps, components{loop}, patchSize, patchSize, fittingLogGaborFileName);

    save(fittedLogGaborFileName);
end