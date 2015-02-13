function [codes] = files2codes_navigate_dir(in_directory, search_template, code_template)
    
    codes = {};
    
    assert(~isempty(search_template), 'Search template was empty');
    
    % get the next part of the search template
    [search_template, search_template_remainder] = strtok(search_template, filesep);
    [code_template, code_template_remainder] = strtok(code_template, filesep);
    
    % find matching files/directories in the file system
    matching_files = dir(fullfile(in_directory, search_template));
        
    % if there is more search template to match, keep navigating directories
    if ~isempty(search_template_remainder)
    
        for x = 1:length(matching_files)
            if matching_files(x).isdir
                directory_name = fullfile(in_directory, matching_files(x).name);
                [new_codes] = files2codes_navigate_dir(directory_name, search_template_remainder, code_template_remainder);
                codes = vertcat(codes, new_codes);
            end
        end

    % if we are at the end of the search template, try to match files
    else
        
        for x = 1:length(matching_files)
            file_name = matching_files(x).name;
            [new_codes] = files2codes_check_file(file_name, code_template);
            codes = vertcat(codes, new_codes);
        end        
    end
            
end
        