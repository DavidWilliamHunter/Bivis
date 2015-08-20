function [ fftPatches  ] = patchFFT (patches,  width, height)
    % Apply Fourier transform (in 2D) to image patches)
    %
    % [ fftPatches  ] = patchFFT (patches,  width, height)
	if(nargin < 3)
		return;
	end
	if(nargin < 4)
		noX = min(size(patches, 1) ,4);
	end
	if(nargin < 5)
		noY = min(size(patches, 1)/noX, 3);
    end
	
    s = size(patches,1);
   
	fftPatches = zeros(size(patches));
	for i=1:s
		patch = reshape(patches(i,:)', width, height); 
		fftPatch = fft2(patch);
		fftPatch = fftshift(fftPatch);
		fftPatches(i,:) = reshape(fftPatch, 1, numel(fftPatch));
    end
end
