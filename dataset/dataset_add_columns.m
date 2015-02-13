function [data] = dataset_add_columns(data, varargin)
% Add multiple columns to a dataset with default values
%
% [data] = dataset_add_columns(DATA, field_1, default_value_1, [field_n, default_value_n])
%
%   The arguments after DATA are pairs of field names (as a string) and default values (any type).
%
% [data] = dataset_add_columns(DATA, COLUMN_LIST [, DEFAULT_VALUES])
%
%   Both COLUMN_LIST and DEFAULT_VALUES are cell arrays of equal length. For each Nth column name in
%   COLUMN_LIST, a new column will be added with a default value of the Nth element in
%   default_values, but only if the column does not already exist in the dataset
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

% 03/03/09 fixed bug with name-value pairs
% 02/17/09 added capability for name-value pairs
% 10/27/08 minor fix to handle string default values
% 10/23/08 corrected so columns are appended in the order the are passed;
% 09/20/08 original version

%% error checking
    assert(isa(data, 'dataset'), 'DATA must be a dataset')
    
    if nargin < 2
        error('Must provide at least 2 arguments')
        
    % for the COLUMN_LIST / no DEFAULT_VALUES form of the function
    %   dataset_add_columns(data, column_list)
    elseif nargin==2
        column_list = varargin{1};
        if ischar(column_list), column_list = {column_list}; end;
        assert(iscell(column_list), 'The second argument must be a string or cell')
        default_values = mat2cell_same_size(nan(1, length(column_list)));
        % now continue performing function below
        
    % for the COLUMN_LIST / DEFAULT_VALUES form of the function
    %   dataset_add_columns(data, {column_list}, {default_values_list})
    elseif nargin==3 && iscell(varargin{1}) && iscell(varargin{2})
        column_list = varargin{1};
        default_values = varargin{2};
        assert(length(column_list)==length(default_values), 'COLUMN_LIST must be the same length as DEFAULT_VALUES');
        % now continue performing function below

    % for the name-value pair form of the function
    %   dataset_add_columns(data, column1, value1, column2, value2, ...)
    elseif mod(nargin,2)==1
        column_list = varargin(1:2:end);
        default_values = varargin(2:2:end);
        assert(iscellstr(column_list), 'Appear to be using dataset_add_columns(data, name1, value1, name2, value2, ...) but not all nameN arguments are strings')
        % rethrow the function using the alternate form
        [data] = dataset_add_columns(data, column_list, default_values);
        return        
    else
        error('Must provide one default value for each addition column name')
        
    end
        

%% determine what columns need to be added
    [junk, missing_column_idx] = setdiff(column_list, get(data, 'VarNames'));
    
    % setdiff tends to scramble the order, so sort numerically (their original order)
    missing_column_idx = sortrows(missing_column_idx')';
    
    % grab data for only the columns that need to be added
    missing_columns = column_list(missing_column_idx);
    default_values = default_values(missing_column_idx);

%% add the missing columns    
    row_count = size(data,1);
    warning off stats:dataset:subsasgn:DefaultValuesAdded
    for i = 1:length(missing_columns)
        the_default_value = default_values{i};
        if ischar(the_default_value), the_default_value = {the_default_value}; end;
        if row_count == 0
            data = dataset({the_default_value, missing_columns{i}});
            row_count = 1;
        else
            data.(missing_columns{i}) = repmat(the_default_value, row_count,1);
        end
    end
    warning on stats:dataset:subsasgn:DefaultValuesAdded
    
end
