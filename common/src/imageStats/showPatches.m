% Display patch data as a grid of rectangular patches, both displays to a
% figure and returns a raster image.
%
% showPatches (patches,  width, height)
% showPatches (patches,  width, height, noX, noY)
% showPatches (patches,  width, height, noX, noY, nSubX, nSubY)
% [ im  ] = showPatches (...)
%
% patches - vectorized patch data, each row contains a single patch
% width - the width of each patch in pixels
% height - the height of each patch in pixels
% noX - the number of patches to display in each row (default 3)
% noY - the number of patches to display in each column (default 3)
% im - [optional] output raster image.


% The MIT License (MIT)
% 
% Copyright (c) 2015 DavidWilliamHunter
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% showPatches

% Author: Owner <Owner@RATHLIN>
% Created: 2010-10-25

function [ im  ] = showPatches (patches,  width, height, noX, noY, nSubX, nSubY)
	if(nargin < 3)
		return;
	end
	if(nargin < 4)
		noX = min(size(patches, 1) ,4);
	end
	if(nargin < 5)
		noY = min(size(patches, 1)/noX, 3);
    end
    if(nargin<6)
       nSubX = 3;    
    end
    if(nargin<7)
        nSubY = 3;
    end
	
    if(ndims(patches)>2)
       for loop = 1:min(size(patches,3), nSubX*nSubY)
           subplot(nSubX, nSubY, loop);
           showPatches(patches(:,:,loop), width, height, noX, noY);
       end
       return;
    end
        
	border = 5;
	imwidth = width * noX + border * (noX-1);
	imheight = height * noY + border * (noY-1);
	
	im = zeros(imwidth, imheight);
	
	for j= 1:noY
		for i=1:noX
			index = (j - 1) * noX + i;
			xoff = (i-1) * (width + border) + 1;
			yoff = (j-1) * (height + border) + 1;
			
			if(index <= size(patches, 1))
				patch = reshape(patches(index,:)', width, height);
				maxval = max(patch(:));
				minval = min(patch(:));

				patch = (patch-minval) / (maxval-minval);
			else
				patch = zeros(1,size(patches,2));
            end

			im(xoff:xoff+width-1, yoff:yoff+height-1) = reshape(patch, width, height);
		end
	end
	
	imshow(im);

end
