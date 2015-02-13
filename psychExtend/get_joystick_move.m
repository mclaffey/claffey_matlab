function [was_moved, wait_time, x_pos, y_pos, speed] = get_joystick_move(joystick_pointer, max_wait_in_secs, percent_move_threshold)
%
% Waits for a joystick move, with options for having a maximum
% wait time and minimum threshold for detecting the move
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

% Written by mikeclaffey@yahoo.com
% Last updated: Jan 17 2008
%

    start_time = GetSecs;


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
        joystick_pointer = Gamepad('GetGamepadIndicesFromNames', joystick_name);
        joystick_pointer = convert_joystick_to_device_index(joystick_pointer);
        if isempty(joystick_pointer)
            error('No joystick index was specified and the joystick could not be located automatically')
        elseif length(joystick_pointer) > 1
            error('No joystick index was specified and more than one joystick was found: %s', mat2str(joystick_pointer))
        else
            warning('in get_joystick_move, no joystick index was specified and it is inefficient to repeated search for one.') %#ok<WNTAG>
        end
    end

    % convert to Gamepad's version of indices
    joystick_pointer = convert_device_to_joystick_pointer(joystick_pointer);

    

%% setup function variables
    if nargin < 2
        max_wait_in_secs = 0;
    else
        end_wait_time = GetSecs + max_wait_in_secs;
    end
    if nargin < 3, percent_move_threshold = 0.01; end;
    if nargin > 4, error('Too many arguments supplied to get_joystick_move'); end;

    %% set constants
    axis_max_deflection = 32768;
    speed_calc_time = 0.1;
    was_moved = 0;

    
%% wait for joystick move

    initial_xy_pos = 0;
    while movement_below_threshold() && wait_time_hasnt_expired()
        sample_time = GetSecs;
        x_pos = Gamepad('GetAxis', joystick_pointer, 1) / axis_max_deflection;
        y_pos =  Gamepad('GetAxis', joystick_pointer, 2) / axis_max_deflection;
        initial_xy_pos = sqrt(x_pos^2 + y_pos^2);
    end
    
    wait_time = GetSecs - start_time;

%% return results
    if was_moved
        wait_time = sample_time - start_time;
    else
        wait_time = GetSecs - start_time;
        speed = 0;
    end    
    
%% helper functions

    function [hasnt_expired] = wait_time_hasnt_expired()
       if max_wait_in_secs == 0
           hasnt_expired = 1;
       else
           if GetSecs < end_wait_time
               hasnt_expired = 1;
           else
               hasnt_expired = 0;
           end
       end
    end

    function [invalid_move] = movement_below_threshold
        if initial_xy_pos < percent_move_threshold
            invalid_move = 1;
        else
            invalid_move = 0;
            was_moved = 1;
            calculate_speed()
        end
    end

    function calculate_speed()
        while GetSecs < (sample_time + speed_calc_time); end; % wait enough time to calculate speed

        % calculate the new joystick position and speed
        x_pos = Gamepad('GetAxis', joystick_pointer, 1) / axis_max_deflection;
        y_pos =  Gamepad('GetAxis', joystick_pointer, 2) / axis_max_deflection;
        incremental_xy_pos = sqrt(x_pos^2 + y_pos^2);
        speed = (incremental_xy_pos - initial_xy_pos) / speed_calc_time;
    end

%% index conversions

    function [device_index] = convert_joystick_to_device_index(joystick_pointer)
        device_index = joystick_pointer;
        GamepadIndices = GetGamepadIndices;
        for x = 1:length(joystick_pointer)
            device_index(x) = GamepadIndices(joystick_pointer(x));
        end
    end

    function [joystick_pointer] = convert_device_to_joystick_pointer(device_index)
        joystick_pointer = device_index;
        GamepadIndices = GetGamepadIndices;
        for x = 1:length(device_index)
            joystick_pointer(x) = find(GamepadIndices==device_index(x));
        end
    end

end
    