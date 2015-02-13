function [edata, trial_data] = exp_run(edata, trial_data)
% Prepares screen and runs through each trial in trial_data

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 10/13/09 added ListenChar (originally was in exp_trial_get_response)
    
%% ensure that the stop flag is cleared

    edata.run_mode.stop_asap = false;
    
%% check trial_data

    [edata, trial_data] = exp_data_check(edata, trial_data);
    if edata.run_mode.stop_asap, return; end;
    
%% suppress keyboard output
% don't do this in debug mode because it makes it difficult to recover from errors
% the try-catch is because some computers have problems with this command and it's not
%   essential for the experiment to run

    if ~edata.run_mode.debug
        try
            ListenChar(2);
        catch
            warning('ListenChar(2) isn''t working properly');
        end
    end

    
%% start the PsychToolbox screen

    [edata] = exp_display_start(edata);

%% iterate until all lines have been completed

    while ~all(trial_data.complete) && ~edata.run_mode.stop_asap
        
        %% if escape key is down, stop experiment
        if get_key_press(edata.inputs.main_keyboard_index, -1, 'escape', false)
            exp_stop(edata, trial_data);
            edata.run_mode.stop_asap = true;
            continue % skip the current loop and subsequently exit
        end
        
        % save data variables in current state
        exp_admin_save_vars(edata, trial_data);

        % find first incomplete trial
        edata.current_trial = find(~trial_data.complete, 1, 'first');

        % take any needed action at the beginning of a new block
        [edata, trial_data] = exp_block_start(edata, trial_data);

        % actual trial - get response and process
        [edata, trial_data] = exp_trial(edata, trial_data);

        % save after each trial
        exp_admin_save_vars(edata, trial_data);
        exp_admin_save_subject_behav(edata, trial_data);

        % provide feedback before transition to next block and on last trial
        [edata, trial_data] = exp_block_end(edata, trial_data);

        %% display recent trial feedback command line for checking status
        exp_trial_feedback_command_window(edata, trial_data);

        % if the stop flag has been set, exit nicely
        if edata.run_mode.stop_asap, exp_stop(edata, trial_data), end;

    end

%% end experiment    
    if all(trial_data.complete)
        exp_stop(edata, trial_data);
        fprintf('Completed all available trials.\n')
    end
    
end
