function [ obj ] = import( varargin )
% Import data into the Patch model.
%
% obj = import('key', value, ...)
% obj = import(PatchInfo, 'key', value, ...)
%
% obj - returned Patch object created using the import data
% Patchinfo object specifying details about the patch being loaded not
% included in the input.
% Remaining input in the form of key-value pairing. Keys are the name of
% parameters (listed below), values are either the name of variable (if in
% file loading mode) or the actual variable (if in normal mode)
%
% Key               |  Value
% PatchInfo         | Patchinfo object describing the Patches
% PatchData         | The actual patchData
% Filename          | .mat file to load containing variables

default.PatchInfo = [];
default.PatchData = [];
default.PatchSize = [];
default.Filename = [];
offset = 1;


while offset <= numel(varargin)
    key = varargin{offset};
    if isa(key,'PatchInfo')
        default.PatchInfo = key;
        offset = offset+1;
    else
        value = varargin{offset+1};
        switch(lower(key))
            case 'patchinfo'
                default.PatchInfo = value;
            case 'patchdata'
                default.PatchData = value;
            case 'patchsize'
                default.PatchSize = value;
            case 'filename'
                default.Filename = value;
        end
        offset = offset + 2;
    end
end

default

if ~isempty(default.Filename)
    variableNames = {};
    if ~isempty(default.PatchInfo) && ischar(default.PatchInfo)
        variableNames = { variableNames{:} default.PatchInfo};
    end
    if ~isempty(default.PatchData) && ischar(default.PatchData)
        variableNames = { variableNames{:} default.PatchData};
    end
    if ~isempty(default.PatchSize) && ischar(default.PatchSize)
        variableNames = { variableNames{:} default.PatchSize};
    end    

    variableNames
    S = load(default.Filename, variableNames{:});
    S
    
    if ~isempty(default.PatchInfo) && ischar(default.PatchInfo)
        default.PatchInfo = S.(default.PatchInfo);
    end
    if ~isempty(default.PatchData) && ischar(default.PatchData)
        default.PatchData = S.(default.PatchData);
    end  
    if ~isempty(default.PatchSize) && ischar(default.PatchSize)
        default.PatchSize = S.(default.PatchSize);
    end        
end

obj = Patches(default.PatchInfo);
obj.patchData = default.PatchData;
