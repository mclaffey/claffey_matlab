function [trial_data] = exp_data_format(edata, trial_data)
% Add all necessary columns, change column format and order

%% columns added by this function       

    % general tracking values
        % subject id
        % trial number
                
    % needed for experiment framework
        % start time (the GetSecs when the trial starts)
        % duration (GetSecs when the trial ends minus start time)
        % complete (true or false)
        
    % STOP SIGNAL TASK (DEMO)
        % ssd - stop signal delay (NaN for go trials)
        % left_rt - reaction time when left key is pressed
        % right_rt - reaction time when right key is pressed
        % rt - reaction time (a single column based on either left or right rt)
        % outcome - string describing outcome of the trial
        % correct - true/false indicating if trial was performed correctly
            
%% column reordering        
        
    % the column_order cell array determines the order of the columns in trial_data.
    %
    % column order of datasets does not matter to matlab*, this is just for user
    % convenience. [ *NOTE: ...as long as you are using column-name referencing in 
    % your code, like data(:, 'trial_num') as opposed to column-number referencing
    % like data(:, 1) ]
    %
    % column_order is used by code at the end of this function to change the column
    % order. To protect against omissions, an error is thrown if column_order contains
    % a name that is not in the data itself, or the data contains a column that is not
    % listed in column_order.
    
    column_order = { ...
        'subject', ...
        'block', ...
        'trial_num', ...
        'trial_type', ...
        'direction', ...
        'staircase_index', ...
        'ssd', ...
        'start_time', ...
        'duration', ...
        'complete', ...
        'left_rt', ...
        'right_rt', ...
        'rt', ...
        'outcome', ...
        'correct' ...
        }; % the line above is the only one that should not have a comma in it

%% fix columns

    % add columns that have the same (initial) value for all rows
    trial_data = dataset_add_columns(trial_data, ...
        'subject', edata.subject_id, ...
        'ssd', NaN, ...
        'start_time', NaN, ...
        'duration', NaN, ...
        'complete', false, ...
        'left_rt', NaN, ...
        'right_rt', NaN, ...
        'rt', NaN, ...
        'outcome', 'incomplete', ...
        'correct', NaN ...
        ); % the last line above should not end with a comma
    
    % add a trial_num column of consecutive integers
    trial_data.trial_num = transpose(1:size(trial_data,1));
    
    % change column types
    trial_data = dataset_nominalize_fields(trial_data, {'outcome'});

    
%% redorder columns

    % this is the code that reorders the columns to match the column_order variable
    % at the beginning of the script. Nothing here needs to be customized.

    missing_fields = setxor(get(trial_data, 'VarNames'), column_order);
    if ~isempty(missing_fields)
        fprintf('Bad fields:\n');
        disp(missing_fields)
        error('The above columns are not handled properly in the column reording process')
    end    
    trial_data = trial_data(:, column_order);
    
end
