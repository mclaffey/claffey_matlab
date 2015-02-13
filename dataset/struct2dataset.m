function [b] = struct2dataset(a)
% Convert a structure to a dataset
%
% [b] = struct2dataset(a)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/30/09 fixed to be able to handle structures with length > 1
% 03/25/09 original version
    
    % get the field names for column names
    col_names = fieldnames(a)';
    
    % take the structure data and wrangle it into shape
    col_values = struct2cell(a);
    col_values = reshape(col_values, [size(col_values,1), size(col_values,3)]);
    col_values = col_values';
    
    % convert to dataset
    b = dataset({col_values, col_names{:}});
    
    % if there are any entirely numeric columns wrapped as a cell, convert them to matrix
    warning('off', 'dataset_numericize_fields:field_convert_field');
    b = dataset_numericize_fields(b);
    
    % if there are any columns that have nominal values wrapped as a cell, unite them
    col_names = get(b, 'VarNames');
    for col_num = 1:size(b, 2)
        col_name = col_names{col_num};
        col_data = b.(col_name);
        if iscell(col_data) && size(col_data, 1) >= 1 && isa(col_data{1}, 'nominal')
            nominal_col_data = nominal();
            for row_num = 1:size(col_data, 1)
                nominal_col_data = vertcat(nominal_col_data, col_data{row_num});
            end
            b.(col_name) = nominal_col_data;
        end
    end
    
end