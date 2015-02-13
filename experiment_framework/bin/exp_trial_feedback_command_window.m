function exp_trial_feedback_command_window(edata, trial_data)
    
%% check for fieldback_fields in edata

    if ~isfield(edata.columns, 'command_window_feedback')
        warning('experiment_framework:no_command_window_feedback_field', ...
            'There is no edata.columns.command_window_feedback field for providing running feedback in the command window');
        return
    end
    
    if isempty(edata.columns.command_window_feedback), return; end;

%%    
    
    feedback_fields = edata.columns.command_window_feedback;

    % throw a warning if any fields aren't recognized
    trial_data_fields = get(trial_data, 'VarNames');
    unknown_fields = setdiff(feedback_fields, trial_data_fields);
    if ~isempty(unknown_fields)
        warning('experiment_framework:unknown_cmd_feedback_fields', ...
            'The following fields are requested for feedback but are not in trial_data');
        disp(unknown_fields)
        feedback_fields = intersect(feedback_fields, trial_data_fields);
    end    
    
    feedback_data = trial_data(max(1, edata.current_trial-9):edata.current_trial, feedback_fields);
    
%% clear command window and display

    clc
    disp(feedback_data);
    
end