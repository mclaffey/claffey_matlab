function [vid] = vidz_create_analysis_video(vid)
% Create a stand-alone video file showing results of the tracking

% 05/24/13 fixed creation of compressed video
    
%% prepare

    % use software mode for openql (this fixes problems with rendering the
    % frame in Windows
    if ispc
        opengl('software');
    end
    
    % prepare video file
    aviobj = avifile(vid.file.analysis_video_uncompressed, 'compression', 'none');
    
    % open figure    
    f = figure('WindowStyle', 'normal', 'Position', [100 100 320 400]);
    colormap(bone);
    
    % determine the frame increment
    % this is a measure of how many input frames to 'skip' when creating
    % the video. Skipping frames decreases processing time and file size,
    % but will make the video more jumpy. It's based on a raio of how many
    % frames were extracted from the original movie, and how many frames
    % per second of realtime are desired. note that this is independent how
    % the time lapse ratio (see below)
    frame_increment = round(vid.params.data_extract_fps / vid.params.output_video_input_fps);
    
    % determine the output frames per second
    % this determines how much the output video has been sped up, which is
    % useful for reviewing long experiment durations more quickly. the
    % input_fps parameter determines how many frames per second of realtime
    % should be used, and the time_elapse_ratio deteremines how many
    % seconds of realtime should be compressed in to each second of output
    % video. the product of these two parameters determines how many frames
    % should be played per second in the output video.
    output_fps = round(vid.params.output_video_input_fps * vid.params.output_video_time_elapse_ratio);
    

%% increment through frames
    
    for frame_num = 1:frame_increment:vid.data.frames
                
%% display analysis graphics
        
        cla

        % draw background image
        imagesc(vid.data.video(:,:,frame_num));
        axis image;
        hold on

        % title
        title(get_video_title());
        
        % draw applicable regions
        vidz_display_containing_regions(vid, frame_num)                

        % create centroid cross hairs
        vline = plot_line(vid.object.x(frame_num) * vid.data.dims(2) , 'v');
        hline = plot_line(vid.object.y(frame_num) * vid.data.dims(1), 'h');
        
        drawnow;
        
%% write for video
        
        video_frame = getframe(f);
        aviobj = addframe(aviobj,video_frame);

    end

%% close figure

    % close figure
    close(f);
    
    % return to autoselect mode for opengl
    if ispc
        opengl('autoselect');
    end

    
%% finish writing video file and compress, if applicable    

    vidz_feedback(vid, 'Saving video file, this could take awhile...\n');

    % finish writing the uncompressed movie from matlab
    aviobj = close(aviobj);
    
    % create a compress version using ffmpeg
    ffmpeg_params = ffmpeg_build();
    ffmpeg_params.input = vid.file.analysis_video_uncompressed;
    ffmpeg_params.output = vid.file.analysis_video;
    ffmpeg_run(ffmpeg_params, vid.params.show_ffmpeg_output);
    
    % delete the uncompressed version
    delete(vid.file.analysis_video_uncompressed);
    
%% helper function to label video

    function video_title = get_video_title
        
        % line 1 - name
        if isempty(vid.file.subfolder_name)
            line_1 = vid.file.name;
        else
            line_1 = sprintf('%s - %s', vid.file.name, vid.file.subfolder_name);
        end
        
        % line 2 - frame, time, percent done
        video_time = frame_num/vid.params.data_extract_fps;
        video_mins = floor(video_time/60);
        video_secs = rem(video_time, 60);
        video_time_str = sprintf('%d:%02.2f', video_mins, video_secs);
        video_percent_done = round(frame_num / vid.data.frames * 100);
        line_2 = sprintf('frame %d, time: %s (%d%%)', ...
            frame_num, video_time_str, video_percent_done);
        
        % line 3 - creation parameters
        if vid.params.output_video_input_fps >= 1
            line_3 = sprintf('Time elapse at %dx. %d image/sec of realtime', ...
                vid.params.output_video_time_elapse_ratio, vid.params.output_video_input_fps);
        else
            line_3 = sprintf('Time elapse at %dx. 1 image/%d secs of realtime', ...
                vid.params.output_video_time_elapse_ratio, round(1/vid.params.output_video_input_fps));
        end
        
        % consolidate video title
        video_title = sprintf('%s\n%s\n%s', line_1, line_2, line_3);
            
        % replace underscores (they are treated as subscript by matlab)
        video_title = strrep(video_title, '_', ' ');
    end

    
%%
end