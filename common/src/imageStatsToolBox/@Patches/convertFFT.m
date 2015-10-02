function [ obj_out ] = convertFFT( obj_in, fromFFT )
% Perform FFT
if nargin < 2
    fromFFT = false;
end

s = obj_in.getPatchBounds();

n = obj_in.getNoPatches();

obj_out = copy(obj_in);

for loopI = 1:n
    for loopL = 1:s(3)
        for loopV = 1:s(4)
            patch = obj_in.getPatchData(loopI, loopL, loopV);
            
            if fromFFT
                fftPatch = ifft2(fftshift(patch));
            else
                fftPatch = fftshift(fft2(patch));
            end
            
            obj_out.setPatchData(loopI, fftPatch(:), loopL, loopV);
        end
    end
end
    
    


end

