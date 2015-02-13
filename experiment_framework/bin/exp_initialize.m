function [edata, trial_data] = exp_initialize
% Run all necessary setup, including data generation and hardware prepartiong

%% initialize edata

    edata = exp_initialize_edata;

%% choose mode to run in

    [edata] = exp_admin_run_mode(edata);
    
%% subject information 

    [edata] = exp_initialize_subject(edata);

%% make sure file can be saved

    [edata] = exp_admin_save_initial(edata);
     
%% setup inputs (keyboards, keypads, fORP, joysticks)

    [edata] = exp_initialize_inputs(edata);

%% setup screen and determinegraphic locations

    [edata] = exp_initialize_display(edata);

%% setup sound

    [edata] = exp_initialize_audio(edata);

%% generate trial data

    [edata, trial_data] = exp_initialize_trial_data(edata);

%% save the variable & file

    exp_admin_save_vars(edata, trial_data);
    exp_admin_save_subject_behav(edata, trial_data);

end
