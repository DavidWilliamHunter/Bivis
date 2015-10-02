function [ img ] = generateImage( obj, varargin )
% Generate an image displaying the patches on a rectangular grid.
%
% img = obj.generateImage();
% img = obj.generateImage('key', value, ...)
    processKeyValuePairInputs(obj, varargin{:});
    
    if isempty(obj.SelectedPatches)
        obj.SelectedPatches = 1:prod(obj.GridSize);
    end
    
    for loop = length(obj.SelectedPatches)+1:prod(obj.GridSize)
        obj.SelectedPatches(loop) = loop;
    end
    
    if isempty(obj.Patches)
        error('No Patches object supplied');
    end
    
    if ~isa(obj.Patches,'Patches');
        error('No patches object supplied.');
    end
    
    patchSize = obj.Patches.getDisplayBounds();
    
    if any(patchSize<0)
        error('Inappropriate patch sizes (<=0)');
    end

    img = ones((patchSize + obj.BorderSize).*(obj.GridSize)).*obj.BorderColor;
    
    loop = 1;
    for xloc = 1:obj.GridSize(1)
        for yloc = 1:obj.GridSize(2)
            patch = obj.Patches.getAsMatrix(obj.SelectedPatches(loop));
            loop = loop + 1;
            
				maxval = max(patch(:));
				minval = min(patch(:));

				patch = (patch-minval) / (maxval-minval);            
            
            xoff = (xloc-1) * (patchSize(1) + obj.BorderSize) + 1;
			yoff = (yloc-1) * (patchSize(2) + obj.BorderSize) + 1;
			
			img(xoff:xoff+patchSize(1)-1, yoff:yoff+patchSize(2)-1) = patch;
        end
    end
end