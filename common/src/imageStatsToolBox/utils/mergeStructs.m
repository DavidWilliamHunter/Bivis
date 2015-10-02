function [ output ] = mergeStructs(varargin)
    if(nargin<1)
        error('mergeStructs must have at least one inputs');
    end
    if(nargin==1)
        output = varargin{1};
        return
    end
    
    fieldNames = cell(1,numel(varargin));
    values = cell(1, numel(varargin));
    for loop = 1:numel(varargin)
        if(~isstruct(varargin{loop}))
            error('inputs must be structs');
        end
        if(~isempty(varargin{loop}))
            fieldNames{loop} = fieldnames(varargin{loop});
            values{loop} = struct2cell(varargin{loop});
        end
    end
    
    fieldNames = cat(1, fieldNames{:});
    values = cat(1, values{:});
    [ ~, uniqueFieldNames ] = unique(fieldNames, 'legacy');
    
    for loop = uniqueFieldNames'
        if(isstruct(values{loop}))
            % find and merge these structures
            temp = struct();
            for loop2 = 1:nargin
                if(isfield(varargin{loop2}, fieldNames(loop)))
                    temp = mergeStructs(temp, varargin{loop2}.(fieldNames{loop}));
                end
            end
            values{loop} = temp;
        end
    end
    
    output = cell2struct(values(uniqueFieldNames), fieldNames(uniqueFieldNames));
    
end
