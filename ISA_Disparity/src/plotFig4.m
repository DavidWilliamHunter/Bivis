% 
% Plot figure 4. Heatmap of responses of complex models to sine gratings
%
clear all
display('Loading Data');
default

figure(1)
clf

for stimuliType = 1:2
    for modelType = 0:numel(modelTypeProto)-1
        modelTypeNames{modelType+1} = sprintf(modelTypeProto{modelType+1},stimuliTypeNames{stimuliType});
    end
    for modelType = 0:numel(modelTypeProto)-1
        load(sprintf('%s%s\\ModelResponses_%s.mat',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNames{modelType+1}), 'responses', 'disps');
        %load(sprintf('%s%s\\DDI_%s.mat',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNames{modelType+1}), 'ddi');
        
        %[ ~, ddiOrdering ] = sort(ddi, 'descend');
        
        subplotIndex = 1;
        subplotInds = setdiff(1:(5*6), (1:5)*6);
        for loop = 1:25 %ddiOrdering(1:25)
            figure(1)
            subplot(5,6,subplotInds(subplotIndex));
            subplotIndex = subplotIndex + 1;
            
            heatmap(responses{loop});
            %imshow(responses{loop},[]);
            %renderExIn(responses{loop});
            %title(num2str(loop+64))
            colorbar('delete')
            %axis off
            %axis fill
            hold on
            plot([0 100], [0 100], 'k-', 'LineWidth',2);
            %plot([-pi 0], [ 0 pi ], 'k.');
            %plot([ 0 -pi], [ pi 0], 'k.');
            hold off
            set(gca,'Xtick', [ 1 50 100 ]);
            set(gca,'Ytick', [ 1 50 100 ]);
            set(gca,'Xticklabel', {'$-\pi$','$0$', '$\pi$'});
            set(gca,'Yticklabel', {'$-\pi$','$0$', '$\pi$'});
            set(gca,'TickLabelInterpreter','Latex');
            set(gca,'FontSize', 18);
            
            titleStr = sprintf('%i', loop);
            %title(titleStr);            
        end
        subplot(5,6,(1:5)*6);
        colorbar
        axis off
        figure(1)
        fileName = sprintf('%sModelResponses_%s_%s.fig',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNames{modelType+1});
        saveas(gcf, fileName, 'fig');        
        fileName = sprintf('%sModelResponses_%s_%s.png',plotDirectory, stimuliTypeNames{stimuliType}, modelTypeNames{modelType+1});
        saveas(gcf, fileName, 'png');        
    end
end