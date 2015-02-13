% 09/20/08 added demo of dataset handling of multiple channels

%% emg_set()
% the emg_set class is a collection of emg obects organized in one or more
% channels with data across one or more trials. 
e = emg_set('demo')

%%
% emg_set() will usually be called by passing it a ced_data structure

% ced_data = import_CED_file(1, 'ced_data_file.txt')
% e = emg_set(ced_data)

%% channel names
% can be accessed as a property
e.channel_names

%%
% channel names can be set by assigning a cell array
e.channel_names = {'left_extensor' 'right_extensor'}


%% () indexing
% parentheses indexing can be used to access specific trials or channels

%%
% accessing a subset of trials
e = e(1:8, :)

%%
% accessing a subset of channels
e(:, 1)

%%
% channels can also be accessed by name
e(:, 'left_extensor')
e.left_extensor

%%
% parentheses indexing always returns an emg_set, even if a single channel
% and trial is specified
e(1,1)

%%
% passing an emg_object with only one trial and channel to emg() will
% convert it to an emg object 
emg(e(1,1))

%% {} indexing
% curly bracket indexing is used to return individual emg objects within an
% emg_set
e{2, 2}
%%
% again, channels can be referenced by name, while trials can only be
% referenced by number
e.right_extensor{3}

%%
% the following form of referencing is not yet implemented
% TODO: this doesn't work
try
    e{3, 'right'}
catch
    fprintf(' * * * ERROR * * * \n')
end

%% properties of emg objects within a set
% any property of an emg object can be accessed for the entire set

%%
% time properties
e.time.duration

%%
% tags
e.tags.valid
%%
% metrics
e.tags.metrics.peak2peak

%%
% sections - this will create a new emg_object containing only the
% requested section for each trial and channel, therefore it will be the
% same size as the original emg_set. If a particular trial/channel doesn't
% have the requested section, it will return an empty emg object.
e.sections.tms

%%
% properties of sections can also be queried
e.sections.tms.time.start

%% logical indexing
% logical indexing can be used to return trials that meet a criteria
e.right_extensor.tags.metrics.peak2peak
%%
e.right_extensor.tags.metrics.peak2peak > 1.2
%%
e.right_extensor(e.right_extensor.tags.metrics.peak2peak > 1.2)

%% emg object assignment

%%
% trials can be reordered...
e([1 3], 1) = e([3 1], 1)

%%
% duplicated...
e(9:16, :) = e(1:8, :)

%%
% and removed
e = e(9:16, :)

%%
% channels can also be manipulated, but it is the user's responsibility to
% make sure that e.channel_names is kept accurate: 

%%
% data for channels is flipped
e = e(:, [2 1])

%%
% channel is duplicated, so needs a new name
e = e(:, [1 2 2])
e.channel_names = {'right_extensor' 'left_extensor' 'left_copy'}
%%
% extra channel is dropped, original order is restored
e = e(:, [2 1])

%% property retrieval and assignment

%%
% values can be queried and stored as a matrix...
trial_maxes = e.tags.metrics.max

%%
% ... or passed directly to functions
mean(e.tags.metrics.max)

%%
% values can be assigned to multiple emg objects within an emg_set at
% once by passing a single value
e(:, 2).tags.trial_condition = 'easy';
e.tags.trial_condition
%%
e{1,2}.tags

%%
% a matrix of different values can be passed if it is the same size as the
% trials being assigned
e([2 4 6 8], 2).tags.trial_condition = {'hard' 'medium' 'hard' 'medium'}';
e.tags.trial_condition

%%
% passing an empty matrix will delete the tag 
e(:, :).tags.trial_condition = [];
e{1,2}.tags

%%
% this is also useful for flagging invalid trials
acceptable_left_channel = e.left_extensor.tags.metrics.rms < .03
%%
e.left_extensor.tags.valid = e.left_extensor.tags.valid & acceptable_left_channel
e.right_extensor.tags.valid = e.right_extensor.tags.valid & acceptable_left_channel

%% working with meps
% find_mep the same as for the emg class
meps = find_mep(e, 'after', 'tms', 'duration', .1)

%%
% mark_mep also works similarly, except it returns a second argument
% reporting on the quality of meps found
[e, mep_results] = mark_mep(e, 'after', 'tms', 'duration', .1)

%% verification
% verification is similar as for the emg class except for the arguments it
% returns
[rates, rule_results, trial_results, modified_e] = verify(e);
%%
% rates is a structure containing the percent of trials that passed each
% verification rule in each channel. In this example, meps were not
% reliable found in the first channel (column), but were found for the
% second channel.
rates
%%
% rule_results is a structure with information for how each emg object did
% for each rule. In this example, half the emgs in the 2nd channel were
% not quiet enough before the mep. We can see the description and list of
% trials
rule_results.mep_quiet_before.message(:, 2)
not_quiet_trials = find(rule_results.mep_quiet_before.is_ok(:,2)==0)
%%
% trial results contains the results for each individual emg object. For
% example, to see what happened with the 7th trial in the 2nd channel
trial_results{7,2}
%%
% finally, modified_e is the emg_set after being modified by any
% verification rules. We can see which meps are valid
ok_meps = modified_e.sections.mep.tags.valid

%% plotting
% the emg_set class has robust plotting options using the plot() function
% and a variety of arguments
%%
% the basic plot() command overlays all trials, with each channel in a
% different color
plot(e)
%%
% the subplot command can be used to show each channel separately
plot(e, 'subplot', 'channels')
%%
% or each trial separately (only the first three channels are passed here
% to prevent too many subplots from being created)
plot(e(1:3,:), 'subplot', 'trials')
%%
% the onset of sections can be marked using the 'sections' argument
plot(e(1,:), 'subplot', 'channels', 'sections', {'tms','mep'})

%%
% sections can be plotted without the overall trial
plot(e.sections.mep(:,2), 'subplots', 'channels')

%% reviewing
% reviewing for emg_sets provides the functionality of looking through many
% trials and channels quickly, while also adjusting sections by dragging
review(e)

%% exporting data
% As with the emg object, information can be easily extracted using the
% dataset() function with the same arguments
dataset(e.right_extensor, 'tags', {'valid', 'ced_frame'}, 'sections', 'mep', 'metrics', 'area15')

%%
% if more than one channel is passed, each column is prepended with the channel name
dataset(e, 'tags', {'valid', 'ced_frame'}, 'sections', 'mep', 'metrics', 'area15')

%% miscellaneous functions
% the emg class provides a number of common functions for use in
% programming

%%
% size(e) - first dimension is the number of trials, the second dimension
% is the number of channels, the third dimension is the number of data
% points in e{1,1}
size(e)

%%
% isempty(e) and logical(e)
empty_e = emg_set();
%%
isempty(e)
if e, fprintf('has data\n'); else fprintf('does NOT have data\n'); end
%%
isempty(empty_e)
if empty_e, fprintf('has data\n'); else fprintf('does NOT have data\n'); end

%%
% vertcat can append two emg_sets
first_half = e(1:4,:);
second_half = e(5:8, :);
recombined = vertcat(first_half, second_half)
