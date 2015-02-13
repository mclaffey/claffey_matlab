function [click_x, click_y, wait_time] = get_mouse_click(screen_pointer, max_wait_in_secs, target_area, wait_if_already_down)
%
% Waits for a mouse click, with options for having a maximum
% wait time and checking only a certain target area
%
% function [click_x, click_y, wait_time] = get_mouse_click(screen_pointer, max_wait_in_secs, target_area, wait_if_already_down)
%
%   screen_pointer = (optional integer) hardware index of which screen to
%       track
%   max_wait_in_secs = (optional integer) if > 0, returns null if user
%       doesn't respond in time 
%   target = (optional array) Array for a rectangle on the screen [left top
%       right bottom]. If not emplty, only stops checking when the mouse is
%       clicked inside the rectangle
%   wait_if_already_down = (optional integer) if not 0, will wait to
%       start checking until any currently pressed buttons are released
%       (defaults to 0)
%

% Written by mikeclaffey@yahoo.com
% Last updated: Jan 17 2008
%

%% setup function variables
    start_time = GetSecs;
    if nargin < 1, screen_pointer = 0; end;
    if nargin < 2
        max_wait_in_secs = 0;
    else
        end_wait_time = GetSecs + max_wait_in_secs;
    end
    if nargin < 3, target_area = []; end;
    if nargin < 4, wait_if_already_down = 1; end;
    if nargin > 4, error('Too many arguments supplied to get_mouse_click'); end;


    click_x = 0;
    click_y = 0;
    buttons = [];
    
%% wait for mouse response
    if wait_if_already_down
        wait_if_mouse_is_already_down
    end
   
    while wait_time_hasnt_expired && ~click_within_target
        [click_x, click_y, buttons] = GetMouse(screen_pointer);
        pause(0.001);
    end
    
    wait_time = GetSecs - start_time;

%% return results

    % if there was a click but it wasn't valid, clear out the coordinate
    % variables so these are not returned by the function and mistaken for
    % valid click coordinates
    if ~click_within_target
        click_x = 0;
        click_y = 0;
    end

    
    
%% helper functions

    function [hasnt_expired] = wait_time_hasnt_expired
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

    function [valid_click] = click_within_target
        if ~any(buttons)
            valid_click = 0;
        else
            if isempty(target_area)
                valid_click = 1;
            elseif (click_x > target_area(1)) && (click_x < target_area(3)) && (click_y > target_area(2)) && (click_y < target_area(4))
                valid_click = 1;
            else
                valid_click = 0;
            end
        end
    end
    
    function wait_if_mouse_is_already_down
        % if mouse is already down from a previous click, wait for it to
        % come up first.
        % 
        % When a the user makes a mouse click, it is possible for MATLAB to execute its
        % subsequent commands and come upon a 2nd instruction to get a
        % mouse click before the user has released the mouse. Since the
        % mouse is still down from the first click, it will mistakenly grab
        % the currently location all over again. This waiting functions
        % prevents this error. 
        [click_x, click_y, buttons] = GetMouse(screen_pointer);
        while any(buttons)
            [click_x, click_y, buttons] = GetMouse(screen_pointer);
        end
    end
end
    