noBootstraps = numel(resultsGabor);
names = fieldnames(resultsGabor{1});

fullAngleComponents = {'phi', 'theta'};
halfAngleComponents = {'gtheta'};

fprintf('Parameter  | MAD      |  MSE\n');

for nameLoop = 1:numel(names);
    values = NaN(noBootstraps, numel(resultsGabor{1}.(names{nameLoop})));
    targets = NaN(size(values));
        
    for bootLoop = 1:noBootstraps
        correctedGabors = convertAbsGabor2Gabor(resultsGabor{bootLoop}, patchSize);        
        
        values(bootLoop,:) = correctedGabors.(names{nameLoop})(:);
        targets(bootLoop,:) = gabors.(names{nameLoop})(:);
    end
    
    
    inds = isfinite(values) & isfinite(targets);
    
    diff = values(inds) - targets(inds);
    
    if any(strcmp(names{nameLoop}, fullAngleComponents)==true)
        diff = abs(values(inds(:)) - targets(inds));
        diff(:,:,2) = (2*pi) - abs(targets(inds) - values(inds));
        diff = min(diff, [], 3);
    elseif any(strcmp(names{nameLoop}, halfAngleComponents)==true)
        diff = abs(values(inds(:)) - targets(inds));
        diff(:,:,2) = (pi) - abs(targets(inds) - values(inds));
        diff = min(diff, [], 3);
    end
    
    fprintf('%10s | %f | %f \n', names{nameLoop}, median(abs(diff(:))), sqrt(mean(diff.^2)));
end


%% 
% Compare bootstrap consistency
% names = fieldnames(resultsLogGabor{1});
% halfAngleComponents = {'theta'};
% 
% 
% fprintf('Parameter  | MAD      |  MSE\n');
% 
% for nameLoop = 1:numel(names);
%     valuesLogGabor = NaN(noBootstraps, numel(resultsLogGabor{1}.(names{nameLoop})));
%         
%     for bootLoop = 1:noBootstraps       
%         valuesLogGabor(bootLoop,:) = resultsLogGabor{bootLoop}.(names{nameLoop})(:);
%     end
%     
%     inds = isfinite(valuesLogGabor);
%     
%     fprintf('%10s | %f | %f \n', names{nameLoop}, median(abs(diff(:))), sqrt(mean(diff.^2)));    
% end

names = fieldnames(resultsLogGabor{1});
reformattedLogGabor = struct;
for nameLoop = 1:numel(names)
    name = names{nameLoop};
    valuesLogGabor = NaN(noBootstraps, numel(resultsLogGabor{1}.(name)));
    
    for bootLoop = 1:noBootstraps
        reformattedLogGabor.(name)(bootLoop,:) = resultsLogGabor{bootLoop}.(name)(:);
    end
end
    
