function [patches, patchLocations] = cutPatchPairs(varargin)
	% [patches] = cutPatchPairs(left, right, noPatches)
	% [patches] = cutPatchPairs(left, right, noPatches, width, height)
	% [patches] = cutPatchPairs(left, right, patchLocations)
	% [patches] = cutPatchPairs(left, right, patchLocations, width, height)
	if(nargin<2)
		return;
	end
	
	left = varargin{1};
    right = varargin{2};
	
	imageWidth = size(left,1);
	imageHeight = size(left,2);
    if(ndims(left)>2)
        imageDepth = size(left,3);
    else
        imageDepth = 1;
    end
    
    if(size(right,1) ~= imageWidth)
        return;
    end
    if(size(right,2) ~= imageHeight)
        return;
    end   
    if(ndims(left) ~= ndims(right))
        return;
    end
	
	if(nargin >=5)
		width = varargin{4};
		height = varargin{5};
	else if(nargin ==4)
            width = varargin{4};
            height = varargin{4};
        else
            width = 3;
            height = 3;
        end
    end
	% set bounds in which to cut patches
	halfWidth = floor( (width - 1 ) / 2);
	halfHeight = floor( (height - 1) / 2);

	if(isscalar(varargin{3}))
		patchLocations = [];
		noPatches = varargin{3};
			
		patchLocations(:,1) = unidrnd(imageWidth - width, noPatches, 1) + halfWidth;
		patchLocations(:,2) = unidrnd(imageHeight - height, noPatches, 1) + halfHeight;
        
	else
		patchLocations = varargin{3};
    end
    

    
    patches = zeros(size(patchLocations,1), 2 * width*height*imageDepth);
	if(size(patchLocations,2))
		for i=1:size(patchLocations,1)
			patch = left(patchLocations(i,1)-halfWidth:patchLocations(i,1)+halfWidth,patchLocations(i,2)-halfHeight:patchLocations(i,2)+halfHeight,:);
            %%patch = log(patch);
            patch = reshape(patch, width*height*imageDepth, 1);
            %normalisation has been shifted to the CutDifferencePatches
            % command.
            %patch = patch - mean(patch);
            %patch = patch ./ norm(patch);
			patches(i,1:width*height*imageDepth) = patch;
            patch = right(patchLocations(i,1)-halfWidth:patchLocations(i,1)+halfWidth,patchLocations(i,2)-halfHeight:patchLocations(i,2)+halfHeight,:);
            %%patch = log(patch);
            patch = reshape(patch, width*height*imageDepth, 1);
            %patch = patch - mean(patch);
            %patch = patch ./ norm(patch);            
            patches(i,width*height*imageDepth+1:end) = patch;
            patches(i,:) = patches(i,:) ./ (patches(i,:)*patches(i,:)');
		end
    end

end