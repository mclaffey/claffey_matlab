function [data] = dataset_append_varnames(data, prefix, suffix, varname_list)
% Append prefix and/or suffix to column names of a dataset
%
% [data] = dataset_append_varnames(DATA, PREFIX, SUFFIX, COLUMN_NAME_LIST)
%
% Example:
%   data = dataset({[1;2;3], 'trial_num'}, {[95;80;100], 'score'})
%     data = 
%         trial_num    score
%         1             95  
%         2             80  
%         3            100  
%   data = dataset_append_varnames(data, 's11_')
%     data = 
%         s11_trial_num    s11_score
%         1                 95      
%         2                 80      
%         3                100      
%   data = dataset_append_varnames(data, [], '_filtered', {'s11_score'})
%     data = 
%         s11_trial_num    s11_score_filtered
%         1                 95               
%         2                 80               
%         3                100     
%
% See-also: dataset_rename_column

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 09/20/08 original version


%% error checking
    if isempty(data) || ~isa(data, 'dataset')
        error('DATA must be a dataset')
    end
    if ~exist('prefix', 'var') || isempty(prefix)
        prefix = '';
    elseif ~ischar(prefix)
        error('PREFIX must be a string')
    end
    if ~exist('suffix', 'var') || isempty(suffix)
        suffix = '';
    elseif ~ischar(suffix)
        error('SUFFIX must be a string')
    end
    if ~exist('varname_list', 'var')
        varname_list = get(data, 'VarNames');
    elseif ischar(varname_list)
        varname_list = {varname_list};
    elseif ~iscell(varname_list)
        error('COLUMN_NAME_LIST must be a cell array of column names')
    else
        unknown_columns = setdiff(varname_list, get(data, 'VarNames'));
        if ~isempty(unknown_columns)
            for x = 1:length(unknown_columns)
                fprintf('Unrecognized column: %s\n', unknown_columns{x});
            end
            error('Unrecognized columns')
        end
    end
    
%% perform append
    all_columns = get(data, 'VarNames');
    for x = 1:length(all_columns)
        current_column = all_columns{x};
        if ismember(current_column, varname_list)
            current_column = [prefix, current_column, suffix]; %#ok<AGROW>
            all_columns{x} = current_column;
        end
    end
    data = set(data, 'VarNames', all_columns);
    
end
    