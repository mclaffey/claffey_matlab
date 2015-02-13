function [template] = get_template(ftg, file_type)
% Return the template for a given file type 

    file_type_index = find(strcmpi(file_type, {ftg.file_types.name}));
    
    if isempty(file_type_index)
        error('Could not find file type %s', name);
    end
    
    template = ftg.file_types(file_type_index).template;
    
    % make sure the template does end with a filesep
    while strcmpi(template(end), filesep), template(end)=[]; end;

end