function [data_struct, already_existed] = assert_field(data_struct, field_name, default_value)
% Adds a field to a structure if it does not already exist, with an optional default value
%
% [a, already_existed_boolean] = assert_field(a, field_name, default_value)
    
    if ~exist('default_value', 'var'), default_value = []; end;    
    already_existed = isfield(data_struct, field_name);    
    if ~already_existed, data_struct.(field_name) = default_value; end;
    
end