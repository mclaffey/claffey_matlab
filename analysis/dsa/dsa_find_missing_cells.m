function [any_missing, missing_group_values, complete_cell_data] = dsa_find_missing_cells(data, group_col)
% Detect missing cells for a given column in a dataset
%
% [any_missing, missing_group_values, complete_data] = dsa_find_missing_cells(data, group_col)
%
%   DATA must be a dataset
%
%   GROUP_COL is a string stating the column in DATA to search for missing cells (rows)
%
%   ANY_MISSING is a boolean which is true if any instances in DATA are missing cells
%
%   MISSING_GROUP_VALUES is an array of values in the GROUP_COL column that are missing cells
%
%   COMPLETE_CELL_DATA is the DATA dataset after removing all instances of MISSING_GROUP_VALUES
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/13/09 fixed but with returning data if there were no imcomplete groups
% 05/12/09 original version

    
%% check arguments

    assert(isa(data, 'dataset'), 'First argument must be a dataset');
    assert(ischar(group_col), 'Second argument must be a string');
    assert(ismember(group_col, get(data, 'VarNames')), 'GROUP_COL must be the name of a column in DATA');
    

%% Get counts of cells and look for any group vales with missing cells
    cell_counts = grpstats(data, group_col, 'numel', 'DataVars', group_col);
    max_cell_count = max(cell_counts.GroupCount);
    rows_with_missing_cells = cell_counts.GroupCount ~= max_cell_count;
    
%% return argument for any missing values

    any_missing = any(rows_with_missing_cells);
    
%% return argument of group_col values with missing cells

    missing_group_values = cell_counts.(group_col)(rows_with_missing_cells);
    
%% return argument of data after removing instances with incomplete cells

    if isempty(missing_group_values)
        complete_cell_data = data;
    else
        complete_cell_data = data(~ismember(data.(group_col), missing_group_values), :);
    end
    
end