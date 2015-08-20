clear
reset(gcf)
imageDirectory = 'E:\Users\Dave\Google Drive\binocular\common\images\';
outputDirectory = 'E:\Users\Dave\Google Drive\binocular\paper1\working\';

noPatches = 100000;
eigens = 200;
patchSize = 25;
count = 20;
imageScales = 1./(6:10);

diary([outputDirectory, 'output.txt'])
diary on

for imageScale = imageScales
    if(~exist([outputDirectory, 'scaleICA_', num2str(imageScale), '.mat'], 'file'))
        
        componentsICA = zeros(eigens * count, patchSize * patchSize * 2);
        componentsPCA = zeros(eigens * count, patchSize * patchSize * 2);
        icaVarExplained = zeros(count,1);
        for loop = 1:count
            if(exist([ outputDirectory, 'ICAModel_', num2str(imageScale),'_', num2str(loop), '.mat'], 'file'))
                load([ outputDirectory, 'ICAModel_', num2str(imageScale),'_', num2str(loop), '.mat']);
                fprintf('Iteration %i, image scale %d already complete.\n', loop, imageScale);                
            else
                fprintf('Beginning iteration %i, image scale %d...', loop, imageScale);
                
                [patches, patchLocations, relativeIntensityBefore, relativeIntensityAfter ] = cutDifferencePatches(imageDirectory, noPatches, patchSize, imageScale);
                
                fprintf('Finished cutting patches...');
                
                [whitesig, WM, DWM] = fastica(patches', 'lastEig', eigens, 'only', 'white', 'verbose', 'off');
                [~, varExplained] = fastica(patches', 'only', 'pca', 'verbose', 'off');
                
                fprintf('Finished pca...');
                
                pcaPatchesImage = showPatches(WM, patchSize, patchSize*2, 10, 20);
                imwrite(pcaPatchesImage, [outputDirectory, 'PCA_Patches_', num2str(imageScale), '.png' ], 'png');
                title('Paired PCA decomposition (whiteing matrix)');
                
                saveas(gcf, [ outputDirectory, 'PCAPatches_', num2str(imageScale), '_', num2str(loop) '.png'], 'png');
                
                [icasig, A, W] = fastica(patches', 'whiteSig', whitesig, 'whiteMat', WM, 'dewhiteMat', DWM, 'approach', 'symm', 'g', 'tanh', 'finetune', 'tanh',  'stabilization', 'on', 'verbose', 'off');
                
                fprintf('Finished ica\n');
                
                icaPatchesImage = showPatches(W, patchSize, patchSize*2, 10, 20);
                title('Paired ICA decomposition');
                imwrite(icaPatchesImage, [outputDirectory, 'ICA_Patches_', num2str(imageScale), '_', num2str(loop), '.png' ], 'png');
                saveas(gcf, [ outputDirectory, 'ICAPatches_', num2str(imageScale),'_', num2str(loop), '.png'], 'png');
                saveas(gcf, [ outputDirectory, 'ICAPatches_', num2str(imageScale),'_', num2str(loop), '.fig'], 'fig');
                save([ outputDirectory, 'ICAPatches_', num2str(imageScale),'_', num2str(loop), '.mat'], 'patches', 'patchLocations', 'relativeIntensityBefore', 'relativeIntensityAfter','patchSize','imageScale', '-v7.3');
                save([ outputDirectory, 'ICAModel_', num2str(imageScale),'_', num2str(loop), '.mat'], 'whitesig', 'WM', 'DWM','varExplained','icasig', 'A', 'W','noPatches','patchSize','imageScale', '-v7.3');
            end
            icaVarExplained(loop) = sum(diag(varExplained(end-eigens:end,end-eigens:end)));
            componentsICA((loop-1)*eigens+1:loop*eigens,:) = W;
            componentsPCA((loop-1)*eigens+1:loop*eigens,:) = WM;
        end
        save([outputDirectory, 'scaleICA_', num2str(imageScale), '.mat'], 'componentsICA', 'componentsPCA', 'count', 'eigens', 'icaVarExplained', 'patchSize');
        clear('patches', 'patchLocations', 'relativeIntensityBefore', 'relativeIntensityAfter',...
            'A','DWM','W','WM','componentsICA', 'componentsPCA', 'icaPatchesImage','icaVarExplained',...
            'icasig', 'patchLocations', 'patches', 'pcaPatchesImage', 'whitesig');
    else
        fprintf('image scale %d , aready completed.\n', imageScale);
    end
end

for imageScale = imageScales
    clear('componentsICA', 'componentsPCA', 'count', 'eigens', 'icaVarExplained', 'patchSize')
    load([outputDirectory, 'scaleICA_', num2str(imageScale), '.mat']);
    [gabors, gaborFitFVals, gaborFitStatii] = gaborFitPatches(componentsICA, patchSize, patchSize);
    save([outputDirectory, 'scaleICA_Fitted_', num2str(imageScale), '.mat'], 'gabors', 'gaborFitFVals', 'gaborFitStatii');
end

