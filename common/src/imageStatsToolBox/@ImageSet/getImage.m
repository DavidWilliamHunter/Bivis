function [ img ] = getImage( obj, imageNumber)
    % Load the files and format them as a layered image.
    %
    % image = obj.getImage( imageNumber)
    %
    %  imageNumber - positive integer, reads a particular row number from a
    %  the image name file
    %  bw - boolean true if the image is to be loaded as grey scale, otherwise
    %       the image is loaded as a 3 layered r,g,b.
    %
    % img - tensor of image information (double).
    %       - 4 dimensions, width, height, layers, views.
    %
    % Note: normally imageNo is 1 for left and 2 for right.

    if(size(obj.file_names,1) < imageNumber || imageNumber<1)
        error('getImage: imageNumber must be positive integer from 1 to the number of image layers');
    end

    % load first image (there should always be one)
    loadedImage = imread(fullfile(obj.base_directory, obj.file_names{imageNumber,1}));
    loadedImage = imresize(loadedImage, 0.25);
    % ImageSet relies on this command to return image sizes so calculate
    % them here if not known. Also check that the images are the same size
    if isempty(obj.imageSizeOnly)
        obj.imageSizeOnly = [ size(loadedImage,1),size(loadedImage,2), obj.colour_model.getNoLayers, size(obj.file_names,2)];
    end

    if any(size(loadedImage)~= obj.imageSizeOnly(1:2))
        error('Images in the set must be identically sizeed');
    end


    local_noLayers = obj.colour_model.getNoLayers;


    local_noViews = obj.noViews;

    local_width = size(loadedImage,1);
    local_height = size(loadedImage,2);
    img = zeros(local_width,local_height, local_noLayers, local_noViews);
    for loop = 1:local_noViews
        loadedImage = imread(fullfile(obj.base_directory, obj.file_names{imageNumber,loop}));
        loadedImage = imresize(loadedImage, 0.25);        
        loadedImage = obj.colour_model.convertFromImread(loadedImage);
        for loop1 = 1:local_noLayers
            img(:,:,loop1, loop) = loadedImage(:,:,loop1);
        end
    end
end
