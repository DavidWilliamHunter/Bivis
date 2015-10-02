function [patches] = cutPatches(patchObj, image, patchLocations)
    if nargin < 3
        patchLocations = patchObj.locations;
    end
    
    [width,height] = patchObj.getPatchBounds();
    
	% set bounds in which to cut patches
	halfWidth = floor( (width - 1 ) / 2);
	halfHeight = floor( (height - 1) / 2);

    noLayers = size(image,3);
    noViews = size(image,4);

    patches = zeros(size(patchLocations,1), width*height*noLayers*noViews);
    try 
    for i=1:size(patchLocations,1)
        patch = zeros(width,height,noLayers, noViews);
        for loopI = 1:noViews
            for loopL=1:noLayers
                patch(:,:,loopL, loopI) = ...
                    image(patchLocations(i,1,loopL, loopI)-halfWidth:patchLocations(i,1,loopL, loopI)+halfWidth, ...
                    patchLocations(i,2,loopL, loopI)-halfHeight:patchLocations(i,2,loopL, loopI)+halfHeight,loopL,loopI);
            end
            %patch = patch - mean(patch);
            %patches(i,:) = patches(i,:) ./ (patches(i,:)*patches(i,:)');
        end
        patches(i,:) = reshape(patch, width*height*noLayers*noViews, 1);

    end
    catch ME
        fprintf('%i, %i, %i\n', i, loopI, loopL);
        size(patches)
        rethrow(ME);
    end
end