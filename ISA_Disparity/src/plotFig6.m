%%
% Figure 6. Plot responses to both bars and sine gratings for each
% complex-cell model.
clear all
display('Loading Data');
default

figure(1)
clf

for modelType = 0:numel(modelTypeProto)-1
    for stimuliType = 1:2
        for modelTypeLoop = 0:numel(modelTypeProto)-1
            modelTypeNames{modelTypeLoop+1} = sprintf(modelTypeProto{modelTypeLoop+1},stimuliTypeNames{stimuliType});
        end
        
        load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNames{modelType+1}), 'responses', 'disps');
        load(sprintf('%s%s\\DDI_%s.mat',plotDirectory, stimuliTypeNames{1}, ...
            sprintf(modelTypeProto{modelType+1},stimuliTypeNames{1})), 'ddi');
        
        [ ~, ddiOrdering ] = sort(ddi(:), 'descend');
        
        subplotIndex = 1;
        subplotInds = sub2ind([7,5], repmat(1:2:5,5,1)+stimuliType-1, repmat((1:5)',1,3));
        for loop = ddiOrdering(end-15:end)'
            figure(1)
            subplot(5,7,subplotInds(subplotIndex));
            subplotIndex = subplotIndex + 1;
            
            heatmap(responses{loop});
            %imshow(responses{loop},[]);
            %renderExIn(responses{loop});
            %title(num2str(loop+64))
            colorbar('delete')
            %axis off
            %axis fill
            hold on
            plot([0 size(responses{loop},1)], [0 size(responses{loop},2)], 'k-', 'LineWidth',2);
            %plot([-pi 0], [ 0 pi ], 'k.');
            %plot([ 0 -pi], [ pi 0], 'k.');
            hold off
            set(gca,'Xtick', [ 1 size(responses{loop},1)/2 size(responses{loop},1) ]);
            set(gca,'Ytick', [ 1 size(responses{loop},2)/2 size(responses{loop},2) ]);
            switch(stimuliType)
                case 1
                    set(gca,'Xticklabel', {'$-\pi$','$0$', '$\pi$'});
                    set(gca,'Yticklabel', {'$-\pi$','$0$', '$\pi$'});
                case 2
                    set(gca,'Xticklabel', {'$-12.5$','$0$', '$12.5$'});
                    set(gca,'Yticklabel', {'$-12.5$','$0$', '$12.5$'});
            end
            set(gca,'TickLabelInterpreter','Latex');
            set(gca,'FontSize', 8);
            
            titleStr = sprintf('%i', loop);
            title(titleStr);
        end
    end
    subplot(5,6,(1:5)*6);
    colorbar
    axis off
    figure(1)
    fileName = sprintf('%sModelResponses_Fig5_DDI_LOW_%s.fig',plotDirectory, modelTypeNames{modelType+1});
    saveas(gcf, fileName, 'fig');
    fileName = sprintf('%sModelResponses_Fig5_DDI_LOW_%s.png',plotDirectory, modelTypeNames{modelType+1});
    saveas(gcf, fileName, 'png');
end