function [file_path] = find_existing_file_for_code(ftg, code, file_type)
% Attempt to find an existing file matching the code and template
    
%% build search template

    % get template
    template = apply_code_to_template(ftg, code, file_type, true);
    template_dir = fileparts(template);
    
%% search for any files that match

    found_files = dir(template);
    
%% handle search results

    if isempty(found_files)
        file_path = '';
        
    elseif length(found_files) == 1
        file_path = fullfile(template_dir, found_files.name);
        
    else
        error('More than one file matched subject code');
    end
    
end    