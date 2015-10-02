function [  ] = initialiseJOVPlot( handle, image_size, resolution )
% Setup a plot with the default settings required for a JOV submission

    set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 image_size]/resolution, 'PaperSize', image_size/resolution);
    %set(handle, 'PaperPositionMode', 'auto');
    %set(handle, 'PaperType', 'A4');
    
    
    h = findobj(handle, 'Type', 'Axes');
    set(h, 'Units', 'normalized')
        set(handle, 'Units', 'normalized')

set(handle, 'FontName', 'Helvetica');
set(handle, 'FontSize', 10);
set(handle, 'LineWidth', 1);

end

