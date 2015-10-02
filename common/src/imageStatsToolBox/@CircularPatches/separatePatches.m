function patches = separatePatches(obj)
% Separate patches into set according to view and layer

[ width, height ] = obj.getPatchBounds;

patches = cell(obj.layers, obj.views);

ind = obj.createTemplate();
            
totalInd = sum(ind(:));
            
for layerNumber = 1:obj.layers
    for viewNumber = 1:obj.views
        range = (1:totalInd) + (totalInd*(layerNumber-1));
        range = range(:) + (totalInd*obj.layers*(viewNumber-1));
        patchData = obj.patchData(:,range);

        patches{layerNumber, viewNumber} = CircularPatches(obj.radius, 1,1);
        patches{layerNumber, viewNumber}.patchData = patchData;
    end
end

