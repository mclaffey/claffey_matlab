function [data2] = dataset_rows2cols(data1, row_fields, index_fields, data_fields)
% Transposes rows in a dataset to multiple columns
%
% [data2] = dataset_rows2cols(data1, row_fields, index_fields, data_fields)


% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 06/11/11 clean up problems with index_fields_values
%          added documentation to section dealing with first index_field value
% 11/04/09 fixed bug by converting ordinal/nominal index values to cell array
% 08/13/09 added ability to call without row_fields specified


%% set up variables  
    if isempty(row_fields)
        data1 = dataset_add_columns(data1, 'temp_col_dataset_row2cols', 1);
        row_fields = {'temp_col_dataset_row2cols'};
    end
    if ~iscell(row_fields), row_fields = {row_fields}; end;
    if size(row_fields, 2) > 1, row_fields = row_fields'; end;
    if ~iscell(index_fields), index_fields = {index_fields}; end;
    if size(index_fields, 2) > 1, index_fields = index_fields'; end;
    index_fields = flipud(index_fields);
    if ~exist('data_fields', 'var') || isempty(data_fields)
        data_fields = setdiff(get(data1, 'VarNames'), vertcat(row_fields, index_fields));
    end
    if ~iscell(data_fields), data_fields = {data_fields}; end;
    if size(data_fields, 2) > 1, data_fields = data_fields'; end;
    
    % 6/10/11 - removed this command. the data rows were out of order with
    % this command included, not sure why I ever added it
    % data_fields = flipud(data_fields);
    
    index_field = index_fields{1};
    unused_index_fields = flipud(index_fields(2:end));
    index_fields_values = unique(data1.(index_field));
    
    % 6/10/11 there was a problem where index_fields_values contained
    % unused values for a nomimal. the fixes below attempt to rememdy this
    % as well as clean up what appears to be some sloppy code

    % 6/10/11 - remove section below
%     % if index values are a nominal or ordinal, convert to a cell array
%     if isa(index_fields_values, 'ordinal') || isa(index_fields_values, 'nominal')
%         index_fields_values = getlabels(index_fields_values);
%     end

    join_key_fields = vertcat(row_fields, unused_index_fields);
        
    switch class(index_fields_values)
        case 'nominal'
            % 6/10/11 use this version below
            index_fields_values = nominal_to_cell(index_fields_values);
            %index_fields_values = getlabels(droplevels(index_fields_values))';
    end
    
%% iterate through each value of the first index_field

    
    
    for x = 1:length(index_fields_values)
        
        % get index value depending on variable type
        if iscell(index_fields_values)
            index_fields_value = index_fields_values{x};
        elseif isnumeric(index_fields_values)
            index_fields_value = index_fields_values(x);
        else
            error('not sure how to handle index_fields_value of type %s', class(index_fields_values));
        end
            
        data_temp = data1(data1.(index_field)==index_fields_value, vertcat(row_fields, data_fields, unused_index_fields));
        data_temp.key = dataset_merge_columns(data_temp, join_key_fields);
        old_warnings = warning('off', 'stats:dataset:setvarnames:ModifiedVarnames');
        data_temp = dataset_append_varnames(data_temp, [index_fields_value '_'], '', data_fields);
        warning(old_warnings);
        
        if x == 1
            data2 = data_temp;
        else
            
            % check that all key values exist
            data2_keys = unique(data2.key);
            data_temp_keys = unique(data_temp.key);
            missing_keys = setdiff(data2_keys, data_temp_keys);
            
            % through error if the join isn't going to work
            if ~isempty(missing_keys)
                fprintf('Missing keys:\n');
                disp(missing_keys);
                error('The keys above do not have all row values and need to be excluded');
            end            
            
            data_temp(:, {row_fields{:}, unused_index_fields{:}}) = [];
            data2 = join(data2, data_temp);
        end
    end

    data2 = set(data2, 'ObsName', data2.key);
    data2.key = [];
    
%% recursive processing of additional index_fields

    if ~isempty(unused_index_fields)
        new_data_fields = setdiff(get(data2, 'VarNames'), vertcat(row_fields, unused_index_fields));
        data2 = dataset_rows2cols(data2, row_fields, unused_index_fields, new_data_fields);
        
        % fix column order
        data_col_count = size(data2,2) - length(row_fields);
        data_field_count = length(data_fields);
        data_set_count = data_col_count / data_field_count;
        data_col_order = repmat([1:data_set_count]' * length(data_fields), 1, data_field_count) + ...
                    repmat([1:data_field_count], data_set_count, 1) ...
                    + length(row_fields) ...
                    - 1;
        data_col_order = flipud(data_col_order);
        col_order = [1:length(row_fields) data_col_order(:)'];
        data2 = data2(:, col_order);
    end
    
%% clean up

    if isequal(row_fields, {'temp_col_dataset_row2cols'})
        data2.temp_col_dataset_row2cols = [];
    end
    
end