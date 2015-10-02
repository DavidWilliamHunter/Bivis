function [ output, inds ] = bootstrap( data, bootstraps )
    % bootstrap the data, creating 'bootstraps' versions of 'data'

    data = data(:);
    
    inds = ceil(rand(bootstraps, length(data)).*length(data));
    output = data(inds);
end

