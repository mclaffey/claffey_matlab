function [reviewed_vid] = review_matrix_video(vid_data)
% Review a 3-D matrix as a movie with playback features
%
%   [reviewed_vid] = review_matrix_video(vid_data)

% vid_data can either be a matrix or the following structure
%
%   vid_data.video          MxNxO matrix of video data
%   vid_data.labels         O vector indicating the state of each frame
%   vid_data.current_frame  integer
%
% reviewed_vid will have the following structure
%
%   reviewed_vid.video      
%   reviewed_vid.labels 	
%   reviewed_vid.current_frame 



% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 04/12/13 improved useability of setting focus and catching key strokes
%          added "measure" graph (activity) and freezing functionality
% 09/02/10 updated documentation

%% initialize variables

    if isstruct(vid_data)
        % save incoming copy
        original_vid_data = vid_data;
        
        % grab video
        vid_data = original_vid_data.video;
        
        % if labels are present, grab those
        if isfield(original_vid_data, 'labels')
            vid_labels = original_vid_data.labels;
        end
        
        % if current index exists, grab it
        if isfield(original_vid_data, 'current_frame')
            current_index = original_vid_data.current_frame;
        end
        
        % if video measure exists, grab it
        if isfield(original_vid_data, 'measure')
            vid_measure = original_vid_data.measure;
        end
        
        % if freezing data exists, grab it
        if isfield(original_vid_data, 'is_freezing')
            % change all object values to 2 in frames when object froze
            % so that it appears as a different color in the review
            vid_data(:,:,original_vid_data.is_freezing) = ...
                vid_data(:,:,original_vid_data.is_freezing) * 2;
        end
    end

    % if vid labels don't yet exist, make them
    if ~exist('vid_labels', 'var')
        vid_labels = nan(size(vid_data,3),1);
    end

    % if current_index don't yet exist, make it
    if ~exist('current_index', 'var')
        current_index = 1;
    end

    

    
    frame_count = size(vid_data, 3);

%% display keyboard shortcut help

    fprintf('(P) for play forward, (R) for play reverse, (space) for pause\n');
    fprintf('(left) for one frame back, (right) for one forward\n');
    fprintf('(f) jump to frame, (s) change speed, (u) for pause time\n');
    fprintf('Label with (1) or (2), remove label with (W)\n');
    fprintf('(x) to exit\n');
    
%% open figure

    f = figure;
    set(f, 'KeyPressFcn', @orbus1_callback_keypress_mouse_activity)
    video_axis = subplot(5,1,1:4);
    axes;
    
    % if there is freezing data, adjust color map
    if isfield(original_vid_data, 'is_freezing')
        % color map
        %  0 = black
        %  1 = white
        %  2 = red
        colormap_bwr = [0 0 0;1 1 1;1 0 0];
        colormap(colormap_bwr);
        use_imagesc = false;
    else
        colormap(bone);
        use_imagesc = true;
    end
    vid_data = vid_data + 1;
    
    
    graph_axis = subplot(5,1,5);


%% create two overlays to appear when a label applies to a frame
    
    label_1_pixels = false(size(vid_data(:,:,1)));
    label_1_pixels(20:40, 10:30) = true;
    label_2_pixels = false(size(vid_data(:,:,1)));
    label_2_pixels(20:40, 50:70) = true;    
    
%% enter querying loop until user says to exit

    keep_going = true;
    index_increment = 1;
    pause_amount = 0;
    refresh_image = true;
    
    while keep_going
        
        % change the index if in an increment mode
        if index_increment ~= 0
            
            % increment frame
            current_index = current_index + index_increment;
            refresh_image = true;

            % stop at the end or beginning
            if index_increment > 0 && current_index >= frame_count
                fprintf('End of video\n');
                index_increment = 0;
                current_index = frame_count;
            elseif index_increment < 0 && current_index <= 1
                fprintf('Beginning of video\n');
                index_increment = 0;
                current_index = 1;
            end
        end
                
        % determine if a new image needs to be displayed
        if refresh_image
            
            % diplay the new image
            subplot(video_axis);
            hold off
            if use_imagesc
                imagesc(vid_data(:,:,current_index));
            else
                image(vid_data(:,:,current_index));
            end
            hold on
            
            % highlight with activity
            if vid_labels(current_index) == 1
                draw_transparent_region(label_1_pixels, [1 0 0], .4);
            elseif vid_labels(current_index) == 2
                draw_transparent_region(label_2_pixels, [1 0 0], .4);
            end

            % update frame graph
            subplot(graph_axis);
            hold off
            stairs(vid_labels);

            if exist('vid_measure', 'var')
                plot(vid_measure);
            end
            
            xlim([0 frame_count]);
            
            hold on
            plot([current_index;current_index], [0 1000]);
            
            drawnow;
            % return focuse to figure window
            figure(f);
            set(0, 'CurrentFigure', f);

            
        end
        
        % pause if user entered pause amount
        pause(pause_amount);
        
    end
    
%% exiting
    
    % close figure
    close(f);
    
    % wrap up data
    reviewed_vid.video = vid_data;
    reviewed_vid.labels = vid_labels;
    reviewed_vid.current_frame = current_index;    
    
%% callback function

    function orbus1_callback_keypress_mouse_activity(source_handle, event_data) %#ok<INUSL>

        switch event_data.Key

            %   forward one image
            case 'rightarrow'
                if current_index < frame_count
                    current_index = current_index + 1;
                    refresh_image = true;
                else
                    fprintf('Already at end of video.\n');
                end

            %   backward one image
            case 'leftarrow'
                if current_index > 1
                    current_index = current_index - 1;
                    refresh_image = true;
                else
                    fprintf('Already at beginning of video.\n');
                end

            %   play forward
            case 'p'
                index_increment = 1;

            %   play backward
            case 'r'
                index_increment = -1;

            % pause
            case 'space'
                index_increment = 0;
                
            % jump to frame
            case 'f'
                uimenufcn(source_handle,'WindowCommandWindow');
                current_index = input('Enter frame number: ');
                
            % change speed
            case 's'
                uimenufcn(source_handle,'WindowCommandWindow');
                index_increment = input('Enter number of frames to increment each time: ');

            % pause amount
            case 'u'
                uimenufcn(source_handle,'WindowCommandWindow');
                pause_amount = input('Enter seconds to pause between frames: ');

            %   tag object 1
            case '1'
                vid_labels(current_index) = 1;
                refresh_image = true;
                
            %   tag object 2
            case '2'
                vid_labels(current_index) = 2;
                refresh_image = true;

            %   erase activity data
            case 'w'
                vid_labels(current_index) = nan;
                refresh_image = true;

            % exit
            case 'x'
                keep_going = false;

        end
        
        % return focuse to figure window
        figure(source_handle);
        set(0, 'CurrentFigure', source_handle);     

    end

%%

end
    