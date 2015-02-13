function [device_indices] = input_device_find(type_filter, is_active_filter)
% Find input device numebers using criteria
%
% [DEVICE_INDICES] = input_device_find([TYPE_FILTER [, IS_ACTIVE_FILTER]])
%
%   TYPE_FILTER - can be '' to include all devices or any of the following:
%       keyboard
%       keybad
%       key (for both keyboards and kepypads)
%       mouse
%       joystick
%       other 
%
%   IS_ACTIVE_FILTER - if true, will limit the list to keyboards with keys
%      down and mice or joysticks with buttons down
%
%   Example
%       input_device_find('', true)         % all active devices
%       input_device_find('key')            % all keypads and keyboards
%       input_device_find('mouse', true)    % active mice
%
% See also: input_device_by_prompt, input_device_find, input_device_keyboard,
%   input_device_list, input_device_report

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 10/22/08 cleaned up help
% 04/23/08 original version

    device_list = input_device_list(true);
    
    % filter the list by type
    if exist('type_filter', 'var') && ~isempty(type_filter)
        type_filter = lower(type_filter);
        
        % if the type provided was 'key', search for both keyboards and
        % keypads
        if strcmp(type_filter, 'key')
            keypad_indices = strcmp( cellstr(char(device_list.type_short)), 'keypad' );
            keyboard_indices = strcmp( cellstr(char(device_list.type_short)), 'keyboard' );
            filter_indices = or(keypad_indices, keyboard_indices);
        else
            filter_indices = strcmp( cellstr(char(device_list.type_short)), type_filter );
        end
        device_list = device_list(filter_indices, :);
    end

    % filter the list by is active
    if exist('is_active_filter', 'var') && is_active_filter
        filter_indices = device_list.active;
        device_list = device_list(filter_indices, :);
    end

    device_indices = device_list.index;
end