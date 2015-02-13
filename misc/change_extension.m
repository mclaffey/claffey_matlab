function [new_file_name] = change_extension(file_name, new_extension)

    [file_dir, file_name] = fileparts(file_name);
    if ~exist('new_extension', 'var') || isempty(new_extension)
        new_file_name = fullfile(file_dir, file_name);
    else
        while ~isempty(new_extension) && new_extension(1) == '.'; new_extension(1) = ''; end; 
        new_file_name = sprintf('%s.%s', fullfile(file_dir, file_name), new_extension);
    end        
    
end