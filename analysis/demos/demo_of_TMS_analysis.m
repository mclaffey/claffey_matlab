%%
clear
clc

%% load behavioral data with pulse type and times
behav = load('s1_behavioral_data'); % load the behavioral data file
tms_times = behav.pulse_data.pulse_time + .01; % the .01 adjusts for a common latency with the recording

%% load emg data
ced_data = ced_import(1, 's1_ced_export.txt'); % import the file exported from signal
ced_data.channel_units = 'mV'; % label the units
ced_data.channel_names = {'left_extensor', 'right_extensor'} % label the channels
e = emg_set(ced_data) % convert the ced data to an emg object

%% label tms times
e.left_extensor.sections.tms = tms_times % this creates a 'section', or marker, for each tms time
e.right_extensor.sections.tms = tms_times % this creates a 'section', or marker, for each tms time

%% check background rms
e.sections.quiet = [1 2]; % mark an area in each trial that should be quiet
bg_rms = e(:,'right_extensor').sections.quiet.tags.metrics.rms; % gather the rms during this time for each trial
normal_bg_rms = .002; % determine from previous experiments
fprintf('Background rms is %1.1fx typical levels\n', mean(bg_rms) / normal_bg_rms);

%% mep threshold
% the mep threshold is a cutoff used to distinguish between noise in the emg signal and an mep.
% Cathy uses an algorithm that looks for the first point in the signal that rises above 5 times the
% std deviation of the background rms (Coxon et Stinear, 2006)
fprintf('\nStinear MEP threshold is: %4.3f mV\n', nanmean(bg_rms) + nanstd(bg_rms) * 5);

% I (Mike) have developed what I feel is a more robust algorithm that looks at factors such as
% amplitude, consecutive time above threshold and moving averages. The threshold for this is
% calculated with a simple formula based on my empiric experience:
mep_threshold = 0.005 + nanmean(bg_rms) * 1.2;
fprintf('Claffey MEP threshold is: %4.3f mV\n', mep_threshold);

%% locate meps
[e] = mark_mep(e, 'after', 'tms', 'duration', .1, 'threshold', mep_threshold)
% check that threshold was correct using review(e) before proceeding, and adjust if necessary

%% verify
[rates, rule_results, trial_results, e] = verify(e(:,'right_extensor'));
rates

%% create lists for reviewing
fprintf('\n\n');
% burst trials (trials with large EMG activity somewhere in the sweep)
burst_trials = find(~rule_results.basic_no_bursts.is_ok);
if ~isempty(burst_trials)
    e(burst_trials).tags.valid = 0;
    fprintf('Burst trials (marked invalid): %s\n', mat2str(burst_trials'));
else
    fprintf('No burst trials found\n');
end
% noisy meps - background rms before TMS was greater than 0.005 mV
noisy_meps = setdiff(find(~rule_results.mep_quiet_rms.is_ok), union(burst_trials, find(~rule_results.mep__found.is_ok)));
if ~isempty(noisy_meps)
    fprintf('Noisy pre tms rms:             %s\n', mat2str(noisy_meps'));
else
    fprintf('No noisy meps found\n');
end
% weird meps - unusually short or small
weird_meps = setdiff(union(find(~rule_results.mep_big_enough.is_ok), find(~rule_results.mep_long_enough.is_ok)), find(~rule_results.mep__found.is_ok));
if ~isempty(weird_meps)
    fprintf('Weird meps:                    %s\n', mat2str(weird_meps'));
else
    fprintf('No weird meps found\n');
end


%% review
review(e)


%% convert to dataset
mep_data = dataset(e(:,'right_extensor'), 'tags', {'ced_frame', 'valid', 'pre_tms_rms'}, 'sections', {'mep'}, 'metrics', {'peak2peak', 'area15'})
mep_data = join(behav.pulse_data, mep_data, 'LeftKey', 'pulse_id', 'RightKey', 'ced_frame') % join with behavioral data
mep_data = mep_data(:, {'pulse_id', 'pulse_type', 'valid', 'mep_pre_tms_rms', 'mep_peak2peak', 'mep_area15'}) % remove unneeded columns
mep_data = dataset_add_columns(mep_data, 'subject', 1)


%% limit dataset to valid trials and trim 20% of MEPS
mep_data = mep_data(mep_data.valid==1, :)
mep_data = dataset_trim(mep_data, 'pulse_type', 'mep_peak2peak', 20)

%% export to spss
spss_export(mep_data)
