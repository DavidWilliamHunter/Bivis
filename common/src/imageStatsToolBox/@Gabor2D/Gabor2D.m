classdef Gabor2D
    % Gabor functions describe a windowed Fourier transform in two
    % dimensions.
    
    properties
        centre;         % the centre of the Gaussian window also location phase is measured relative to.
        sigma;                      % (roughly window size) named after the sigma term in Gaussian distribution.
        windowOrientation;         % orientation of the Gaussian window.
        frequency;           % frequency of the waveform
        phase;            % phase of the waveform
        orientation;         % orientation of the waveform
        intensity;          % intensity of the gabor function, i.e. a scaling factor
    end
    
    properties(Dependent)
        left;           % the 'left' view gabors only (if two views are available)
        right;          % the 'right' view gabors only
        number;         % the number of gabors (or pairs)
        views;          % the number of views
    end
    
    methods
        function obj = Gabor2D(varargin)
            if nargin >=1
                if isstruct(varargin{1})
                    if isfield(varargin{1}, 'xc') && ...
                            isfield(varargin{1}, 'yc') && ...
                            isfield(varargin{1}, 'sigmax') && ...
                            isfield(varargin{1}, 'sigmay') && ...
                            isfield(varargin{1}, 'gtheta') && ...
                            isfield(varargin{1}, 'freq') && ...
                            isfield(varargin{1}, 'phi') && ...
                            isfield(varargin{1}, 'theta') && ...
                            isfield(varargin{1}, 's')
                        obj.centre(:,1,:) = varargin{1}.xc;
                        obj.centre(:,2,:) = varargin{1}.yc;
                        obj.sigma(:,1,:) = varargin{1}.sigmax;
                        obj.sigma(:,2,:) = varargin{1}.sigmay;
                        obj.windowOrientation = varargin{1}.gtheta;
                        obj.frequency = varargin{1}.freq;
                        obj.phase = varargin{1}.phi;
                        obj.orientation = varargin{1}.theta;
                        obj.intensity = varargin{1}.s;
                    else
                        error('Incorrectly formatted struct');
                    end
                end
            end
        end
        
        function out = get.left(obj)
            % return the left gabors only
            % leftGabors = obj.left
            out = Gabor2D;
            out.centre = squeeze(obj.centre(:,:,1));
            out.sigma = squeeze(obj.sigma(:,:,1));
            out.windowOrientation = squeeze(obj.windowOrientation(:,1));
            out.frequency = squeeze(obj.frequency(:,1));
            out.phase = squeeze(obj.phase(:,1));
            out.orientation = squeeze(obj.orientation(:,1));
            out.intensity = squeeze(obj.intensity(:,1));
        end
        
        function out = get.right(obj)
            % return the left gabors only
            % leftGabors = obj.left
            out = Gabor2D;
            out.centre = squeeze(obj.centre(:,:,2));
            out.sigma = squeeze(obj.sigma(:,:,2));
            out.windowOrientation = squeeze(obj.windowOrientation(:,2));
            out.frequency = squeeze(obj.frequency(:,2));
            out.phase = squeeze(obj.phase(:,2));
            out.orientation = squeeze(obj.orientation(:,2));
            out.intensity = squeeze(obj.intensity(:,2));
        end      
        
        function val = get.number(obj)
            % return the number of gabors in the set (or pairs if multiple
            % views
            % num = obj.number
            val = size(obj.frequency,1);
        end
        
        function val = get.views(obj)
            % return the number of views (i.e. pair sizes)
            % num = obj.views
            val = size(obj.frequency,2);
        end
        
        function out = select(obj, ind, vind)
            % select an individual Gabor from the collection.
            % gabor = obj.select(index)
            % gabor = obj.select(index, view)
            if nargin < 3
                vind = 1;
            end
            if ind > obj.number
                error('Index larger than number of objects (or pairs) in the collection');
            end
            if vind > obj.views
                error('Index larger than number of views in the collection');
            end
            out = Gabor2D;
            out.centre = squeeze(obj.centre(ind,:,vind));
            out.sigma = squeeze(obj.sigma(ind,:,vind));
            out.windowOrientation = squeeze(obj.windowOrientation(ind,vind));
            out.frequency = squeeze(obj.frequency(ind,vind));
            out.phase = squeeze(obj.phase(ind,vind));
            out.orientation = squeeze(obj.orientation(ind,vind));
            out.intensity = squeeze(obj.intensity(ind,vind));
        end
        
        function is = isValid(obj, varargin)
            % returns true if the gabor function is 'valid' i.e. contains
            % finite real numbers.
            %
            % is = obj.isValid
            % is = obj.isValid(ind)
            % is = obj.isValid(ind, vind)
            %
            % is - array of booleans on per gabor in the set, true if valid
            % ind - optional index to select gabor pairs
            % vind - optional index to select a particualar pair in a view.
            if nargin == 1
                selection = obj;
            else
                selection = obj.select(varargin{:});
            end
            is = all(isfinite(selection.centre),2) & all(isfinite(selection.sigma),2) & ...
                isfinite(obj.windowOrientation) & isfinite(obj.frequency) & isfinite(obj.phase) & ...
                isfinite(obj.orientation) & isfinite(obj.intensity);
        end
            
    end
    
end

