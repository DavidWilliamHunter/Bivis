function [ handle ] = show( obj, varargin )
    handle = obj.handle;
    [handle, args] = axescheck(varargin{:});
    
    if ~ishandle(handle)
        handle = gca;
    end
    
    img = obj.generateImage(args{:});
    
    imshowScaled(img);
end

