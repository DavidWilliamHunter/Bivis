function [left, right] = separatePatchPairs(paired)
    % [left, right] = separatePatchPairs(paired)
    %
    % separate patches generated using cut difference patches
    halfWidth = floor(size(paired,2) / 2);
    
    left = paired(:,1:halfWidth);
    right = paired(:,halfWidth+1:end);
end