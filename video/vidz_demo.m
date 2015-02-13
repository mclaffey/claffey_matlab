%%
% demo script for analyzing video
%

% Copyright 2013 Mike Claffey (mikeclaffey@yahoo.com)
%
% 05/24/13 corrections to get working on PC and added to claffey_matlab
% 04/07/13 created sharable version
% 09/21/11 original version

%% dock figures by default
% make figures appear docked, rather than free floating
dock_by_default(1) 

%% select the video file to analyze

% set the default folder for the video selection file dialogue to open in
% this can be changed to whatever directory makes sense on your system
default_search_dir = '~';

% prompt the user for the location of the video
[video_file, video_dir] = uigetfile(fullfile(default_search_dir , '*.*'), 'Select video');
video_path =fullfile(video_dir, video_file);

%% select a folder to store all the files for the analysis

% you can customize this to select option 1 or 2 by uncommenting

% option 1 - have the user select a directory that is created outside of
% matlab (comment out the the line below to use option 2)

% analysis_dir = uigetdir(video_dir, 'Select analysis directory');

% option 2 - create a directory with the same name as the video, in the
% directory where the video is located (uncomment the lines below to use
% this option)

analysis_dir = video_dir;

%% specify a value for sub_analysis

% depending on the experiment, some videos may have multiple sections to be
% analyzed separately. For example, it is possible to record a video for 1
% hour straight that has 10 different 5 minute segments within it. This
% section asks for a 'sub analysis' name, so that each one of these
% segments will be analyzed and stored in a different directory within the
% main analysis directory specified in the section above.
%
% example values might be:
%   'trial1', 'trial2', etc
%   'animal-54', 'animal-94'
%   'training, 'testing', etc
%
% if there is only one analysis per video, this value can be left blank

sub_analysis = input('Enter name of sub-analysis: ', 's');

%% initialize the vid variable
%
% the vid variable is a large structure that contains all the parameters
% used for analyzing the video
%
% this variable is typically passed to any vidz_() function to provide that
% function with whatever information is needed. If that function adds to or
% modifies the vid variable, the function will return an updated version of
% it.
%
% generally, the user does not directly modify the vid variable

vid = vidz_files(video_path, sub_analysis, analysis_dir);

%% set parameters & metadata
vid = vidz_default_params(vid);

% the parameters of the analysis can be modified by changing any of the
% following fields.
%
% vid.params
% 
% ans = 
% 
%                           feedback: 1
%                 show_ffmpeg_output: 0
%                   data_extract_fps: 4
%             data_extract_clip_size: [80 60]
%                      physical_dims: [1 1]
%                  pixel_edge_length: 0.0125
%          analysis_bin_size_in_secs: 60
%     output_video_time_elapse_ratio: 10
%             output_video_input_fps: 0.5000
%
%


%% set metadata
% any fields can be added to the metadata field. This is not used for any
% video analysis, but it is stored in the matlab variable with all other
% video information, which might be useful to the user for future reference

% example:
% vid.metadata.subject_num = 243;

%% set physical dimensions

% the purpose of this section is specify the amount of physical space
% (e.g. feet, meters) that is captured by the video, so that the movement
% of the tracked object can be specified in physical space, rather than
% percent of the screen.
%
% this is option. if the values are wrong, comparisons between conditions
% will still be useful, it is just that the units of those measurements
% will be wrong.
%
% I'm not sure what happens if these are missing completely.

width = 0.40; % meters
height = 0.35; % meters
vid = vidz_query_physical_dimensions(vid, [width height]);

%% query user for timing

% the callibration is used to determine what the background image looks
% like. the object to be tracked should not be in the video at this point.
% therefore, it is necessary to have a few seconds of background image
% prior to introducing the animal.
%
% The callibration needs a start and end time to extract images fromt
% the video. typically a single second is sufficient. 

vid.timing.callibration_start = query_seconds('Enter callibration time ');

% the command below defaults the callibration time to 1 second. This can be
% changed to a different value or assigned based on an input() prompt to
% the user.
vid.timing.callibration_duration = 1;

%% query for clip boundaries

