function [file_path] = get_file_path(ftg, code, file_type)
% For a given template and code, return either an existing file or generated path

    % try to find existing
    file_path = find_existing_file_for_code(ftg, code, file_type);
    
    % otherwise generate new
    if isempty(file_path)
        file_path = apply_code_to_template(ftg, code, file_type, false);
    end
    
end
