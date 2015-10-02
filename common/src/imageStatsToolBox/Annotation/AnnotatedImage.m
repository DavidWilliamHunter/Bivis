classdef AnnotatedImage
    % This class holds annotations about a particular image. The actual
    % details of the annotation may be held by a sub-class, however this
    % class describes the interface.
    %
    % Image annotations must contain two pieces of information, a location
    % and a value. Annotations are accessed by location.
    %
    % A sub-class does not need to implement all access methods, however
    % this will reduce the number of algorithms the sub-class can work
    % with.
    %
    % Locatations follow the same dimensional ordering as image sets,
    % x-axis, y-axis, view-axis, layer.
    % How many of these are need depends on the algorithm, (in general the
    % layer is un-important).
    
    properties
    end
    
    methods(Abstract)
        [ values ] = getAnnotationByLocation(obj, loc)
        % Gets annotation(s) in a particular location.
        % [ values ] = obj.getAnnotationByLocation(loc)
        %  loc - location in the image to look for annotations (single
        %  sample). Multiple rows results in multiple lookups
        % values - annotations found, null if not found.
        [ values ] = getAnnotationByRegion(obj, loc)
        % Gets annotations by region
        % [ values ] = obj.getAnnotationByLocation(loc)
        % loc - if real valued, locations in the image to look for
        % annotations. Odd rows are the top-left of the rectangular regions,
        % even rows are the bottom right of the regions.
        % loc - if boolean array of same dimensions as the images, look for
        % annotations within true valued pixels.
        % values - annotations found in regions
        % 
        
    end
    
end