% The section allows the user to crop the video to a subsection. This is
% important for two reasons. First, it eliminates anything outside of the
% relevant area which may contain moving pixels, which would otherwise
% confuse the tracking algorithm if it was not excluded. Second, it
% expedits analysis because less of the video is being processed.
%
% Reflections in the sides of the container are common, so the crop should
% only include the floor. It's okay if the animal rears onto the wall
% outside of the crop zone, enough of their body will still be in frame to
% allow for proper analysis.

% when this command runs, you should see the image area in a figure with
% cross hairs. chick and drag once over the selected region. if you make an
% error, just rerun this section.
%
% there is a matlab quirk in which the figure sometimes does not have the
% focus, so the crosshairs do not appear. if that's the case, click on the
% title bar of the figure to give it focus, then select the relevant area.

vid = vidz_query_crop_boundaries(vid);

%% analyze callibration video to determine background

% this section uses the timing and cropping information to process the
% callibration portion of the video. there is no interaction with the user.

vid = vidz_vidproc_callibration(vid);
vid = vidz_analyze_callibration(vid);

%% query for object regions

% this section allows the user to specify regions of interest. these do not
% affect the tracking of the object, but are later used to describe where
% the object was in relation to these regions.

% relevant functions:
%   vidz_regions_query_rect(vid, figure_handle, region_name, prompt)
%   vidz_regions_query_circle(vid, figure_handle, region_name, prompt, radius)
%   vidz_regions_query_ellipse(vid, figure_handle, region_name, prompt)

% display image
f = vidz_display_snapshot(vid);

% setup rectangular regions
vid = vidz_regions_query_rect(vid, f, 'left', 'Drag over the left section');
vid = vidz_regions_query_rect(vid, f, 'center', 'Drag over the center section');
vid = vidz_regions_query_rect(vid, f, 'right', 'Drag over the right section');

% setup circular regions
circle_size = 9;
vid = vidz_regions_query_circle(vid, f, 'obj_1', 'Click in center of object 1', circle_size);
vid = vidz_regions_query_circle(vid, f, 'obj_2', 'Click in center of object 2', circle_size);

% scale the region
% this allows the user to highlight a given region in the image, and then
% have the region grow beyong that region to include a certain percentage
% of the periphery as well
% scale_percent = 1.4;
% vid = vidz_regions_scale(vid, 'center', scale_percent);

close(f)

%% display regions

% this section displays the selected regions to the user. if the regions
% are not correct, the previous section can be rerun.

vidz_display_region_all(vid);

%% save progress
vidz_save(vid)

%% specify timing of data section of video

% similar to specifying timing for callibration section, except for the
% data sec

vid.timing.data_start = query_seconds('Enter data start time ');

% for experiments of fixed duration, use this format
vid.timing.data_duration = query_seconds('Enter data duration ');

% or to use variable duration based on an end time, use this format
%
% data_end_time = query_seconds('Enter data end time ');
% vid.timing.data_duration = data_end_time - vid.timing.data_start;


%% create image sequence for data analysis

% this is the section that slices up the video into individual images for
% analysis. it doesn't not provide percent complete information because the
% work is performed by ffmpeg

vid = vidz_vidproc_data(vid);
vid = vidz_load_data_images(vid);

%% analyze data images against bg values

% this section analyzes the exported images to track the object

vid = vidz_analyze_data(vid);

%% review analysis results

% this section provides a variety of options to the user to review the
% results of the object tracking.
%
% there are options for making corrections if the tracking picks up on a
% bad area (e.g. there is a reflection), but i'll document those elsewhere

vid = vidz_review(vid); 

%% calculate metrics relative to regions
vid = vidz_regions_analyze_all(vid);

%% save progress
vidz_save(vid)

%% create video

% this optional section creates a video showing the results of the
% analysis, which the tracked object super-imposed over the original video.
close all;
vidz_create_analysis_video(vid);

%% publish report

% save the current version of vid to the global workspace for publishing
assignin('base', 'vid', vid);
close all
publish_clean('vidz_summary.m', vid.file.report);
close all

%% export to csv
vidz_excel_pastable(vid)

%% save data file
vidz_save(vid)

%% close all
close all







