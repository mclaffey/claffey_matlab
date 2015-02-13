function [data] = dataset_add_columns(data, column_list, default_values)
% Add multiple columns to a dataset with default values
%
% [data] = dataset_add_columns(DATA, COLUMN_LIST, DEFAULT_VALUES)
%
%   For each Nth column name in COLUMN_LIST, a new column will be added with a default value of the
%   Nth element in default_values, but only if the column does not already exist in the dataset
%
%   If no default value is specified, NaN is used
%
% Example:
%   data = dataset({[1;2;3], 'trial_num'}, {[95;80;100], 'score'})
%     data = 
%         trial_num    score
%         1             95  
%         2             80  
%         3            100
%   data = dataset_add_columns(data, {'number_wrong', 'comments'}, {0 'none'})
%     data = 
%         trial_num    score    number_wrong    comments
%         1             95      0               none    
%         2             80      0               none    
%         3            100      0               none     

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/27/08 minor fix to handle string default values
% 10/23/08 corrected so columns are appended in the order the are passed;
% 09/20/08 original version

%% error checking
    if isempty(data) || ~isa(data, 'dataset')
        error('DATA must be a dataset')
    end
    if ~exist('column_list', 'var') || isempty(column_list)
        return
    elseif ischar(column_list)
        column_list = {column_list};
    elseif ~iscell(column_list)
        error('COLUMN_LIST must be a cell array')
    end
    if ~exist('default_values', 'var') || isempty(default_values)
        default_values = repmat({NaN}, 1, length(column_list));
    elseif ~iscell(default_values)
        default_values = {default_values};
    end
    if length(column_list) ~= length(default_values)
        error ('COLUMN_LIST and DEFAULT_VALUES must be cells of the same length')
    end
        

%% determine what columns need to be added
    [junk, idx] = setdiff(column_list, get(data, 'VarNames'));
    
    % setdiff tends to scramble to order, so sort so that columns are appended in the order they
    % were passed as an argument
    idx = sortrows(idx')';
    missing_columns = column_list(idx);
    default_values = default_values(idx);

%% add the missing columns    
    row_count = size(data,1);
    warning off stats:dataset:subsasgn:DefaultValuesAdded
    for i = 1:length(missing_columns)
        the_default_value = default_values{i};
        if ischar(the_default_value), the_default_value = {the_default_value}; end;
        data.(missing_columns{i}) = repmat(the_default_value, row_count,1);
    end
    warning on stats:dataset:subsasgn:DefaultValuesAdded
end
