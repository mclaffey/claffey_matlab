function [edata, trial_data] = exp_trial(edata, trial_data)
% Runs all necessary actions for a single trial (also used for practice trials)
        
%% create a variable containing only the current trial, for easy referencing in code
    td = trial_data(edata.current_trial, :);

%% the three horsemen of the trial

    [edata, td] = exp_trial_get_response(edata, td, trial_data);
    [edata, td] = exp_trial_check_response(edata, td, trial_data);
    [edata, td] = exp_trial_feedback(edata, td, trial_data);

%% save the td variable back into trial data
    [edata, trial_data] = exp_trial_save_td(edata, trial_data, td);
    
end
