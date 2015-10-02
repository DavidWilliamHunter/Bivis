%%
%
figure(1)
reset(gcf);
clf

initialiseJOVPlot(gca, plot_size.*[1 1], plot_resolution);        


range = linspace(0,pi,100);
sineWave = sin(range+pi/4) + 1;
exampleData = sineWave + randn(size(sineWave)).*0.25;

hold off
plot(range, sineWave, '-');
hold on
plot(range, exampleData, '+');
xlabel('Disparity');
ylabel('Model response');
set(gca,'Xtick',[]);
set(gca,'Ytick',[]);

plot([pi/4 pi/4], [min(sineWave) max(sineWave)], 'k-','LineWidth', 2);
plot([pi/4-0.05 pi/4+0.05], [max(sineWave) max(sineWave)], 'k-','LineWidth', 2);
plot([pi/4-0.05 pi/4+0.05], [min(sineWave) min(sineWave)], 'k-','LineWidth', 2);
plot([pi-0.05 pi+0.05], [min(sineWave) min(sineWave)], 'k-','LineWidth', 2);
plot([pi/4 pi],[min(sineWave) min(sineWave)], 'k--','LineWidth', 1);
text(pi/4+0.025, (min(sineWave)+max(sineWave))/2, 'Response Range','FontSize',12);
%text(pi/4+0.025, max(sineWave)+0.1, 'Maximum', 'HorizontalAlignment','center','FontSize',12);
%text(pi+0.025, min(sineWave)-0.1, 'Minimum', 'HorizontalAlignment','center','FontSize',12);


plot([pi/3 pi/3], [sin(pi/4+pi/4)+1.5 sin(pi/4+pi/4)+0.5], 'k-','LineWidth', 2);
plot([pi/3-0.05 pi/3+0.05], [sin(pi/4+pi/4)+0.5 sin(pi/4+pi/4)+0.5], 'k-','LineWidth', 2);
plot([pi/3-0.05 pi/3+0.05], [sin(pi/4+pi/4)+1.5 sin(pi/4+pi/4)+1.5], 'k-','LineWidth', 2);
plot([pi/4 pi/3], [sin(pi/4+pi/4)+1 sin(pi/4+pi/4)+1], 'k-','LineWidth', 1);
text(pi/3+0.025, sin(pi/3+pi/4)+1, 'Residual Standard Deviation','FontSize',12);

plot([pi/3 pi/3], [min(sineWave)+0.5 min(sineWave)-0.5], 'k-','LineWidth', 2);
plot([pi/3-0.05 pi/3+0.05], [min(sineWave)-0.5 min(sineWave)-0.5], 'k-','LineWidth', 2);
plot([pi/3-0.05 pi/3+0.05], [min(sineWave)+0.5 min(sineWave)+0.5], 'k-','LineWidth', 2);
plot([pi/4 pi/3], [min(sineWave) min(sineWave)], 'k-','LineWidth', 1);
text(pi/3+0.025, min(sineWave)+0.1, 'Residual Standard Deviation','FontSize',12);


plot([pi/6 pi/6], [max(sineWave)+0.5 min(sineWave)-0.5], 'k-','LineWidth', 2);
plot([pi/6-0.05 pi/6+0.05], [min(sineWave)-0.5 min(sineWave)-0.5], 'k-','LineWidth', 2);
plot([pi/6-0.05 pi/6+0.05], [max(sineWave)+0.5 max(sineWave)+0.5], 'k-','LineWidth', 2);

text(pi/6-0.1, 0.5, 'Total range','FontSize',14, 'Rotation',90);

%plot([pi/4-0.05 pi/4-0.05], [max(sineWave) 0], 'k-','LineWidth', 2);

saveJOVPlot(gcf, [ plotDirectory,'figB'], plot_size.*[1 1], plot_resolution);

