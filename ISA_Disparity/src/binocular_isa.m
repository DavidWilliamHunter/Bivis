%
% Calculate binocular ISA using the methods of Hyvarinen et al.
%
%
clear

% some setup variables, mostly directories for loading images and saving
% interum data.
imageDirectory = '..\..\common\images\';
outputDirectory = '..\data\';
figurepath = '..\plots\';
experimentDirectory = '2\';     
patchSize = 25;                     % size of the square rectangles to cut.

%sample size, i.e. how many image patches. Book value: 50000
samplesize=500000;

rdim=504;

% rescale the images by
imageScale = 0.25;

%choose size of subspace used in all these simulations, 2 in the paper
subspacesize=2;

save([ outputDirectory experimentDirectory 'isaSetup.mat'], 'imageDirectory', 'outputDirectory', 'figurepath', 'experimentDirectory', ...
    'patchSize', 'samplesize', 'rdim', 'imageScale', 'subspacesize', '-v7.3');

for loop = 1:20
    if exist([ outputDirectory experimentDirectory 'isa_' num2str(loop) '.mat'],'file') == 0
        try
            %% Cut binocular difference patches
            [patches, patchLocations, relativeIntensityBefore, relativeIntensityAfter ] = cutDifferencePatches(imageDirectory, samplesize, patchSize, imageScale);
            
            % save pre-whittened patches
            save([ outputDirectory experimentDirectory 'isaPatchLocations_' num2str(loop) '.mat'], 'patchLocations', 'relativeIntensityBefore', 'relativeIntensityAfter', '-v7.3');
            patches = patches';
            
            % whitten
            patches = removeDC(patches);
            writeline('Variance-normalizing data')
            patches=variancenormalize(patches);
            writeline('Doing PCA and whitening data')
            
            % this bit is from Hyvarinens own code ( you will need to
            % download code from the website of the book to make the
            % functions work.
            %
            % http://www.naturalimagestatistics.net/
            [V,~,D]=pca(patches);
            Z=V(1:rdim,:)*patches;
            
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            W=isa_est(Z,rdim,subspacesize);
            
            %transform back to original space from whitened space
            Wisa = W*V(1:rdim,:);
            %basis vectors computed using pseudoinverse
            Aisa=pinv(Wisa);
            
            writeline('Ordering subspaces according to sparseness.')
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %Compute outputs
            Sisa=Wisa*patches;
            
            %order subspaces according to square correlations
            energies=Sisa.^2;
            %compute likelihood inside subspaces
            subspaceenergies=sum(reshape(energies,[subspacesize,rdim/subspacesize,samplesize]),1);
            subspaceLstmp=-sqrt(subspaceenergies);
            subspaceLs=sum(subspaceLstmp,3);
            [values,ssorder]=sort(subspaceLs(1,:,:)','descend');
            tmporder=((ssorder-1)*ones(1,subspacesize)*subspacesize+ones(rdim/subspacesize,1)*[1:subspacesize])';
            componentorder=tmporder(:);
            
            %do re-ordering of features
            Wisa=Wisa(componentorder,:);
            Aisa=Aisa(:,componentorder);
            
            % End of hyvarinen bit.
            
            save([ outputDirectory experimentDirectory 'isa_' num2str(loop) '.mat'], 'V', 'Z', 'W', 'Wisa', 'Aisa', 'Sisa', 'energies', 'subspaceenergies', 'subspaceLstmp', 'subspaceLs', 'values', 'ssorder', 'componentorder', '-v7.3');
            
            %%
            % Compute Gabors
            [gabors, gaborFitFVals, gaborFitStatii] = gaborFitPatches(Wisa, patchSize, patchSize);
            
            save([ outputDirectory experimentDirectory 'isaFittedGabors_' num2str(loop) '.mat'], 'gabors', 'gaborFitFVals', 'gaborFitStatii', '-v7.3');
            
            
            clear Aisa D E Sisa V W  Z componentoreder energies gaborFitVals gaborFitStatii gabors patches ssorder subpsaceLs subspaceLstmp subspaceenergies tmporder vales
        catch err
            err.getReport('extended', 'hyperlinks', 'on')
        end
    end
end