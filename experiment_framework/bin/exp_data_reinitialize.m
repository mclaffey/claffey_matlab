function [edata, trial_data] = exp_data_reinitialize(edata, trial_data)
    
    if input_yesno('Are you sure you want to delete and replace all data?')
        [edata, trial_data] = exp_initialize_trial_data(edata);
    end

end