function [edata, trial_data] = exp_reset(edata, trial_data)
% Change current trial    

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/27/09 now only changes duration and start_time field if they already exist
%          added option to reset current block
%          other misc changes that may correct some hidden bugs

%% determine current trial and block
    
    if isfield(edata, 'current_trial')
       current_trial = edata.current_trial;
    else
       fprintf('There is no trial variable, defaulting to trial=1\n');
       current_trial = 1;
    end

    current_block = trial_data{current_trial, 'block'};
    
    fprintf('\nCurrently in block %d, at trial %d\n\n',current_block , current_trial);

%% get the menu choice

    menu_choices = {'Beginning', 'Current Block', 'To Specific Block', 'To Specific Trial', 'Rewind # of Trials'};
    menu_choice = menu_str('How do you want to reset?', menu_choices);

%% calculate the trial number

    switch menu_choice
        case 'beginning'
            reset_to_trial = 1;
            
        case 'current block'
            reset_to_trial = find(trial_data.block==current_block, 1, 'first');

        case 'to specific block'
            block_num = input('Enter block to reset to beginning of: ');
            if isempty(block_num), return; end;
            try
                reset_to_trial = find(trial_data.block==block_num, 1, 'first');
            catch
                fprintf('Could not reset to block %d, cancelling reset\n', block_num)
                return
            end

        case 'to specific trial'
            reset_to_trial = input('Enter trial (row, not trial number) to reset to: ');
            assert(reset_to_trial >= 1, 'Trial can not be less than 1');
            assert(reset_to_trial <= size(trial_data,1), 'Trial can not be more than total number of trials (%d)', size(trial_data,1));

        case 'rewind # of trials'
            rewind_count = input('Enter number of trial to rewind: ');
            if isempty(rewind_count), return; end;
            reset_to_trial = max(1, current_trial - rewind_count);
            
        case 'cancel'
            return
    end
    
%% adjust the trial data

    fprintf('Reseting to trial %d\n\n', reset_to_trial);
    last_complete_trial = find(trial_data.complete, 1, 'last');
    skipped_trials = [last_complete_trial+1 : reset_to_trial - 1]; %#ok<NBRAK>
    
    % if trials are being skipped, confirm this
    if isempty(last_complete_trial) || any(skipped_trials)
        button = questdlg('WARNING: You are attempting to reset to a point that has not yet been reached','Reset Trials','Reset','Cancel','Reset');
        if ~strcmpi(button, 'reset')
            fprintf('Reset cancelled\n');
        else
            trial_data.complete(skipped_trials) = 1;
            if ismember('start_time', get(trial_data, 'VarNames'))
                trial_data.start_time(skipped_trials) = 0;
            end
            if ismember('duration', get(trial_data, 'VarNames'))
                trial_data.duration(skipped_trials) = 0;
            end
        end
        
    % otherwise just mark past and future trials accordingly
    else
        trial_data.complete(reset_to_trial:end) = 0;
        if ismember('start_time', get(trial_data, 'VarNames'))
            trial_data.start_time(reset_to_trial:end) = NaN;
        end
        if ismember('duration', get(trial_data, 'VarNames'))
            trial_data.duration(reset_to_trial:end) = NaN;
        end
    end
    
%% set in edata

    edata.current_trial = reset_to_trial;
    
end
