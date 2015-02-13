function exp_admin_status
    
%% check for edata

    try
        edata = evalin('base', 'edata');
    catch
        fprintf('There is no EDATA variable. You need to initialize the experiment.\n');
        return
    end
    
%% check for trial_data

    try
        trial_data = evalin('base', 'trial_data');
    catch
        fprintf('There is no TRIAL_DATA variable. You need to initialize the experiment.\n');
        trial_data = [];
    end
    
%% clear command window

    home
    
%% display the run mode

    if edata.run_mode.debug
        fprintf('Operating in debug mode\n');
    end
    if edata.run_mode.simulate
        fprintf('Operating in simulation mode\n');
    end
    if ~edata.run_mode.debug && ~edata.run_mode.simulate
        fprintf('Operating in normal mode\n');
    end

%% check the edata variable

    if isfield(edata, 'inputs')
        fprintf('Inputs appear to be initialized\n');
    else
        fprintf('** Inputs have not been initialized\n');
    end

    if isfield(edata, 'audio')
        fprintf('Audio appears to be initialized\n');
    else
        fprintf('** Audio has not been initialized\n');
    end

    if isfield(edata, 'files')
        fprintf('File locatios appear to be initialized\n');
    else
        fprintf('** File locations have not been initialized\n');
    end

    if isfield(edata, 'display')
        fprintf('Display appears to be initialized\n');
    else
        fprintf('** Display has not been initialized\n');
    end

    if isfield(edata, 'subject_id')
        fprintf('Subject ID: %d\n', edata.subject_id);
    else
        fprintf('** Subject ID has not been assigned yet.\n');
    end

%% trial data

    if ~isempty(trial_data)
        fprintf('TRIAL_DATA contains %d trials (%d columns)\n', size(trial_data));
    else
        fprintf('** TRIAL_DATA is empty.\n');
        fprintf('No further status available.\n');
        return
    end
    if isfield(edata, 'current_trial')
        fprintf('Current trial %d', edata.current_trial);
        try
            fprintf(', block %d\n', trial_data.block(edata.current_trial));
        catch
            fprintf('\n');
        end
    else
        fprintf('** Experiment has not begun yet (no edata.current_trial field).\n');
        fprintf('No further status available.\n');
        return
    end

    fprintf('Percent complete: %d%%\n', fix(nanmean(trial_data.complete)*100));
    trials_remaining = size(trial_data,1) - edata.current_trial;
    
    % calculate duration. use diff function if duration fails. use median
    % to exclude effects of outlier trials (where there may have been an
    % interruption)
    try    
        average_trial_length = nanmedian(trial_data.duration);
    catch %#ok<CTCH>
        average_trial_length = nanmedian(diff(trial_data.start_time));
    end

    fprintf('Started %s ago (~%s remaining)\n', ...
        round_time_to_text((GetSecs - trial_data.start_time(1))), ...
        round_time_to_text(trials_remaining * average_trial_length));

    try %#ok<TRYNC>
        exp_admin_status_other(edata, trial_data);
    end

end
    
    
    
    