function [html] = dataset_html_display(data, max_rows_to_show)
% Produce html to display a dataset
%
% [html] = dataset_html_display(data)
%
% [html] = dataset_html_display(data, max_rows_to_show)
%
%   Truncates the dataset to the specified number of rows. Default is 50. Enter a negative number to
%   show all rows regardless of size.
%
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/27/09 fixed bug when there was a column of an empty matrix
% 05/29/09 added max_rows_to_show
% 04/24/09 added support for ordinals
% 04/17/09 added observation names column
% 04/10/09 original
    
    assert(isa(data, 'dataset'), 'First argument must be a dataset');
    
%% Determine how many rows to show
    
    if ~exist('max_rows_to_show', 'var'), max_rows_to_show = 50; end;
    if max_rows_to_show >= 0 && max_rows_to_show < size(data, 1)
        truncate_message = sprintf('<p>Data truncated. Showing %d of %d rows.</p>', max_rows_to_show, size(data,1));
        data = data(1:max_rows_to_show, :);
    else
        truncate_message = '';
    end

%% setup variables    

    raw_data = struct(data);
    col_names = raw_data.varnames;
    raw_data = raw_data.data;
    [row_count, col_count] = size(data);
    data_as_str = cell(size(data));
    
    
%% convert the dataset to a cell of strings
    for col = 1:col_count
        col_data = raw_data{col};
        switch class(col_data)
            case 'double'
                if isempty(col_data)
                    col_data_as_string = repmat({'[empty]'}, row_count, 1);
                elseif ndims(col_data)==2 && size(col_data, 2) < 4
                    col_data_as_string = arrayfun(@num2str, col_data, 'UniformOutput', false);
                else
                    col_data_as_string = repmat({'matrix'}, row_count, 1);
                end
            case 'char'
                col_data_as_string = cellstr(col_data);
            case 'cell'
                col_data_as_string = any2str(col_data);
            case 'logical'
                logical_strings = {'false', 'true'};
                col_data_as_string = logical_strings(col_data + 1)';
            case {'nominal', 'ordinal'}
                col_data = nz(col_data, '<undefined>');
                nominal_strings = getlabels(col_data);
                col_data_as_string = nominal_strings(double(col_data))';
            otherwise
                %col_data_as_string = cellfun(@any2html, col_data, 'UniformOutput', false);
                col_data_as_string = repmat({sprintf('%s?', class(col_data))}, row_count, 1);
        end
        if ischar(col_data_as_string), col_data_as_string = {col_data_as_string}; end;
        data_as_str(:, col) = col_data_as_string;
    end
    
%% add the column names
    data_as_str = vertcat(col_names, data_as_str);
    
%% add the observations (if applicable)
    obs_names = get(data, 'ObsNames');
    if ~isempty(obs_names)
        obs_names = vertcat({'*ObsNames'}, obs_names);
        data_as_str = horzcat(obs_names, data_as_str);
    end

%% create html
    
    html = cell2html(data_as_str, true, true);
    html = [html, truncate_message];

end