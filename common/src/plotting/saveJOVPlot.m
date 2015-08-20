function [  ] = saveJOVPlot( handle, file_name , image_size, resolution )
% save the current plot in a format allowed by JOV
% [  ] = saveJOVPlot( handle, image_size, resolution )
%
    %set(gca, 'FontName', 'Helvetica');
    %set(gca, 'FontSize', 10);
    set(handle, 'PaperUnits', 'inches', 'PaperPosition', [0 0 image_size]/resolution, 'PaperSize', image_size/resolution);
    %set(handle, 'PaperPositionMode', 'auto');
    %set(handle, 'PaperType', 'A4');
    
    
    h = findobj(handle, 'Type', 'Axes');
    set(h, 'Units', 'normalized')

    print(handle,'-dpdf',sprintf('-r%d',resolution), [ file_name '.pdf']);
    %saveas(handle, file_name, 'tif');
end

