function [new_trial_data] = exp_data_format_trials(new_trial_data, column_definition)

% Copyright 2009 Mike Claffey [mclaffey[]ucsd.edu)
%
% 09/01/09 improved error for missing column definitions
    
%% check_column_definitions

    missing_from_definitions = setdiff(get(new_trial_data, 'VarNames'), column_definition(:,1));
    if ~isempty(missing_from_definitions)
        missing_text = '';
        for x = 1:length(missing_from_definitions);
            missing_text = [missing_text, sprintf('\t%s\n', missing_from_definitions{x})]; %#ok<AGROW>
        end
        exp_initialize_edata_link = link_text('edit', 'exp_initialize_edata');
        error('The following columns are not defined in column_definitions in %s\n%s', ...
            exp_initialize_edata_link, missing_text);
    end
    
%% add_default_columns

    current_columns = get(new_trial_data, 'VarNames');
    is_column_missing = ~ismember(column_definition(:,1), current_columns);
    missing_columns = column_definition(is_column_missing, :)';
    new_column_arg = missing_columns(:)';
    new_trial_data = dataset_add_columns(new_trial_data, new_column_arg{:});

%% change column types

    % if there is a column with data type information
    if size(column_definition,2) >= 3
        
        % numeric columns
        numeric_columns = strcmpi(column_definition(:,3), 'number');
        numeric_columns = column_definition(numeric_columns,1);    
        new_trial_data = dataset_numericize_fields(new_trial_data, numeric_columns);
        
        % nominal (text) columns
        nominal_columns = strcmpi(column_definition(:,3), 'text');
        nominal_columns = column_definition(nominal_columns,1);    
        new_trial_data = dataset_nominalize_fields(new_trial_data, nominal_columns);
        
    end
        
%% resort_column_order

    new_trial_data = new_trial_data(:, column_definition(:,1)');
    
end