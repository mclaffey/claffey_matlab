function [template] = apply_code_to_template(ftg, code, file_type, dates_as_wildcards)
    
    template = get_template(ftg, file_type);
    
    % convert numeric codes to str
    if isnumeric(code), code = num2str(code); end;    
    
    % substitute in code
    template = strrep(template, '#CODE#', code);
    
    % convert DATE and TIME fields
    if dates_as_wildcards
        template = strrep(template, '#DATE#', '*');
        template = strrep(template, '#TIME#', '*');
    else
        template = strrep(template, '#DATE#', datestr(now, 'mmm-dd-yyyy'));
        template = strrep(template, '#TIME#', strtrim(datestr(now, 'HH-MM-AM')));    
    end
    
    % prepend the base dir
    template = fullfile(ftg.base_dir, template);
    
end