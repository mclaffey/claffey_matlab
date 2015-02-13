function [merged_column] = dataset_merge_columns(a, merge_cols)
% Creates a column by merging values in each row across several columns
%
% [merged_column] = dataset_merge_columns(a, merge_cols)

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 11/03/09 added ordinal support
% 05/22/09 uses the (faster) code that was originally in dataset_grp2idx
%           dataset_grp2idx now calls dataset_merge_columns
% 10/05/08 improved error handling
% 09/01/08 original version

%% error checking
    if ~isa(a, 'dataset')
        error('First argument must be a dataset')
    end
    if ~exist('merge_cols', 'var') || (ischar(merge_cols) && strcmp(merge_cols, ':')), merge_cols = get(a, 'VarNames'); end;
    if ischar(merge_cols), merge_cols = {merge_cols}; end;
    unknown_cols = setdiff(merge_cols, get(a, 'VarNames'));
    if ~isempty(unknown_cols)
        error('Unknown column: %s', unknown_cols{1})
    end

%% build a group labels column

    row_count = size(a,1);
    merged_column = cell(row_count,1);
    for x = 1:length(merge_cols)
        
        if x == 1
            spacer = '';
        else
            spacer = '_';
        end
        
        col_data = a.(merge_cols{x});
        
        if isnumeric(col_data)
            merged_column = cellfun_easy(@sprintf, '%s%s%d', merged_column, spacer, col_data);

        elseif iscell(col_data) && isnumeric(col_data{1})
            merged_column = cellfun_easy(@sprintf, '%s%s%d', merged_column, spacer, col_data);
        
        elseif iscell(col_data) && ischar(col_data{1})
            merged_column = cellfun_easy(@sprintf, '%s%s%s', merged_column, spacer, col_data);
            
        elseif isa(col_data, 'nominal') || isa(col_data, 'ordinal')
            merged_column = cellfun_easy(@sprintf, '%s%s%s', merged_column, spacer, cellstr(char(col_data)));
            
        elseif isa(col_data, 'logical')
            logical_values = {'false', 'true'};
            col_data = logical_values(double(col_data)+1);
            col_data = transpose(col_data);
            merged_column = cellfun_easy(@sprintf, '%s%s%d', merged_column, spacer, col_data);
            
        else
            error('Can not handle group column %s', merge_cols{x});
        end
    end

end