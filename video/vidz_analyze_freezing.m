function [vid] = vidz_analyze_freezing(vid)
% Detect time when object exhibits no motion

%% find difference pixels for object

    % for each frame, find the pixels that changed
    obj_diff = diff(vid.object.video, 1, 3);
    
    % get the absolute value, we don't care if a pixel turned on or off
    obj_diff_abs = abs(obj_diff);
    
    % sum all the pixels for a given frame and create a vector with a
    % length equal to the number of frames - 1
    diff_by_frame = squeeze(sum(sum(obj_diff_abs, 1), 2));
    
    % add one value to make the vector equal to the number of frames
    diff_by_frame = cat(0, diff_by_frame);
    
    % save data
    vid.object.diff_by_frame = diff_by_frame;
    
%% find frames when the object froze

    % a still frame is a frame when the number of pixels that changed was
    % less than the still_pixel_threshold
    %
    % freezing is defined as a number of consecutive still frames in a row.
    % once the threshold is reached, the preceding frames that lead up to
    % the threshold are also considered freezing.
    %
    % for example,
    %     still_pixel_threshold = 20;
    %     freeze_consecutive_threshold = 4;
    %
    %   pixel diff:     24 25 5 39 5 9 2 4 3 4 22 3 5
    %   is still:        0  0 1  0 1 1 1 1 1 1  0 1 1
    %   consecutive:     0  0 1  0 1 2 3 4 5 6  0 1 2
    %   is freeze:       0  0 0  0 1 1 1 1 1 1  0 0 0

%% determine parameters 

    % determine number of pixels per image
    pixel_count = numel(vid.object.video(:,:,1));
    
    % calculate the pixel threshold
    still_pixel_threshold = ...
        pixel_count * vid.params.freezing_threshold_pixel_percent;
    vid.params.freezing_threshold_pixel_count_readonly = still_pixel_threshold;
    
    % calculate the consecutive frame threshold based on the time threshold
    % and the number of frames per second
    freeze_consecutive_threshold = ...
        vid.params.freezing_threshold_seconds * vid.params.data_extract_fps;
    vid.params.freezing_threshold_frames_readonly = freeze_consecutive_threshold;
    
%% perform detection

    % determine which frames are below threshold, these are still frames
    is_still = diff_by_frame < still_pixel_threshold;
    
    % create a variable to hold the flag for freezing frames
    is_freeze = false(length(diff_by_frame),1);
    
    % start the counter at zero
    still_consecutive = 0;
    
    % iterate through each frame
    for i = 1:length(diff_by_frame)
        
        % if the frame is still... 
        if is_still(i)
            
            % ...count the consecutive frames
            still_consecutive = still_consecutive + 1;
            
            % ... if we just reached the threshold...
            if still_consecutive == freeze_consecutive_threshold
                
                % ... mark this and the preceding frames as freezing
                is_freeze( i-freeze_consecutive_threshold+1 : i ) = 1;
                
            % ... if already above the threshold, just mark this frame
            elseif still_consecutive > freeze_consecutive_threshold
                is_freeze(i) = 1;
            end
            
        % if not still, keep the counter at zero
        else
            still_consecutive=0;
        end
    end
    
%% save freezing variables

    vid.object.freezing.is_freezing = is_freeze;
    vid.object.freezing.percent = mean(is_freeze);

%%    

end