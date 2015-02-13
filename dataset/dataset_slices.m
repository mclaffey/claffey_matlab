function [slices] = dataset_slices(a, slice_cols, data_cols, feedback_text)
% Organizes data by various dimensions for online analysis

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 01/26/09 feedback text
% 06/01/08 original version

    slices = struct();
    if ischar(slice_cols), slice_cols = {slice_cols}; end;
    if ischar(data_cols), data_cols = {data_cols}; end;
    if ~exist('feedback_text', 'var'), feedback_text = ''; end;

%% save record of all data
    slices.data = a;
    
%% consolidate data columns
    for x = 1:length(data_cols)
        slices.(data_cols{x}) = a.(data_cols{x});
    end

%% if there are no slice columns, return the slices as is
    if isempty(slice_cols), return; end;
    
%% process each slice column
    for x = 1:length(slice_cols)
        col_name = slice_cols{x};
        
        slices.(col_name) = struct;
        other_col_names = setdiff(slice_cols, col_name);
        col_values = a.(col_name);
        label_list = unique(col_values);
                
        for slice_num = 1:length(label_list)
            % construct the slice name
            label_value = label_list(slice_num);
            if ~isnumeric(label_value)
                label_name = any2str(label_value);
                % this catches nominals which evaluate to a number and can't be used as structure field
                if ~strcmpi(label_name, 'true') & str2num(label_name), label_name = ['n', label_name]; end;
            elseif label_value == fix(label_value)
                label_name = sprintf('n%d', label_value);
            elseif isnumeric(label_value)
                warning('Creating a slice for value %s: %f, which is not an integer', col_name, label_value) %#ok<WNTAG>
                label_name = sprintf('n%f', label_value);
            end
            
            % provide feedback
            if ~isempty(feedback_text)
                recursive_feedback_text = sprintf('%s...%s(%s)', feedback_text, col_name, label_name);
                fprintf('%s\n', recursive_feedback_text);
            else
                recursive_feedback_text = '';
            end
            
            relevant_rows = (col_values == label_value);
            relevant_data = a(relevant_rows, :);
            slices.(col_name).(label_name) = dataset_slices(relevant_data, other_col_names, data_cols, recursive_feedback_text);
        end
    end
end
