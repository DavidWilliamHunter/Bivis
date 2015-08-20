% post hoc correction for all the components that failed to fit the first
% time.

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

defaultVariables
directoryFillInNaNs = 'fill in';
dirList = dir([ directoryFillInNaNs '*.mat' ]);

for loop = 1:length(dirList)
    load([directoryFillInNaNs dirList(loop).name], 'componentsICA', 'gabors', 'patchSize');
    
    if(exist('gabors','var'))
        fillInLoop = true;
        while fillInLoop
            selected = ~isfinite(gabors.xc) | ~isfinite(gabors.yc) | ~isfinite(gabors.sigmax) | ...
                ~isfinite(gabors.sigmay) | ~isfinite(gabors.gtheta) | ~isfinite(gabors.phi) | ...
                ~isfinite(gabors.freq) | ~isfinite(gabors.theta) | ~isfinite(gabors.s);
            selected = selected(:,1) | selected(:,2);
            
            before = sum(selected(:))
            
            if before > 0
                [ results, fvals, statii ] = gaborFitPatches(componentsICA(selected,:), patchSize, patchSize);
                
                gabors.xc(selected,:) = results.xc;
                gabors.yc(selected,:) = results.yc;
                gabors.sigmax(selected,:) = results.sigmax;
                gabors.sigmay(selected,:) = results.sigmay;
                gabors.gtheta(selected,:) = results.gtheta;
                gabors.phi(selected,:) = results.phi;
                gabors.freq(selected,:) = results.freq;
                gabors.theta(selected,:) = results.theta;
                gabors.s(selected,:) = results.s;
                
                newSelected = ~isfinite(gabors.s);
                newSelected = newSelected(:,1) | newSelected(:,2);
                
                before
                after = sum(newSelected)
                if after>=before || after==0
                    fillInLoop = false;
                end
            else
                fillInLoop = false;
            end
        end
        
        save([directoryFillInNaNs dirList(loop).name], 'gabors', '-append');
    end
end

