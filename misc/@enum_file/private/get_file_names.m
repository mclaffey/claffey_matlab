function [file_names_as_list, file_names_by_idx, found_ids] = get_file_names(template, ids, limit_to_existing)
% Generates a list of file names
%
% [file_names_as_list, file_names_by_idx, found_ids] = get_file_names(template, ids, limit_to_existing)

%% initialize variables
    if ~exist('limit_to_existing', 'var'), limit_to_existing = false; end;
    file_count = length(ids);
    file_names_by_idx = repmat({{}}, file_count, 1);
    file_names_as_list = {};
    found_ids = [];
    id_occurence_count = length(findstr(template, '%'));

%% if applicable, insert date/time stamp into template

    if limit_to_existing
        template = strrep(template, '#DATE#', '*');
        template = strrep(template, '#TIME#', '*');    
    else
        template = strrep(template, '#DATE#', datestr(now, 'mmm-dd-yyyy'));
        template = strrep(template, '#TIME#', strtrim(datestr(now, 'HH-MM-AM')));    
    end
    
%% deal with file seperaters that may be confused with sprintf escape characters

    if strcmpi(filesep, '\')
        template = strrep(template, '\', '\\');
    end
    
%% process each id
    for x = 1:length(ids)
        id = ids(x);
        id_list = mat2cell_same_size(repmat(id, 1, id_occurence_count));
        file_name = sprintf(template, id_list{:});
        file_dir = [fileparts(file_name), '/'];
        
        if ~limit_to_existing
            file_names_as_list = vertcat(file_names_as_list, file_name);
            file_names_by_idx{x} = {file_name};
        else
            found_files = dir(file_name);
            if ~isempty(found_files)                
                found_ids = vertcat(found_ids, id);
                found_files = {found_files.name}';
                found_files = cellfun(@horzcat, repmat({file_dir}, length(found_files), 1), found_files, 'UniformOutput', false);
                file_names_by_idx{x} = found_files;
                file_names_as_list = vertcat(file_names_as_list, found_files);
            end
        end
        
    end
    
end