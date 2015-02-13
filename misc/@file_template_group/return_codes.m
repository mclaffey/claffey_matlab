function [code_cell_array] = return_codes(ftg, file_types)
% Determine what codes are in use based on existing files
%
% Return codes for all file types   
%
%   [code_cell_array] = return_codes(ftg)
%
% Return codes for a specific file type
%
%   [code_cell_array] = return_codes(ftg, file_type)

% Copyright 2009 Mike Claffey
%
% 10/16/09 original version

    code_cell_array = {};

%% if file_type wasn't specified, default to all

    if ~exist('file_type', 'var') || isempty(file_type)
        file_types = {ftg.file_types.name};
    end
    
%% aggregate codes for requested file types

    for x = 1:length(file_types)
        partial_code_cell_array = files2codes(ftg, file_types{x});
        code_cell_array = union(code_cell_array, partial_code_cell_array);
    end
    
%% sort

    code_cell_array = sort_codes(code_cell_array);
    
end
