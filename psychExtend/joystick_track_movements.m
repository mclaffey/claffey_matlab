function [was_moved, wait_times, joystick_position_array] = joystick_track_movements(joystick_pointers, max_wait_in_secs, percent_move_threshold, sampling_length_in_secs, screen_pointer)
% Waits for a joystick to move and track coordinats for specified time
%
% options for having a maximum wait time and minimum threshold for detecting the move
%
% If called without paramters, returns an array of joystick indices
%
% [was_moved, wait_time, x_pos, y_pos, speed] = get_joystick_move(joystick_pointer, max_wait_in_secs, percent_move_threshold)
%
%   joystick_pointer = (optional integer) hardware index of which joystick
%       to track
%   max_wait_in_secs = (optional integer) if > 0, returns null if user
%       doesn't respond in time 
%   percent_move_threshold = (optional float) Percent of total available
%       deflect which the joystick must move before registering the move
%

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 01/07/08 original version
%
    wait_start_time = GetSecs;


%% joystick detection
%
% if no joystick index is specified, attempt to find one. Warn the user
% though, because it is inefficient to repeatly call this
%
% NOTE:
%
% When Gamepad() refers to joystick_indexes, it means the 1st, 2nd,
% 3rd joystick that it can find. This function takes the joystick_pointer
% argument as an overall device index. There are conversion functions below
% to handle these two different systems.
%
% For example, joysticks might be found at device index 9 and 13, but
% Gamepad would refer to them as simply 1 and 2 

    if nargin < 1
        joystick_name = 'Logitech Attack 3';
        joystick_pointers = Gamepad('GetGamepadIndicesFromNames', joystick_name);
        joystick_pointers = convert_joystick_to_device_index(joystick_pointers);
        if isempty(joystick_pointers)
            error('No joystick index was specified and the joystick could not be located automatically')
        else
            warning('It is inefficient to have track_joystick_movement() auto-detecting the joysticks: %s\n', mat2str(joystick_pointers)) %#ok<WNTAG>
        end
    end

    % convert to Gamepad's version of indices
    joystick_pointers = convert_device_to_joystick_pointer(joystick_pointers);

    

%% setup function variables
    if nargin < 2
        max_wait_in_secs = 0;
    else
        end_wait_time = wait_start_time + max_wait_in_secs;
    end
    if nargin < 3, percent_move_threshold = 0.05; end;
    if nargin < 4, sampling_length_in_secs = .5; end;
    if nargin < 5, screen_pointer = 0; end;
    if nargin > 5, error('Too many arguments supplied to get_joystick_move'); end;

    % set constants
    axis_max_deflection = 32768;

    % the joystick coordinates are collected in an array with the following
    % dimensions:
    %   columns: GetSecs, x_pos, y_pos, xy_pos, speed
    %   rows: each reading is entered as a new row. The number of rows
    %       recorded is calculated based on sample_time / sample_interval
    %   datasheets (3rd dimension): each joystick is in a separate sheet
    % recording begins for all joysticks when any one reaches threshold
    joystick_count = length(joystick_pointers);
    sampling_start_time = NaN(1, joystick_count);
    threshold_just_reached = zeros(1, joystick_count);
    joystick_position_array = NaN(0, 3, joystick_count);
    
    % the function also returns the variable initial_move_directions, which
    % is an array containing one value for each joystick. That value is the
    % direction in degrees of the initial joystick movement (rounded to
    % nearest increment of 45, with 0 being dead right)
    % (NaN is the default value, since a zero reflects movement right)
    
    if screen_pointer ~= 0
        screen_will_need_to_be_cleared = 1;
        screen_clear_delay = min(0.1, sampling_length_in_secs);
        screen_clear_time = 0;
    else
        screen_will_need_to_be_cleared = 0;
        screen_clear_time = 0;
    end

    sampling_index = 1;
    sampling_end_time = 0; % not set to a specified value until sampling begins

    
%% main sampling code

    while should_i_keep_sampling()
        % fast sampling of joysticks
        for joystick_number = 1:joystick_count
            current_sample_time = GetSecs;
            x_pos = Gamepad('GetAxis', joystick_pointers(joystick_number), 1) / axis_max_deflection;
            xy_radius = abs(x_pos);
            
            if isnan(sampling_start_time(joystick_number)) && (xy_radius > percent_move_threshold)
                % procedure for the first time joystick crosses the threshold
                sampling_start_time(joystick_number) = current_sample_time - wait_start_time;
                threshold_just_reached(joystick_number) = 1;
                if screen_will_need_to_be_cleared
                    screen_clear_time = GetSecs + screen_clear_delay;
                end
                if sampling_end_time == 0
                    sampling_end_time = current_sample_time + sampling_length_in_secs;
                end
            end
                
            if (sampling_start_time(joystick_number) ~= 0)
                joystick_position_array(sampling_index, 1, joystick_number) = current_sample_time;
                joystick_position_array(sampling_index, 2, joystick_number) = x_pos;
            end
        end

% This section was originally used in Mike's task, but is not necessary if
% code is not interfacing with DAQ. (igreenhouse, 09/15/09)
%         % after sampling all joysticks, send code to micro if necessary
%         while any(threshold_just_reached)
%             newly_triggered_joystick = find(threshold_just_reached);
%             send_to_micro('marker', num2str(newly_triggered_joystick));
%             threshold_just_reached(newly_triggered_joystick) = 0;
%         end
        
        % if any joysticks have crossed the threshold, sample recording has
        % begun, advance index
        if any(sampling_start_time)
            sampling_index = sampling_index + 1;
        end
        
        % if it is time to clear the screen, do so. the screen is cleared
        % after a delay to keep the Screen('Flip') function from
        % interferring with initial sampling of the joysticks
        if screen_clear_time && (GetSecs > screen_clear_time)
            Screen('Flip', screen_pointer);
            screen_clear_time = 0;
            screen_will_need_to_be_cleared = 0;
        end
    end
%% return results

    wait_times = sampling_start_time;
    was_moved = any(sampling_start_time);

%% helper functions

    function [keep_sampling] = should_i_keep_sampling()
        % if sample recording has begun, exit after the specified time
        if any(sampling_start_time)
            if GetSecs > sampling_end_time
                keep_sampling = 0;
            else
                keep_sampling = 1;
            end

        % if a maximum wait time wasn't specified, then keep waiting
        elseif max_wait_in_secs == 0
            keep_sampling = 1;
            
        % otherwise, only wait the specified time
        else
            if GetSecs > end_wait_time
                keep_sampling = 0;
            else
                keep_sampling = 1;
            end
        end
    end

%% index conversions

    function [device_index] = convert_joystick_to_device_index(joystick_pointer)
        device_index = joystick_pointer;
        GamepadIndices = GetGamepadIndices;
        for xx = 1:length(joystick_pointer)
            device_index(xx) = GamepadIndices(joystick_pointer(xx));
        end
    end

    function [joystick_pointer] = convert_device_to_joystick_pointer(device_index)
        joystick_pointer = device_index;
        GamepadIndices = GetGamepadIndices;
        for xx = 1:length(device_index)
            joystick_pointer(xx) = find(GamepadIndices==device_index(xx));
        end
    end

end
    