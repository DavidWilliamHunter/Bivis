classdef DisparitySampler < LinIntplSampler
    % Sample a set of patches from images in such a way that they can be
    % used to simulate disparity.
    
    properties(SetAccess = private)
        centre = []; % the location of the centre or foveal point.
        orientation = 0;  % the angle along which disparity is calculated 
        range = 10;         % maximum disparity.        
        samples = 10;      % number of samples to take
    end
    
    methods
        function obj = DisparitySampler(varargin)
            % obj = DisparitySampler()
            % obj = DisparitySampler(centre)
            % obj = DisparitySampler(centre, range)
            % obj = DisparitySampler(centre, range, orientation)
            % obj = DisparitySampler(centre, range, orientation, samples)
            %
            % Contructor for DisparitySampler object
            %
            % centre - 2d location within the image representing a point on
            %           the horopter.
            % range - scalar, the maximum disparity in pixels. (Negative
            %           values posible they simply invert the disparity
            %           direction.)
            % orientation - scalar value orientation in radians. 
            if nargin >= 1
                centre = varargin{1};
                if numel(centre) ~= 2 || any(~isnumeric(centre))
                    error('First arguement must be a 2d vector of location information');
                end
                obj.centre = centre;
            end
            if nargin >=2
                range = varargin{2};
                if numel(range) ~= 1 || ~isnumeric(range)
                    error('Second arguement must be a scalar value.');
                end
                obj.range = range;
            end
            if nargin >= 3
                orientation = varargin{3};
                if numel(orientation) ~= 1 || ~isnumeric(orientation)
                    error('Thir arguement must be a scalar value.');
                end
                obj.orientation = orientation;
            end
            if nargin >= 4
                samples = varargin{4};
                if numel(samples) ~= 1 || ~isposint(samples)
                    error('Thir arguement must be a scalar value.');
                end
                obj.samples = samples;
            end
            obj = obj.updateParent;
        end
                
        function locations = generateLocations(obj, varargin)
            % Generate sample locations along a line of disparity
            %
            % locations = obj.generateLocations();
            % locations = obj.generateLocations(noSamples);
            % locations = obj.generateLocations(noSamples, centre);
            % locations = obj.generateLocations(noSamples, centre, range);
            % locations = obj.generateLocations(noSamples, centre, range, orientation);
            samples = obj.samples;
            if nargin >= 2
                if numel(varargin{1})==1 && isposint(varargin{1})
                    samples = varargin{1};
                else
                    error('DisparitySampler:generateLocations first arguement must be a scalar positive integer');
                end
            end
            centre = obj.centre;
            if nargin >= 3
                if numel(varargin{2})==2 && all(isnumeric(varargin{2}))
                    centre = varargin{2};
                else
                    error('DisparitySampler:generateLocations second arguement must be a 2d numeric vector. (Positional data).');
                end
            end
            range = obj.range;
            if nargin >= 4
                if numel(varargin{3})==1 && isnumeric(varargin{2})
                    range = varargin{3};
                else
                    error('DisparitySampler:generateLocations third arguement must be a scalar (range).');
                end
            end
            orientation = obj.orientation;
            if nargin >= 5
                if numel(varargin{4})==1 && isnumeric(varargin{4})
                    orientation = varargin{4};
                else
                    error('DisparitySampler:generateLocations forth arguement must be a scalar (range).');
                end
            end            
            
            
            if ~isposint(samples)
                error('DisparitySampler:generateLocations number of samples must be positive.');
            end
           
            dirX = cos(orientation);
            dirY = sin(orientation);
            halfRange = range./2;
            locations(1,:) = linspace(centre(1)-halfRange*dirX, centre(1)+halfRange*dirX, samples);
            locations(2,:) = linspace(centre(2)-halfRange*dirY, centre(2)+halfRange*dirY, samples);
        end
    
        function ret = testFit(varargin)
            % Test if the disparity range falls within the range of the
            % image.
            %
            % ret = DisparitySampler.testFit(obj, imageSize);
            
            if nargin>=2
                if isa(varargin{1}, DisparitySampler)
                    obj = varargin{1};

                    imageSize = varargin{2};
                    if numel(imageSize)<2 || ~all(isnumeric(imageSize))
                        error('Invalid second parameter see help testFit for details.');
                    end
                else
                    error('Invalid inputs.');
                end
            end
            
            
            locations = obj.generateLocations(varargin{3:end});
            if any(locations<=0)
                ret = false;
            elseif any(locations(1,:)>imageSize(1))                
                ret = false;
            elseif any(locations(2,:)>imageSize(2))
                ret = false;
            else
                ret = true;
            end
        end
    end
    
    methods(Access = private)
        function obj = updateParent(obj)
                % private function updates the linear iterpolation of the
                % parent class to match the child class
                
                % first check that the values are appropriate
                test = all(isnumeric(obj.centre)) & numel(obj.centre)==2;
                test = test & isnumeric(obj.range) & numel(obj.range)==1;
                test = test & isnumeric(obj.orientation) & numel(obj.orientation)==1;
                test = test & isposint(obj.samples);
                if test
                    dirX = cos(obj.orientation);
                    dirY = sin(obj.orientation);  
                    start = obj.centre - (obj.range./2).*[dirX dirY];
                    e = obj.centre + (obj.range./2).*[dirX dirY];
                    left.start = start;
                    left.end = e;
                    right.start = e;
                    right.end = start;
                    obj.lines{1,1} = left;
                    obj.lines{1,2} = right;
                end
        end
    end
end

