function [ obj ] = loadImageNameList( obj, file_name )
% Load a file containing a list of files containing images.
% 
% obj = obj.loadImageNameList( file_name, bw )
%
% file_name - file to load
%
% The supplied file should be in Comma Separated Value format
% The system expects to load images, either one per layer (grey-scale) or
% three layers at a time (rgb).
% The files should be organised one layer per row, separated by commas (and
% new lines)

    if(~exist(file_name, 'file'))
        error('File %s not found', file_name);
    end
    
    obj.base_directory = fileparts(file_name);
    
    [fid,message] = fopen(file_name,'r');
    
    if(fid<0)
        error(message);
    end
    

    currentImage = 1;
    while ~feof(fid)
        line = fgets(fid);
        
        names = strsplit(line, ',');
        for loop = 1:length(names)
            names{loop} = strtrim(names{loop});
            obj.file_names{currentImage,loop} = names{loop};
        end
        currentImage = currentImage + 1;
    end 
end

