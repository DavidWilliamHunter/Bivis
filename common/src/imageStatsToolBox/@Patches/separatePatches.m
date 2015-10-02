function patches = separatePatches(obj)
% Separate patches into set according to view and layer

[ width, height ] = obj.getPatchBounds;

patches = cell(obj.layers, obj.views);

for layerNumber = 1:obj.layers
    for viewNumber = 1:obj.views
        range = (1:width*height) + (width*height*(layerNumber-1));
        range = range(:) + (width*height*obj.layers*(viewNumber-1));
        patchData = obj.patchData(:,range);

        patches{layerNumber, viewNumber} = obj.generateNewPatchSet(patchData);
    end
end

