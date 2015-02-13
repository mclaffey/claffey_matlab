%% To Do

% change ffmpeg to be a queue process in the system

% fix object selection so that it doesn't select distance objects.

% make regions appear at shapes of a specific size that can be moved
% around.

% remove tail as part of mouse region (so tail doesn't count as being in
% region) 

% change excel_pastable to create a dataset which is then converted to
% pastable 

% after analyzing a video, have a specified matlab variable where the
% results dataset is saved to that. when done analyzing, all results are
% already consolidated. on second thought, i think having a routine which
% can source a directory of video result and compile (pull method) is more
% practical, because with the push method you don't have a way of knowing
% if all your results are up to date if there was a failed push.

% organize contents file

%%

% data structure of vid

%   vid.original.image            snapshot at start of callibration
%   vid.original.dims             dimension of original video
%   vid.original.clip_rec         crop boundaries in [horz vert width height]
%   vid.original.clip_trbl        crop boundaries in [top right borrom left]

%   vid.timing.callibration_start
%   vid.timing.callibration_duration
%   vid.timing.data_start
%   vid.timing.data_duration

%   vid.params.clip_size = '80x60'  
%   vid.params.data_rate = 4;           clips per second to analyze
%   vid.params.video_write = true;      parameters for creating output video
%   vid.params.video_frame_ratio = 10;
%   vid.params.video_frame_pause = .2;

%   vid.callibration.image 
%   vid.callibration.dims 
% * vid.callibration.video
%   vid.callibration.range.min 
%   vid.callibration.range.max 

%   vid.data.image              snapshot of first data image
%   vid.data.dims               dimensions of data image
%   vid.data.frames             number of images
% * vid.data.video              matrix of image data
% * vid.data.out_of_minmax      boolean video of non bg pixels

%   vid.object.video            movie showing moving object
%   vid.object.props            properties returned by regionprops
%   vid.object.x                horizontal location as percent of region
%   vid.object.y                vertical location as percent of region
%   vid.object.solidity         how contiguous the selected object is (should be > 50%)
%   vid.object.area             what % of screen area object occupies (typically ~3%)

% *Indicates variable is deleted to conserve space when saved with vidz_save

%% Files
%   ffmpeg                          - 
%   ffmpeg_build                    - converts a structure of parameters to an ffmpeg command
%   ffmpeg_run                      - Run a validly formatted ffmpeg command in the system
%   image_detailed                  - Display statistics on a single image
%   openmp4                         - Open a mp4 file (uses system default)
%   openwmv                         - Open a wmv file (uses system default)
%   review_matrix_video             - Review a 3-D matrix as a movie with playback features
%   vidz_analyze_callibration       - import the callibration images
%   vidz_analyze_data               - find the pixels that are outside the background callibration
%   vidz_analyze_find_nonbg_object  - Select the target object based on background data
%   vidz_analyze_object_props       - Compiles and reviews metrics from vid.object.props
%   vidz_analyze_out_of_bg_minmax   - Identify all values in the data video that are outside the callibration min/max
%   vidz_create_analysis_video      - Create a stand-alone video file showing results of the tracking
%   vidz_default_params             - Populate default parameters
%   vidz_display_containing_regions - Highlight any regions which contain the object during a given frame
%   vidz_display_frame              - Display statistics on a single video frame
%   vidz_display_object_props       - Display graphs for diagnostic of tracking success
%   vidz_display_region             - Display a region as a transparent overlay in the current figure
%   vidz_display_region_all         - Display all regions
%   vidz_display_snapshot           - Opena new figure and display callibration snapshot
%   vidz_excel_pastable             - Display inforamtion in the command line that can be posted into Excel
%   vidz_feedback                   - Display feedback if the parameter is set to do so
%   vidz_files                      - Return a structure of vile locations for video analysis
%   vidz_files_set_subfolder        - specifies a subfolder to use within the working directory
%   vidz_helper_get_metric_struct   - Given a value per frame, return a structure with mean, by bin and by frame values
%   vidz_load                       - Search for metadata file and load if found
%   vidz_load_data_images           - 
%   vidz_query_crop_boundaries      - Export an image from full video and query for selecting clip boundaries
%   vidz_query_time_all             - Query the user for the timing of the callibration and data within a video
%   vidz_regions_analyze_all        - Calculate metrics of selected object relative to all regions
%   vidz_regions_analyze_individual - Calculate metrics of selected object relative to specified regions
%   vidz_regions_calc_centroid      - calculate centroid as percent of screen
%   vidz_regions_create_halves      - Divide the screen into two regions (not necessarily exactly halfves)
%   vidz_regions_query_ellipse      - 
%   vidz_regions_query_rect         - query user for boundaries
%   vidz_regions_save_new           - Save a new mask into the region structure of vid
%   vidz_regions_scale              - Enlarge a region by a specified percentage
%   vidz_regions_scale_ellipse      - Enlarge an ellipse region by a specified percentage
%   vidz_regions_scale_rect         - Enlarge a rectangular region by a specified percentage
%   vidz_save                       - Save the vid variable without large analysis portions
%   vidz_summary                    - this must be a script for html publishing
%   vidz_summary_region             - Display a table of region metrics
%   vidz_vidproc_callibration       - Create an image sequence for region boundaries and bg callibration
%   vidz_vidproc_create_snapshot    - Export a snapshot file from a video and return the image data
%   vidz_vidproc_data               - Create an image sequence for data analysis
%   ffmpeg_find                     - Find the path to ffmpeg
%   vidz_analyze_candidate_pixels   - Determine/update candidate pixels
%   vidz_analyze_exclude_pixels     - Mark pixels as bad so they are never considered to be object
%   vidz_analyze_freezing           - Detect time when object exhibits no motion
%   vidz_demo                       - demo script for analyzing video
%   vidz_display_distance           - Display graph of distance travelled, useful for finding tracking jumps
%   vidz_query_physical_dimensions  - Determine the physical size of each pixel
%   vidz_regions_query_circle       - query user for boundaries
%   vidz_review                     - Interactive review of analysis results
%   vidz_splice_callibration        - Replaces a crop rectange in the callibration with one from another time point
