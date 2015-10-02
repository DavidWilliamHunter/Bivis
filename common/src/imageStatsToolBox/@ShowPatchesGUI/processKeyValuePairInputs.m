function [ obj ] = processKeyValuePairInputs(obj, varargin )
% take a set of inputs in the form of key, value pairs and return a struct
offset = 1;
while offset <= length(varargin)
    property_name = varargin{offset};
    offset = offset + 1;
    if offset>length(varargin)
        error('show: arguements must follow key value pairing');
    end
    property_value = varargin{offset};
    offset = offset + 1;
    obj.set(property_name, property_value);
end

end

