function [ img ] = getImage( obj, imageNumber )
    % Generate a novel image and format it as a layered image.
    %
    % image = obj.getImage( imageNumber)
    %
    %  imageNumber 
    %  bw - boolean true if the image is to be loaded as grey scale, otherwise
    %       the image is loaded as a 3 layered r,g,b.
    %
    % img - tensor of image information (double).
    %       - 4 dimensions, width, height, layers, views.
    %
    % Note: normally imageNo is 1 for left and 2 for right.

    % ImageSet relies on this command to return image sizes so calculate
    % them here if not known. Also check that the images are the same size
    if isempty(obj.imageSizeOnly)
        obj.imageSizeOnly = [ 256 256 1 2];
    end

    rndImage = randn(obj.imageSizeOnly(1:2));
    
    local_noLayers = obj.colour_model.getNoLayers;

    local_noViews = obj.noViews;

    local_width = size(rndImage,1);
    local_height = size(rndImage,2);
    img = zeros(local_width,local_height, local_noLayers, local_noViews);
    for loop = 1:local_noViews        
        for loop1 = 1:local_noLayers
            img(:,:,loop1, loop) = rndImage;
        end
    end
end
