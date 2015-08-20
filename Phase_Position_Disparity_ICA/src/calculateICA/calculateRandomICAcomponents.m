% Compute ICA components using the methods of Hunter & Hibbard 2015.
%
% Patches are cut from binocular image pairs using the Hibbard 2007 set.
% The left/right parts of the patches are jumbled to break the link between
% left and right patches.
% ICA components are computed on the patch pairs using Hyvarinen's fastica
% package. You will need to download FastICA separately.

% The MIT License (MIT)
% 
% Copyright (c) 2015 DavidWilliamHunter
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

defaultVariables
diary([resultsDirectory, 'output.txt'])
diary on

experimentDirectory =  [ experimentDirectory 'random/'];

componentsICA = zeros(eigens * repeatCount, patchSize * patchSize * 2);
componentsPCA = zeros(eigens * repeatCount, patchSize * patchSize * 2);
for loop = 1:repeatCount
    patches = cutDifferencePatches(imageDirectory, noPatches, patchSize, imageScale);    
    
    inds = randperm(noPatches);     % randomise order of right patches to dissociate left and right patch pairs.
    patches(:, patchSize*patchSize+1:end) = patches(inds, patchSize*patchSize+1:end);

    [whitesig, WM, DWM] = fastica(patches', 'lastEig', eigens, 'only', 'white') ;
    [~, varExplained] = fastica(patches', 'only', 'pca');

    pcaPatchesImage = showPatches(WM, patchSize, patchSize*2, 10, 20);
    imwrite(pcaPatchesImage, [plotDirectory, experimentDirectory, 'PCAComponents_', runName, num2str(loop), '.png' ], 'png');
    saveas(gcf, [ plotDirectory, 'PCAComponents_', runName, '_', num2str(loop), '.fig' ], 'fig');        

    [icasig, A, W] = fastica(patches', 'whiteSig', whitesig, 'whiteMat', WM, 'dewhiteMat', DWM, 'approach', 'symm', 'g', 'tanh', 'finetune', 'tanh',  'stabilization', 'on');
 
    icaPatchesImage = showPatches(W, patchSize, patchSize*2, 10, 20);
    title('Paired ICA decomposition');
    imwrite(icaPatchesImage, [plotDirectory, experimentDirectory, 'ICAComponents_', runName, '_', num2str(loop), '.png' ], 'png');
    saveas(gcf, [ plotDirectory, 'ICAComponents_', runName, '_', num2str(loop), '.fig' ], 'fig');    
    componentsICA((loop-1)*eigens+1:loop*eigens,:) = W;
    componentsPCA((loop-1)*eigens+1:loop*eigens,:) = WM;
end

save([workingDirectory, experimentDirectory, 'patches_', runName, '.mat'], 'patches', '-v7.3');
save([workingDirectory, experimentDirectory, 'whitening_', runName, '.mat'], 'whitesig','varExplained','WM','DWM', '-v7.3');
save([workingDirectory, experimentDirectory, 'icaStep_', runName, '.mat'], 'icasig','A','W', '-v7.3');
save([workingDirectory, experimentDirectory, 'icaModel_', runName, '.mat'], 'componentsICA', 'componentsPCA', '-v7.3');

[ results, fvals, statii ] = gaborFitPatches(componentsICA, 25, 25);

save([workingDirectory, experimentDirectory, 'fittedGabors_', runName, '.mat'], 'results','fvals', 'statii', '-v7.3');
