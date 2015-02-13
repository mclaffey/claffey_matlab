function [snapshot] = vidz_vidproc_create_snapshot(vid, snapshot_time, snapshot_file_name)
% Export a snapshot file from a video and return the image data

%% setup parameters for ffmpeg command

    ffmpeg_params = ffmpeg_build();
    ffmpeg_params.input = vid.file.original;
    ffmpeg_params.start = snapshot_time;
    ffmpeg_params.rate = [];
    ffmpeg_params.frames = 1;
    ffmpeg_params.overwrite = true;
    ffmpeg_params.output = snapshot_file_name;

%% run ffmpeg
    
    ffmpeg_run(ffmpeg_params, vid.params.show_ffmpeg_output);

%% import and display image

    snapshot = imread(snapshot_file_name);
    
end
