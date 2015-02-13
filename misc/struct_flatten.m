function [b] = struct_flatten(a)
% Takes a structure and brings all sub fields to the top level
%
% [b] = struct_flatten(a)
%
% Example:
%
%   > my_struct = struct('my_val', 1, 'my_parent_field', struct('my_sub_val', 2))
%
%   my_struct = 
%            my_val: 1
%   my_parent_field: [1x1 struct]
%
%   > struct_flatten(my_struct)
%
%   ans = 
%                        my_val: 1
%    my_parent_field_my_sub_val: 2
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/03/09 original version
%

    
    field_names = fieldnames(a);
    for x = 1:length(field_names);
        field_name = field_names{x};
        field_data = a.(field_name);
        if ~isstruct(field_data)
            b.(field_name) = field_data;
        else
            field_data = struct_flatten(field_data);
            field_data = append_struct_field_names(field_data, field_name);
            b = catstruct(b, field_data);
        end
    end
    
    function [appended_struct] = append_struct_field_names(struct_to_be_appended, append_string)
        appended_struct = struct;
        append_field_names = fieldnames(struct_to_be_appended);
        for field_num = 1:length(append_field_names)
            unappended_field_name = append_field_names{field_num};
            appended_field_name = sprintf('%s_%s', append_string, unappended_field_name);
            appended_struct.(appended_field_name) = struct_to_be_appended.(unappended_field_name);
        end
    end
    
end