function [key_was_pressed, wait_time, list_of_pressed_keys] = get_simultaneous_key_press(monitoring_window, keyboard_pointer, max_wait_in_secs, valid_key_list, wait_if_already_down)
% Similar to get_key_press, but checks for two sequential presses
%
% WARNING: THIS IS A BIG KLUGE AND WILL PROBABLY BE REMOVED
%
% [key_was_pressed, wait_time, list_of_pressed_keys] = get_simultaneous_key_press(monitoring_window, keyboard_pointer, max_wait_in_secs, valid_key_list, wait_if_already_down)
%
% Similar to get_key_press(), but after the first key press (if any),
% continues collecting other valid key presses for the length of
% monitoring_window
%
%   monitoring_window = length of time in seconds to monitor for additional
%       key pressess
%
%   Following variables are same as in get_key_press():
%
%   keyboard_pointer = (optional integer) hardware index of which input
%       device to check. 0 checks the default keyboard.
%   max_wait_in_secs = (optional integer) if > 0, returns null if user
%       doesn't respond in time 
%   valid_key_list = (optional cell array) if not empty, only stops checking
%       when a key in the list is pressed (e.i. {'Z' 'Space' 'M'})
%   wait_if_already_down = (optional integer) if not 0, will wait to
%       start checking until any currently pressed keys are released
%       (defaults to 0)

% Written by mikeclaffey@yahoo.com
% Last updated: Mar 4 2008
%


%% setup function variables
    if nargin < 2, keyboard_pointer = 0; end;
    if nargin < 3
        max_wait_in_secs = 0;
    else
        end_wait_time = GetSecs + max_wait_in_secs;
    end
    valid_keys = [];
    if nargin < 4, valid_key_list = {}; end;
    if nargin < 5, wait_if_already_down = 1; end;
    if nargin > 5, error('Too many arguments supplied to get_simultaneous_key_press'); end;
    

%% get the first key press
    [key_was_pressed, wait_time, list_of_pressed_keys] = get_key_press(keyboard_pointer, max_wait_in_secs, valid_key_list, wait_if_already_down);

    
    
%% monitor for additional presses    
    % determine which keys haven't yet been pressed and query for those
    remaining_valid_keys = setxor(KbName(list_of_pressed_keys), valid_key_list);
    
    % determine how long to monitor for additional presses
    end_of_monitoring_window = GetSecs + monitoring_window;
    remaining_wait_time = end_of_monitoring_window - GetSecs;
    
    while (GetSecs < end_of_monitoring_window) && ~isempty(remaining_valid_keys)
        if isempty(valid_key_list), remaining_valid_keys = {}; end;
       [key_pressed, junk2, additional_list_of_pressed_keys] = get_key_press(keyboard_pointer, remaining_wait_time, remaining_valid_keys, 0);
       
        if key_pressed
            list_of_pressed_keys = horzcat(list_of_pressed_keys, additional_list_of_pressed_keys);
            remaining_valid_keys = setxor(KbName(additional_list_of_pressed_keys), remaining_valid_keys);
            remaining_wait_time = end_of_monitoring_window - GetSecs;
        end
    end
    
    list_of_pressed_keys = unique(list_of_pressed_keys);
end