function [vid] = vidz_default_params(vid)
% Populate default parameters

%% feedback

    % typically single line status messages
    vid.params.feedback = true;
    
    % display full terminal output of ffmpeg
    vid.params.show_ffmpeg_output = false;
    
%% size and fps to extract for analysis

    vid.params.data_extract_fps = 4;
    vid.params.data_extract_clip_size = [80 60]; % [width height]
    
    % the width of clip size will be adjusted by
    % vidz_query_physical_dimensions so that the aspect ratio of the video
    % will match the aspect ratio of the physical dimensions
    
%% physical dimensions

    % these values will be set by vidz_query_physical_dimensions()
    %
    % if they are not, there is a risk that the clip aspect ratio will not
    % match the real physical aspect ratio. this means that the height of
    % each pixel has a different physical length than the width of each
    % pixel. this in turn means that moving 1 pixel horizontally does not
    % represent the same physical distance of moving 1 pixel vertically.
    % the analysis assumes all pixels are square and will therefore be
    % inaccurate accordingly.

    vid.params.physical_dims = [1 1];
    vid.params.pixel_edge_length = vid.params.physical_dims(1) / vid.params.data_extract_clip_size(1);

%% region analysis

    vid.params.analysis_bin_size_in_secs = 60;
    
%% parameters for creating output video

    % see additional notes in vidz_create_analysis_video()
    
    % amount to speed up video (e.g. display mouse movements at 10 times
    % normal speed)
    vid.params.output_video_time_elapse_ratio = 10;
    
    % number of frames to display per second of real time. lower numbers
    % reduce processing time and file size, but may appear more jumpy
    vid.params.output_video_input_fps = 0.5;
    
%% parameters for detecting freezing

    vid.params.freezing_threshold_pixel_percent = .005;
    vid.params.freezing_threshold_seconds = 1;
    
%% add other default fields

    if ~isfield(vid, 'regions'), vid.regions = struct; end;
    if ~isfield(vid, 'metadata'), vid.metadata = struct; end;
    
%%  

end