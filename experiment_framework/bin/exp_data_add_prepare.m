function [edata, trial_data] = exp_data_add_prepare(edata, trial_data)
    
%% specify how many / what kind of trials will be created

    edata.create_data_specs = [];
    
%% add the trials

    [edata, trial_data] = exp_data_create_trials(edata, trial_data);
    
%% remove edata.data_trial

    edata = rmfield(edata, 'create_data_specs');

end