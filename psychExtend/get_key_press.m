function [varargout] = get_key_press(keyboard_pointer, max_wait_in_secs, valid_key_list, wait_if_already_down)
% Waits for user input from keyboard with customizable options
%
% get_key_press is based on the KbCheck function, but provides a variety of options such as
% enforcing a maximum wait time and checking for only certain keys
%
% [key_was_pressed, wait_time, list_of_pressed_keys] = get_key_press(keyboard_pointer, max_wait_in_secs, valid_key_list, wait_if_already_down)
%
%   keyboard_pointer = (optional integer array) device index of the input device to check. 0 checks
%       the default keyboard. an array of device indices can be specified to cycle through multiple 
%       keyboards. if any empty array is passed, all keyboards and keypads are checked
%
%   max_wait_in_secs = (optional integer) if max_wait_in_secs > 0, waits for response for given
%       number of seconds. if no response is made in time, the function returns null. If
%       max_wait_in_secs is empty or = 0, there is no time limit. If max_wait_in_secs is < 0, it
%       executes a single kbcheck() call and returns result.
%
%   valid_key_list = (optional cell array) if not empty, only accepts responses from specified keys 
%       (example: {'z' 'space' 'm'})
%
%   wait_if_already_down = (optional boolean) if TRUE, the function will not beginning checking for
%       keys until all the buttons have been released. This is useful for ignoring key presses that
%       were in response to something before the get_key_press call. (defaults to TRUE)
%
% Example:
%   get_key_press()
%
%       Continually checks all keyboards until any response is made
%
%   get_key_press(0, 2, {'z', 'space', 'm'}, true)
%
%       The above command checks the default keyboard for only the 'Z', 'M' and Space key. It ignores
%       any other pressed keys. It will wait for up to 2 seconds for a valid key to be pressed,
%       otherwise it returns key_was_pressed = 0.

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/18/09 fixed handling of keyboard pointer for mac and pc
% 05/05/09 allow valid_key_list to be passed as an array of key numbers
% 04/30/09 if no keyboard_pointer is provided, gets all keyboards and keypads
% 04/30/09 cleaned up documentation
% 02/18/09 fix so that a negative max_wait_in_secs does at least one KbCheck
% 02/18/09 allow get_key_press to be used in an if statement (nargin=0)
% 02/18/09 allow valid_key_list to be passed as a string
% 02/12/09 functionality of checking multiple keyboards
% 02/10/09 corrected empty value for max_wait_in_secs to be adjusted to zero
% 09/17/08 Cleaned up help
% 04/23/08 Previous version

%% setup function variables

    start_time = GetSecs;
    
    % check the keyboard_pointer variable
    if ispc
        % on pc, can not check individual keyboard pointers
        keyboard_pointer = [];
    else
        % on mac, if there is no keyboard_pointer, find all keyboards & keypads
        if ~exist('keyboard_pointer', 'var') || isempty(keyboard_pointer)
            keyboard_pointer = input_device_find('key');
            if isempty(keyboard_pointer)
                error('get_key_press:couldnt_find_keyboard', 'Input device wasn''t specified and could not find keyboard automatically');
            end
        end
    end
    
    % determine the time to stop checking for responses
    if ~exist('max_wait_in_secs', 'var') || isempty(max_wait_in_secs)
        max_wait_in_secs = 0;
    else
        end_wait_time = GetSecs + max_wait_in_secs;
    end
    
    % check the valid_key_list
    if ~exist('valid_key_list', 'var')
        valid_key_list = [];
    else
        % if a single key name was passed as a string, convert it to a cell for consistency
        if ischar(valid_key_list), valid_key_list = {valid_key_list}; end;
        
        % if the list was passed as numbers, convert to cell
        if isnumeric(valid_key_list), valid_key_list = mat2cell_same_size(valid_key_list); end;
        
        % check that each item in the list is a valid key name
        for x = 1:length(valid_key_list)
            % If the excape key is being checked, it is called escape on a mac and esc on a PC
            if strncmpi(valid_key_list{x}, 'esc', 3)
                if ispc
                    valid_key_list{x} = 'esc';
                else
                    valid_key_list{x} = 'ESCAPE';
                end
            end
            
            % try converting any key names as strings to the corresponding KbName integer
            try
                if not(isnumeric(valid_key_list{x}))
                    valid_key_list(x) = {KbName(valid_key_list{x})};
                end
            catch
                error('Item %d in the valid_key_list array is not recognizable:', x, any2str(valid_key_list{x}));
            end
        end
        % now convert it to a matrix
        valid_key_list = cell2num(valid_key_list);
    end;
    
    % determine whether to delay checking until all keys have been released
    if ~exist('wait_if_already_down', 'var'), wait_if_already_down = true; end;
    if nargin > 4, error('Too many arguments supplied to get_key_press'); end;
    
    KeyIsDown = 0;
    list_of_pressed_keys = [];
    
%% wait for all keys to be released
    if wait_if_already_down % this variable is the optional arguement
        wait_for_unpressed_keyboard() % this is the actual name of the sub function
    end

%% MAIN FUNCTIONALITY - check input devices for responses

    % capture keypresses to prevent display in command window
    ListenChar(2);
    
    % work in a try-catch loop so that ListenChar(2) can be undone if there are any problems
    try
        
        % loop until the time is up or a valid key has been pressed
        while wait_time_hasnt_expired() && ~keypress_is_valid_key()
            [KeyIsDown, press_time, keyCode] = KbCheck_many_keyboards(keyboard_pointer);
            list_of_pressed_keys = find(keyCode > 0);
            pause(0.001);
        end
    catch
        ListenChar(0);
        rethrow(lasterror);
    end
    ListenChar(0);
    
%% return results
    
    if nargout == 0
        % when get_key_press is a logical expression of an if statement
        %   for example: if get_key_press([], .001, 'escape') % evaluates to true if the escape is down
        varargout = {keypress_is_valid_key};
    else
        % otherwise build outputs and return the appropriate number of them
        key_was_pressed = keypress_is_valid_key;
        wait_time = GetSecs - start_time;
        varargout = {key_was_pressed, wait_time, list_of_pressed_keys};
        varargout = varargout(1:nargout);
    end


    
%% helper functions

    function [hasnt_expired] = wait_time_hasnt_expired()
       if max_wait_in_secs == 0
           hasnt_expired = 1;
       elseif max_wait_in_secs < 0
           hasnt_expired = 1;
           % change these variables so that it wont provide true next time
           max_wait_in_secs = 1;
           end_wait_time = GetSecs;
       else
           if GetSecs < end_wait_time
               hasnt_expired = 1;
           else
               hasnt_expired = 0;
           end
       end
    end

    function [valid_key] = keypress_is_valid_key()
        if ~KeyIsDown
            valid_key = 0;
        elseif isempty(valid_key_list)
            valid_key = 1;
        else
            if any(intersect(list_of_pressed_keys, valid_key_list))
                valid_key = 1;
            else
                valid_key = 0;
            end
        end
    end

    function wait_for_unpressed_keyboard
        KeyIsDown = 1;
        while KeyIsDown
            KeyIsDown = KbCheck_many_keyboards(keyboard_pointer);
        end
    end

end
    