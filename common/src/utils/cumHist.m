 function [ cum, centers ] = cumHist(distribution, binCount, minimum, maximum)
    % Computes and plots a cumulative histogram
    %
    % [ cum, centers ] = cumHist(distribution, binCount, minimum, maximum)
    %
    %
    %bins = logspace(min(distribution), max(distribution), binCount+1);
    if nargin<4
        maximum = max(distribution(:));
    end
    if nargin<3
        minimum = min(distribution(:));
    end
    if nargin<2
        binCount = ceil(log10(numel(distribution)).*10);
    end
    if numel(binCount)==1
        bins = linspace(minimum, maximum, binCount + 1);
        binStart = bins(1:binCount);
        binEnd = bins(2:binCount+1);

        centers = (binStart + binEnd)/2;

        for loop = 1:length(binEnd)
            cum(loop) = sum(distribution(:)<=binEnd(loop));
        end

        cum = cum ./ length(distribution);
    else
        centers = binCount;
        
        for loop = 1:length(centers)-1
            cum(loop) = sum(distribution(:)<=centers(loop));
        end
        cum(loop+1) = numel(distribution(:));
        
        cum = cum ./ length(distribution);        
    end


   if nargout==0
        plot([ 0 centers ] , [ 0 cum] );
    end
 end
