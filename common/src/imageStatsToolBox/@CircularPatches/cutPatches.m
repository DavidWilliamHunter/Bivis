function [patches] = cutPatches(patchObj, image, patchLocations)
    [width,height] = patchObj.getPatchBounds();

	% set bounds in which to cut patches
	halfWidth = int64(floor( (width - 1 ) / 2));
	halfHeight = int64(floor( (height - 1) / 2));
    
    % create a circular template
    inds = patchObj.createTemplate();
    
    noActive = int64(ceil(sum(inds(:))));


    layers = size(image,3);
    views = size(image,4);
    patches = zeros(size(patchLocations,1), noActive*layers*views);
    for i=1:size(patchLocations,1)
        for loopL=1:layers
            for loopV=1:views
                patch = image(patchLocations(i,1)-halfWidth:patchLocations(i,1)+halfWidth,...
                    patchLocations(i,2)-halfHeight:patchLocations(i,2)+halfHeight, ...
                    loopL, loopV);
                patches(i,(1:noActive)+(loopL-1)*noActive+(loopV-1)*noActive*layers) = patch(inds)';
            end
        end
    end
end