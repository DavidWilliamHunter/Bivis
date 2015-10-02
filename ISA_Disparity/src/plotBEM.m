
plotDirectory = '../../plots/';
colours = eye(3);
%arcminScale = 1./scales;

plot_size = [ 1125 1125 ];
plot_resolution = 300;
thick_line_width = 2;
normal_line_width = 1;
thin_line_width = 0.5;
details.title_font_size = 14;
details.label_font_size = 12;
details.axis_font_size = 8;
details.thin_line_size = 0.5;
details.line_size = 1;
details.thick_line_size = 2;
%details.names = names;
%details.scaleNames = caption;
%details.scalesNum = scalesNum;
%details.scalesTex = scalesTex;
details.colours = colours;
details.xAxisShift = [0, -0.175];
details.yAxisShift = [1/3, 0];


initialiseJOVPlot(gca, plot_size.*[4 1], plot_resolution);        

%%
% Disparity diagram


figure(1)
clf
subplot(1,5,1);

plot([0 1],[0 1],'LineWidth',5, 'Color', [0.75 0.75 0.75]); hold on
plot([0.25 1],[0 0.75],'k-','LineWidth',2.5, 'Color', [0.75 0.75 0.75]);
plot([0 0.75],[0.25 1],'k-','LineWidth',2.5, 'Color', [0.75 0.75 0.75]);
text(0.6, 0.3, '<0 Disparity');
text(0.01, 0.6, '>0 Disparity');
text(0.4, 0.5, '0 Disparity');
set(gca,'Xtick',[]);
set(gca,'Ytick',[]);
xlabel('Left RF');
ylabel('Right RF');
title('Ideal disparity detector');

text(-0.1, -0.05, 'C', 'FontSize',details.title_font_size+2);

%%
% Plot Complex-cell models
figure(1)
subplot(1,5,2);

width = 400;
r = linspace(-pi, pi, width);
rs = linspace(-pi, pi, 5);

texLabels = {'$$\pi$$','$$-\frac{\pi}{2}$$','$$0$$','$$\frac{\pi}{2}$$','$$\pi$$'};
texLabels = {'$$\pi$$','$$-\pi/2$$','$$0$$','$$\pi/2$$','$$\pi$$'};

[ X , Y ] = meshgrid(r,r);
%X = X./width.*4.*pi - 2.*pi;
%Y = Y./width.*4.*pi - 2.*pi;

G = @(x, p) exp(-x.^2./4).*cos(x.*2 + p)./2;
BEM_S = @(x, y) (G(x, 0) + G(y, 0)).^2 + (G(x, pi/2) + G(y, pi/2)).^2;

h = contourf(r,r,BEM_S(X,Y)./2,5);
set(gca, 'XTick', rs);
set(gca, 'XTickLabel', texLabels);
set(gca, 'YTick', rs);
set(gca, 'YTickLabel', texLabels);
set(gca, 'TickLabelInterpreter','Latex');

h.LineColor = 0;
h.LineWidth = 3;
colormap(gray)

xlabel('Left RF');
ylabel('Right RF');
title('Binocular Energy Model (Bars)');
text(-0.2*2*pi-pi, -0.075*2*pi-pi, 'D', 'FontSize',details.title_font_size+2);

%%
% Plot Complex-cell models
figure(1)
subplot(1,5,3);

width = 400;
r = linspace(-pi, pi, width);
rs = linspace(-pi, pi, 5);

texLabels = {'$$\pi$$','$$-\frac{\pi}{2}$$','$$0$$','$$\frac{\pi}{2}$$','$$\pi$$'};
texLabels = {'$$\pi$$','$$-\pi/2$$','$$0$$','$$\pi/2$$','$$\pi$$'};

[ X , Y ] = meshgrid(r,r);
%X = X./width.*4.*pi - 2.*pi;
%Y = Y./width.*4.*pi - 2.*pi;

G = @(x, p) cos(x.*2 + p)./2;
BEM_S = @(x, y) (G(x, 0) + G(y, 0)).^2 + (G(x, pi/2) + G(y, pi/2)).^2;

h = contourf(r,r,BEM_S(X,Y)./2,5);
set(gca, 'XTick', rs);
set(gca, 'XTickLabel', texLabels);
set(gca, 'YTick', rs);
set(gca, 'YTickLabel', texLabels);
set(gca, 'TickLabelInterpreter','Latex');

h.LineColor = 0;
h.LineWidth = 3;
colormap(gray)

xlabel('Left RF');
ylabel('Right RF');
title('Binocular Energy Model (Gratings)');
text(-0.2*2*pi-pi, -0.075*2*pi-pi, 'E', 'FontSize',details.title_font_size+2);

%%
%
subplot(1,5,4)

width = 200;
r = linspace(-pi, pi, width);
rs = linspace(-pi, pi, 5);
[ X , Y ] = meshgrid(r,r);
%X = X./width.*4.*pi - 2.*pi;
%Y = Y./width.*4.*pi - 2.*pi;

G = @(x, p) exp(-x.^2./4).*cos(x + p)./2;
%BEM_S = @(x, y) (G(x, 0) + G(y, 0)).^2 + (G(x, pi/2) + G(y, pi/2)).^2;
BEM_S = @(x, y) (G(x, 0) + G(y, 0)).^2;

h = contourf(r,r,BEM_S(X,Y)./2,10);
set(gca, 'XTick', rs);
set(gca, 'XTickLabel', texLabels);
set(gca, 'YTick', rs);
set(gca, 'YTickLabel', texLabels);
set(gca, 'TickLabelInterpreter','Latex');

h.LineColor = 0;
h.LineWidth = 2;
colormap(gray)

xlabel('Left RF');
ylabel('Right RF');
title('Simple-cell model (Sine grating)');

text(-0.2*2*pi-pi, -0.075*2*pi-pi, 'F', 'FontSize',details.title_font_size+2);

%%
%
subplot(1,5,5);

width = 200;
r = linspace(-pi, pi, width);
rs = linspace(-pi, pi, 5);
[ X , Y ] = meshgrid(r,r);
%X = X./width.*4.*pi - 2.*pi;
%Y = Y./width.*4.*pi - 2.*pi;

G = @(x, p) cos(x + p)./2;
BEM_S = @(x, y) (G(x, 0) + G(y, 0)).^2;

h = contourf(r,r,BEM_S(X,Y)./2,5);
set(gca, 'XTick', rs);
set(gca, 'XTickLabel', texLabels);
set(gca, 'YTick', rs);
set(gca, 'YTickLabel', texLabels);
set(gca, 'TickLabelInterpreter','Latex');

h.LineColor = 0;
h.LineWidth = 2;
colormap(gray)

xlabel('Left RF','Interpreter','Latex');
ylabel('Right RF');
title('Simple-cell model (Sine grating)');

text(-0.2*2*pi-pi, -0.075*2*pi-pi, 'G', 'FontSize',details.title_font_size+2);

saveJOVPlot(gcf, [ plotDirectory,'figA'], plot_size.*[4 1], plot_resolution);

%%
figure(2)
subplot(1,2,2)
G = @(x) exp(-x.^2./1000);
h = contourf(r,r,1-abs(X-Y),5);

