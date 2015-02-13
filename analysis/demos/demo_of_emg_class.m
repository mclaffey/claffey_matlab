%% the emg class
% an emg class is a single variable that contains the data, timing
% information, and user-defined tags for an emg signal (or any continuous
% recording of a dependent variable)

%% creating emg variables
%%
% generate random data
signal_data = randn([20, 1])
sample_rate = 10 % 10 Hz

%%
% the simplest way to create an emg object is to pass the data and sampling
% rate
e = emg(signal_data, sample_rate)

%%
% the above method assumes the sampling rate is known and the signal starts
% at time zero. alternatively, an emg object can be created by specifying
% the start and end time
e = emg(signal_data, [2 4])

%%
% a demo instance can be created using
e = emg('demo')

%% data
% the data can be returned as a horizontal array
signal_data = e.data;
size(signal_data)
plot(signal_data)

%%
% use parentheses indexing to return an emg object cropped to the start and
% end times specified
e2 = e(1, 3)

%%
% use curly bracket indexing to return an array of the raw data, cropped to
% the start and end times specified
data_snippet = e{1, 1.01};
data_snippet'

%% time base
% the time base is a sampling_time object that specifies the start, end,
% duration and sampling rate of the signal. It contains restraints so that
% these variables stay in sync. For example, changing the start point while
% keeping the same duration will change the end point property.
e.time

%%
e.time.start = 2;
e.time


%% tags
% each emg object contains a structure called 'tags'. Tags can be used to
% store any information relevant to the emg object, such as trial
% conditions, date obtained and user comments
e.tags

%%
% new tags can be created as fields in the structure
e.tags.trial_condition = 'easy'

%%
% by default, emg objects contain three tags. 'Valid' is a logical that is
% fully controlled by the user, and is generally used to signify whether
% the data should be included in analysis
e.tags.valid = 0
e.tags.valid = 1

%%
% units is self explainatory
e.tags.units = 'volts'

%% 
% metrics is a group of calculations automatically performed each time the
% data of an emg object is modified. These can be easily expanded by
% modifying the file '@emg/private/compute_metrics.m'
e.tags.metrics

%% sections
% sections provide a functionality for marking subsets of the data of
% interest. they can either be a single point (duration of 0) or a
% continuous segment (duration > 0). Each section is an emg object, so it
% contains all the properties, tags and functionality of the emg class

%%
% the tms section was created as part of emg('demo'). It is a zero duration
% section
e.sections.tms

%%
% new sections can be created, modified and deleted
fixation_point_time_of_onset = 2
fixation_point_time_of_offset = 2.7
e.sections.fixation_point = [fixation_point_time_of_onset, fixation_point_time_of_offset]


%%
% you can query the time_base of a section to get various measures, such as duration
e.sections.fixation_point.time.duration

%%
% you can query the metrics of a section for measures such as root-mean-square (RMS)
e.sections.fixation_point.tags.metrics.rms

%%
% you can move the start and end of a section by assigning new values to the time_base
% this will move the fixation point period to start at 1 instead of 2, and change
%   the duration from 0.7 to 0.5. this automatically makes the new end at 1.5
e.sections.fixation_point.time.start = 1
e.sections.fixation_point.time.duration = 0.5

%%
% to remove a section, set it to empty
e.sections.fixation_point = []

%%
% to create a section of zero duration by assigning a starting point only
e.sections.trial_end = 6.5

%% finding meps
% meps can be detected using the find_mep function. This function takes a
% large number of optional arguments to indicate where and how to search
% for an mep. It returns an emg object

%%
% when called without any arguments, it searches the entire emg object. In
% this case, it returns an emg object that is 50 ms long, immediately
% after the tms section and ~0.6 mV in amplitude, so it is probably accurate
mep = find_mep(e)
mep.tags.metrics.peak2peak

%%
% when searching long signals with more noise, it will be faster and more
% accurate to specify where to search
mep = find_mep(e, 'after', 'tms', 'duration', .100)


%%
% to insert a section for the detected mep into the original emg object,
% use mark_mep() instead. it takes the exact same arguments but is assigned
% back to the original emg object
e = mark_mep(e, 'after', 'tms', 'duration', .100)

%% plotting
% to create a plot customized for displaying emg objects, simply call
% plot(). This function labels the axis and highlights sections.
plot(e)

%%
% to zoom to a specified section, use the follow arguments
plot(e, 'zoom', 'mep')

%%
% to plot into an existing figure, pass the figure handle
f = figure;
subplot(2,1,1)
plot(e, 'figure', f)
subplot(2,1,2)
plot(e, 'figure', f, 'zoom', 'mep')

%% reviewing sections
% the most powerful feature of plotting is that sections can be manually
% dragged to change their locations. Click and drag on a section to slide
% it forward and backward in time. For sections with duration > 0, clicking
% on the left edge controls the start time while leaving the end time the
% same. Dragging the right edge does the opposite. Each time you release
% the mouse, the emg object is updated in the base workspace

%% verifying
% verify() provides functionality for checking whether an emg object meets
% certain quality criteria. The 'basic' verification rules make sure
% the object itself hasn't been corrupted accidentally. In contrast, the
% 'mep' verification rules check whether the mep is of typical duration
% and amplitutde.

%%
% calling verify without any output arguments prints the results to the
% command window
verify(e)

%%
% verify looks for files in the @emg/private directory matching the pattern
% 'verify_*.m'. Verify() can further filter which files are used.
verify(e, 'mep*')

%%
% however, verify() can return the following arguments. verification_passed
% is a boolean indicating whether the emg object passed all rules. results
% is the structure displayed above. verification rules can also modify the
% emg object they are checking. for example, basic_metrics_ok updates any
% incorrect metrics and mep_big_enough flags the mep section as invalid if
% it is not large enough. the modifed emg object is returned as e_modified.
[verification_passed, results, e_modified] = verify(e, 'mep*')

%% exporting data
% Data from an emg object can be converted to a dataset for calculations
% and export to other programs
dataset(e)

%%
% Optional name-value paramters can be provided to filter which tags,
% sections and metrics are return
dataset(e, 'tags', {'valid'}, 'sections', {'mep'}, 'metrics', {'max', 'area15', 'peak2peak'})


%% miscellaneous functions
% the emg class provides common matlab functions for use in scripts/functions

%%
% size(e) - first dimension is always 1, second dimension is number of data points
size(e)

%%
% isempty(e) and logical(e)
empty_e = emg();

%%
isempty(e)
if e, fprintf('has data\n'); else fprintf('does NOT have data\n'); end
%%
isempty(empty_e)
if empty_e, fprintf('has data\n'); else fprintf('does NOT have data\n'); end


%%
% isequal(e1, e2)
e2 = e;
isequal(e, e2)

%%
isequal(e, mep)
