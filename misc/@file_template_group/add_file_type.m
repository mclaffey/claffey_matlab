function [ftg] = add_file_type(ftg, name, template)
% Add a new file type
%
%   [ftg] = add_file_type(ftg, name, template)

    if ismember(name, {ftg.file_types.name})
        error('File_type %s already exists', name);
    end
    
    % don't let a template end with a directory slash
    if strcmpi(template(end), filesep)
        error('Template can not end with a file seperator');
    end
    
    ftg.file_types(end+1).name = name;
    ftg.file_types(end).template = template;
    
end