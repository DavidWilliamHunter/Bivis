% Figure 5. Heatmap of responses to separate subunits of complex cell model
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

for stimuliType = 1:1
    for modelType = 0:numel(modelTypeProto)-1
        modelTypeNamesSimple{modelType+1} =  sprintf(modelTypeProto{modelType+1},simpleStimuliTypeNames{stimuliType});
        modelTypeNamesComplex{modelType+1} = sprintf(modelTypeProto{modelType+1},stimuliTypeNames{stimuliType});
    end
    %simple = load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, simpleStimuliTypeNames{stimuliType}, 'Raw'), 'responses', 'disps');
    inds = reshape(1:500, subspacesize, 500/subspacesize);
    
    for modelType = 0:numel(modelTypeProto)-1
        simple = load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, simpleStimuliTypeNames{stimuliType}, modelTypeNamesSimple{modelType+1}), 'responses', 'disps');
        complex = load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNamesComplex{modelType+1}), 'responses', 'disps');
        load(sprintf('%s%s\\phaseInv_%s.mat',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNamesComplex{modelType+1}), 'phaseInv');
        
        [ ~, ddiOrdering ] = sort(phaseInv(:), 'descend');
        
        complexOffset= 1;
        
        outImg = ones(blockSize+innerBorder*2+boxBorder*2,subspacesize*blockSize + (subspacesize-1)*blockSeparation + boxBorder*2 + complexSeparation + blockSize + innerBorder*2,3);
        
        selectedDDI = [ ddiOrdering(end-5:end)' ];
        for ddiIndex = 1160 %selectedDDI
            [ a, groupNo, complexNo ] =ind2sub(size(phaseInv),ddiIndex);
            %for groupNo = 1%:size(complex.responses,2)
            %    for complexNo = ddiOrdering(1:5)' %1:size(complex.responses,3)
            if ~isempty(complex.responses{1,groupNo, complexNo})
                simpleResponses = squeeze(simple.responses(1,groupNo, complexNo,:));
                complexResponses = complex.responses{1,groupNo, complexNo};
                
                rangeX = 1:100;
                rangeY = 1:100;
                
                for sloop = 1:subspacesize
                    if ~isempty(simpleResponses{sloop})
                        resp = simpleResponses{sloop};
                        respPlus = resp;
                        respPlus(respPlus<0) = 0;
                        respPlus = respPlus./max(respPlus(:));
                        respPlus(~isfinite(respPlus))=0;
                        respMinus = -resp;
                        respMinus(respMinus<0) = 0;
                        respMinus = respMinus./max(respMinus(:));
                        respMinus(~isfinite(respMinus))=0;
                        outImg(innerBorder+boxBorder+rangeY,...
                            innerBorder+boxBorder+(sloop-1)*(blockSeparation+blockSize)+rangeX,...
                            1) = respPlus;
                        outImg(innerBorder+boxBorder+rangeY, ...
                            innerBorder+boxBorder+(sloop-1)*(blockSeparation+blockSize)+rangeX,...
                            2) = 0;
                        outImg(innerBorder+boxBorder+rangeY, ...
                            innerBorder+boxBorder+(sloop-1)*(blockSeparation+blockSize)+rangeX,...
                            3) = respMinus;
                    end
                end
                for sloop = 2:subspacesize
                    textColor    = [0, 0, 0]; % [red, green, blue]
                    textLocation = [innerBorder+boxBorder+(sloop-1)*(blockSeparation+blockSize)-boxBorder.*1.5-1 innerBorder+boxBorder+blockSize.*0.3333];       % [x y] coordinates
                    textInserter = vision.TextInserter('+', 'Color', textColor, 'FontSize', 24, 'Location', textLocation);
                    outImg = step(textInserter, outImg);
                    imshow(outImg);
                end
                
                rectangle = int32([boxBorder boxBorder ...
                    subspacesize*blockSize + (subspacesize-1)*blockSeparation + boxBorder*2 ...
                    blockSize+innerBorder*2+boxBorder]);
                outImg = step(vision.ShapeInserter, outImg, rectangle);
                
                textLocation = [ subspacesize*blockSize + (subspacesize-1)*blockSeparation + boxBorder*2 ,...
                    innerBorder+boxBorder+blockSize.*0.3333];
                textInserter = vision.TextInserter(' >', 'Color', textColor, 'FontSize', 24, 'Location', textLocation);
                outImg = step(textInserter, outImg);
                
                resp = complexResponses;
                respPlus = resp;
                respPlus(respPlus<0) = 0;
                respPlus = respPlus./max(respPlus(:));
                respPlus(~isfinite(respPlus))=0;
                respMinus = -resp;
                respMinus(respMinus<0) = 0;
                respMinus = respMinus./max(respMinus(:));
                respMinus(~isfinite(respMinus))=0;
                outImg(innerBorder+boxBorder+rangeY,...
                    innerBorder+boxBorder.*2+(sloop)*(blockSeparation+blockSize)-blockSeparation+complexSeparation+rangeX,...
                    1) = respPlus;
                outImg(innerBorder+boxBorder+rangeY,...
                    innerBorder+boxBorder.*2+(sloop)*(blockSeparation+blockSize)-blockSeparation+complexSeparation+rangeX,...
                    2) = 0;
                outImg(innerBorder+boxBorder+rangeY,...
                    innerBorder+boxBorder.*2+(sloop)*(blockSeparation+blockSize)-blockSeparation+complexSeparation+rangeX,...
                    3) = respMinus;
                imshow(outImg);
                
                imwrite(outImg, sprintf('%s%s\\%s\\Model_%i_%i.png',plotDirectory, simpleStimuliTypeNames{stimuliType}, modelTypeStub{modelType+1},groupNo, complexNo));
            end
        end
    end
end