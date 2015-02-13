function [codes] = files2codes(ftg, file_type)
   
    % get template
    template = get_template(ftg, file_type);
    
    % convert the code_template to a search template
    search_template = template;
    search_template = strrep(search_template, '#CODE#', '*');
    search_template = strrep(search_template, '#DATE#', '*');
    search_template = strrep(search_template, '#TIME#', '*');
    
    % begin search
    [codes] = files2codes_navigate_dir(ftg.base_dir, search_template, template);
    
end