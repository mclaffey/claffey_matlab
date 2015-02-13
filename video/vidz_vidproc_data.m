function [vid] = vidz_vidproc_data(vid)
% Create an image sequence for data analysis

    vidz_feedback(vid, 'Exporting images for analysis...\n');

%% delete existing files

    data_dir = strrep(vid.file.data_dir, ' ', '\ ');
    [status, message] = system(sprintf('rm -f %s/data*.png', data_dir));
    % there's a limit to the number of files rm can handle, use this
    % alternate versus if rm returned an error
    if status
        delete_command = sprintf('find %s -name ''data*.png'' | xargs rm', data_dir);
        [status, message] = system(delete_command);
    end
    
%% setup parameters for ffmpeg command and run

    ffmpeg_params = ffmpeg_build();
    ffmpeg_params.input = vid.file.original;
    ffmpeg_params.start = vid.timing.data_start;
    ffmpeg_params.size = vid.params.data_extract_clip_size;
    ffmpeg_params.rate = vid.params.data_extract_fps;
    ffmpeg_params.duration = vid.timing.data_duration;
    ffmpeg_params.clip_trbl = vid.original.clip_trbl;
    ffmpeg_params.crop = vid.original.clip_rec;
    ffmpeg_params.output = fullfile(vid.file.data_dir, 'data%04d.png');

    ffmpeg_run(ffmpeg_params, vid.params.show_ffmpeg_output);
    
%% load the first image as a snapshot

    image_file_name = fullfile(vid.file.data_dir, 'data0001.png');
    vid.data.image = rgb2gray(imread(image_file_name));
    vid.data.dims = size(vid.data.image);
    
%% feedback

    vidz_feedback(vid, '\bDONE\n');

end