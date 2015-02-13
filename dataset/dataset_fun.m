function [b] = dataset_fun(a, group_cols, func_handle, varargin)
% Run a function on grouped subsets of a dataset and return the results as an appended dataset
%
% [b] = dataset_fun(a, group_cols, func_handle, varargin)
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/30/09 original version

    b = [];

%% check arguments
    
    assert(nargin >= 3, 'Must provide at least three arguments');
    assert(isa(a, 'dataset'), 'First argument must be a dataset');
    if ischar(group_cols), group_cols = {group_cols}; end;
    assert(iscell(group_cols), 'Second argument must be a string or cell of strings');
    assert(isa(func_handle, 'function_handle'), 'Third argument must be a function handle');

    column_names = get(a, 'VarNames');
    assert(all(ismember(group_cols, column_names)), 'Some of the grouping columns are not in the dataset');
    
%% gather information on the individual groups

    [group_ids, group_names, group_values, column_values] = dataset_grp2idx(a, group_cols);
    group_count = length(group_names);
    
%% if there are varargin arguments for the func_handle function, make them the right size

%     for x = 1:length(varargin)
%         if iscell(varargin{x})
%             if size(varargin{x},1) ~= group_count
%                 error('Varargin{%d} has length %d but there are %d groups', ...
%                     x, size(varargin{x},1), group_count);
%             end
%         else
%             varargin{x} = repmat({varargin{x}}, group_count, 1);
%         end
%     end
    
%% iterate through each group and apply the function

    for x = 1:length(group_names)
        % isolate the relevant rows
        group_data = a(group_ids==x, :);
        
        % run the function on it
        group_result = feval(func_handle, group_data, varargin{:});
        
%% if the result is a dataset, append it to b as a dataset

        if isa(group_result, 'dataset')
            
            % add the group name and column values
            group_result = [...
                dataset({nominal(group_names{x}), 'group_name'}), ...
                column_values(x, :), ...
                group_result ]; %#ok<AGROW>
                        
            % append it to the output argument
            b = dataset_append(b, group_result);
            
%% if the result is anything besides a dataset, return the results as a cell array
        else
            b{end+1} = group_result; %#ok<AGROW>
        end        
    end
    
end