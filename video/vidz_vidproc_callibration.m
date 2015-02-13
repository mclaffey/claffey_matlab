function [vid] = vidz_vidproc_callibration(vid)
% Create an image sequence for region boundaries and bg callibration

%% throw warning if the callibration duration is zero and return

    if vid.timing.callibration_duration == 0
        warning('Callibration duration is zero, skipping vidz_vidproc_callibration()'); %#ok<WNTAG>
        return
    end

%% delete existing files

    [status, message] = system(sprintf('rm -f %s/callibration*.png', strrep(vid.file.callibration_dir, ' ', '\ ')));
    
%% ffmpeg command

    ffmpeg_params = ffmpeg_build();
    ffmpeg_params.input = vid.file.original;
    ffmpeg_params.start = vid.timing.callibration_start;
    ffmpeg_params.duration = vid.timing.callibration_duration;
    ffmpeg_params.size = vid.params.data_extract_clip_size;
    ffmpeg_params.rate = vid.params.data_extract_fps;
    ffmpeg_params.clip_trbl = vid.original.clip_trbl;
    ffmpeg_params.crop = vid.original.clip_rec;
    ffmpeg_params.output = fullfile(vid.file.callibration_dir, 'callibration%04d.png');

    ffmpeg_run(ffmpeg_params, vid.params.show_ffmpeg_output);

end