function [found_ids] = get_ids(ef)
% Returns all found IDs

    [file_names_as_list, file_names_by_idx, found_ids] = get_file_names(fullfile(ef.base_dir, ef.template), ef.search_ids, true);
    
end