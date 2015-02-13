function [group_ids, group_names, group_values, column_values] = dataset_grp2idx(a, group_cols)
% Creates an index column from grouping columns
%
%   [group_ids, group_names, group_values, column_values] = dataset_grp2idx(a, group_cols)

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/09/09 added column_values dataset as output
% 05/27/09 added handling of empty group_col variable
% 05/22/09 moved column merging functionality to dataset_merge_columns
% 04/47/09 added support for logical values
% 04/01/09 overhauled label building to be much faster
% 10/05/08 improved error handling
% 09/01/08 original version

%% error checking
    if ~isa(a, 'dataset')
        error('First argument must be a dataset')
    end
    if ~exist('group_cols', 'var'), group_cols = get(a, 'VarNames'); end;
    if ischar(group_cols), group_cols = {group_cols}; end;
    unknown_cols = setdiff(group_cols, get(a, 'VarNames'));
    if ~isempty(unknown_cols)
        error('Unknown grouping column: %s', unknown_cols{1})
    end
    
%% SPECIAL CASE: if no group_cols are specified, return all data as a single group
    if isempty(group_cols)
        warning('dataset_grp2inx:empty_group_col', 'GROUP_COLS argument was empty, return dataset as one group');
        group_values = ones(size(a,1),1);
        group_ids = ones(size(a,1),1);
        group_names = 1;
        return
    end

%% determine grouping
    group_values = dataset_merge_columns(a, group_cols);
    [group_ids, group_names] = grp2idx(group_values);
    
%% create a dataset of the actual column values

    column_values = dataset();
    for x = 1:length(group_names)
        example_row_of_group = find(group_ids==x,1);
        column_values = dataset_append(column_values, a(example_row_of_group, group_cols));
    end
    column_values = set(column_values, 'ObsNames', group_names);

end