function [file_exists] = does_file_exist(ftg, code, file_type)
% Return boolean indicating if file exists

    file_exists = ~isempty(find_existing_file_for_code(ftg, code, file_type));

end