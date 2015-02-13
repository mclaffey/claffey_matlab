function [codes] = sort_codes(codes)
% Sort the codes, with an attempt to sort the strings numerically    
    
    try
        % try converting to numbers, sorting, and back to cell array of strings
        codes = cellfun(@str2double, codes, 'UniformOutput', false);
        codes = cell2mat(codes);
        codes = sort(codes);
        codes = mat2cell_same_size(codes);
        codes = cellfun(@num2str, codes, 'UniformOutput', false);
    catch
        % if that fails, just sort as strings
        codes = sort(codes);
    end
end