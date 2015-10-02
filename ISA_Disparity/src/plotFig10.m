%%
% Plot figure 10. Cumulative distributions of binocular disparity
% discrimination index.
clear all
display('Loading Data');
default

blockSeparation = 16;
boxBorder = 10;
complexSeparation = 15;
textSize = 12;
blockSize = 100;
innerBorder = 10;

figure(1)
clf

figure(1)
clf
reset(gcf)

c = { 'r','g'};
for stimuliType = 1:1
    for modelType = 0:numel(modelTypeProto)-1
        modelTypeNamesSimple{modelType+1} =  sprintf(modelTypeProto{modelType+1},simpleStimuliTypeNames{stimuliType});
        modelTypeNamesComplex{modelType+1} = sprintf(modelTypeProto{modelType+1},stimuliTypeNames{stimuliType});
    end
    %simple = load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, simpleStimuliTypeNames{stimuliType}, 'Raw'), 'responses', 'disps');
    inds = reshape(1:500, subspacesize, 500/subspacesize);
    
    for modelType = 0:numel(modelTypeProto)-1
        %simple = load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, simpleStimuliTypeNames{stimuliType}, modelTypeNamesSimple{modelType+1}), 'responses', 'disps');
        %complex = load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNamesComplex{modelType+1}), 'responses', 'disps');
        load(sprintf('%s%s\\DDI_%s.mat',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNamesComplex{modelType+1}), 'ddi');
        
        hold on
        %plotBootstrappedDistribution(bootstrap(ddi,200), 100,'plot','manylinesc');
        plotBootstrapCumHistColour(bootstrap(ddi,200),100,c{modelType+1});
        
        xlabel('Disparity Discrimination Index');
        ylabel('Proportion of models');
        
        figure(1)
        fileName = sprintf('%sDDI_distribution_%s_%s.fig',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNamesComplex{modelType+1});
        saveas(gcf, fileName, 'fig');        
        fileName = sprintf('%sDDI_distribution_DDI_LOW_%s_%s.png',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNamesComplex{modelType+1});
        saveas(gcf, fileName, 'png'); 
    end
end