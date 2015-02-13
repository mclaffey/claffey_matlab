function struct_size(a)
% Report the size of fields of a structure
%
%   Useful for diagnosis large structures;
%
%   struct_size(a)


    field_names = fieldnames(a);
    field_count = length(field_names);
    
    for field_index = 1:field_count;
        
        field_name = field_names{field_index};
        field_var = a.(field_names{field_index});
        field_info = whos('field_var');
        
        field_size_kb = field_info.bytes / 1000;
        
        size_str = sprintf('%7.1f kb', field_size_kb);
        
        fprintf('%s\t%s\n', size_str, field_name);
    end
end
        