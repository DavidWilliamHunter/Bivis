classdef LinIntplSampler < PatchSampler
    %LININTSAMPLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lines = [];  % 2d cell array of structs containing the linear transforms. First dimension selects layers, second dimension selects views.
    end
    
    methods
        function [ obj ] = LinIntplSampler(varargin)
            if nargin == 1
                in = varargin{1};
                if isstruct(in)
                    if isStructProperlyFormatted(in, true)
                        obj.lines{1,1} = in;
                    end
                elseif iscell(in)
                    for loop = 1:numel(in)
                        isStructProperlyFormatted(in{loop}, true);
                    end
                    obj.lines = in;
                end
            elseif nargin == 2
                start = varargin{1};
                e = varargin{2};
                if isscalar(start) && isscalar(e) && isnumeric(start) && isnumeric(e)
                    newStruct = struct;
                    newStruct.start = start;
                    newStruct.end = e;
                    obj.lines{1,1} = newStruct;
                end
            elseif mod(nargin,2)==0
                for loop = 1:2:nargin
                    start = varargin{loop};
                    e = varargin{loop+1};
                    if isscalar(start) && isscalar(e) && isnumeric(start) && isnumeric(e)
                        newStruct = struct;
                        newStruct.start = start;
                        newStruct.end = e;
                        obj.lines{1,loop} = newStruct;
                    end
                end
            end
            
        end
        
        function [ patchLocations ] = generateSampleLocationsFromImage(obj, noPatches, patchSize, imageSize)
            % Create a set of random patch locations over an image.
            %
            % [ patchLocations ] = sample(noPatches, patchSize, imageSize)
            %
            % noPatches - number of patch locations to generate
            % patchSize - the size of the patch (maximum rectangular range)
            %             2 vector double
            % imageSize - the size of the images to cut from.
            %            [ width, height, noLayers, noImages ]
            
            
            width = patchSize(1);
            height = patchSize(2);
            imageWidth = imageSize(1);
            imageHeight = imageSize(2);
            
            
            if numel(imageSize) >= 3
                noLayers = imageSize(3);
            else
                noLayers = 1;
            end
            
            if numel(imageSize) >= 4
                noViews = imageSize(4);
            else
                noViews = 1;
            end
            
            halfWidth = floor( (width - 1 ) / 2);
            halfHeight = floor( (height - 1) / 2);
            
            %newPatchLocations(:,1) = unidrnd(imageWidth - width, noPatches, 1) + halfWidth;
            %newPatchLocations(:,2) = unidrnd(imageHeight - height, noPatches, 1) + halfHeight;
            patchLocations = zeros(noPatches, 2, noLayers, noViews);
            
            size(obj.lines)
            for loopL = 1:noLayers
                Lind = min([loopL size(obj.lines,1) ]);
                for loopI = 1:noViews
                    Iind = min([loopI size(obj.lines,2)]);

                    range1 = linspace(obj.lines{Lind,Iind}.start(1), obj.lines{Lind,Iind}.end(1), noPatches);
                    range2 = linspace(obj.lines{Lind,Iind}.start(2), obj.lines{Lind,Iind}.end(2), noPatches);
                    patchLocations(:,:,loopL, loopI) =  [ range1; range2 ]';
                end
            end
        end
        
    end
    
    methods(Access = private, Static)
        function [ properlyFormatted ] = isStructProperlyFormatted(in, reportError)
            if nargin < 2
                reportError = false;
            end
            if isstruct(in)
                if isfield(in, 'start') && isfield(in, 'end')
                    if isscalar(in.start) && isscalar(in.end) && isnumeric(in.start) && isnumeric(in.end)
                        properlyFormatted = true;
                        return;
                    elseif reportError
                        error('Start and end values must be scalar (single) numeric values.');
                    end
                elseif reportError
                    error('Structure must contain start and end values.');
                end
            elseif reportError
                error('Linear interpolation is defined using a struct containing scalar start/end values.');
            end
            properlyFormatted = false;
        end
    end
end

