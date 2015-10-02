% Copyright (C) 2010 Owner
% 
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with Octave; see the file COPYING.  If not, see
% <http://www.gnu.org/licenses/>.

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
	
	im = ones(imwidth, imheight);
	
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
