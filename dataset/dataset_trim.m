function [b, remove_rows_logical, trim_stats] = dataset_trim(a, group_col, trim_col, trim_percent)
% Trims upper and lower rows from groups within a dataset
%
% B = trim_dataset(A, GROUP_COLS, TRIM_COL, TRIM_PERCENT)
%
%   A is the input dataset
%   GROUP_COLS is a cell array of column names to group on
%   TRIM_COL is used to specify which column has the values which determine
%       which rows are trimmed
%   TRIM_PERCENT is the total to trim off the top and bottom, and is a
%       scalar from 0 to 100 (e.g. 20 trims of the bottom 10% and top 10%)
%
% Example:
%   my_data = dataset_trim(my_data, {'subject_id', 'condition'}, 'score', 10)
%
%   This command groups the rows for each subject and for each condition separately,
%   and trims the bottom 5% and top 5% of rows off for each of those groups


% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/30/08 added trim stats

%% error checking
    if isnumeric(group_col)
        group_index = group_col;
    elseif ischar(group_col)
        if ismember(group_col, get(a, 'VarNames'))
            group_index = dataset_grp2idx(a, group_col);
        else
            error('group_col ''%s'' is not a recognized column in the dataset', group_col)
        end
    else
        error('group_col must either be a grouping vector or name of a column in the dataset')
    end
    
%% for each group, trim off a percent of values
	remove_rows = [];
    group_count = length(unique(group_index));
    for group = 1:group_count
        group_rows = find(group_index==group);
        group_data = a.(trim_col)(group_rows);
        if length(group_data) > 3
            [trimmed_data, keep_index] = trim_mat(group_data, trim_percent);
            remove_rows = vertcat(remove_rows, group_rows(~keep_index));
        end
    end
    
%% now remove the data for all trimmed rows
    b = a;
    b(remove_rows, :) = [];
    
%% change remove_rows to be a logical
    remove_rows_logical = zeros(size(a,1),1);
    remove_rows_logical(remove_rows) = 1;
    remove_rows_logical = logical(remove_rows_logical);
    
%% report stats, if requested
    if nargout >= 3
        trim_stats = [];
        warning('trim stats are not yet implemented')
    end
        
    
end