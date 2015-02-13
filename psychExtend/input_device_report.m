function [device_list] = input_device_report(show_in_command_prompt)
% Displays a report of which input devices are connected and active
%
% [device_list] = input_device_report([show_in_command_prompt])
%   If input_device_report is passed the optional show_in_command_prompt argument,
%   it returns the device_list in the command window
% 

% Copyright 2008-2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/05/09 function now exits reliably when holding down escape key
% 04/27/09 fixed bug related to datasets in on-screen version
% 04/23/08 original version
        
    if ~exist('show_in_command_prompt', 'var'), show_in_command_prompt = false; end;

    keep_sampling = true;
    
%% command prompt version
    if show_in_command_prompt
        
        while keep_sampling
            clc
            device_list = input_device_list(true);
            display(device_list(:, {'index', 'product', 'type_short', 'active'}));
            active_devices = input_device_find('', true);
            if isempty(active_devices)
                fprintf('\nNo active devices (press key or mouse button)\n\n');
            else
                fprintf('\nActive devices: %s \n\n', mat2str(active_devices));
            end
            if get_key_press([], -1, 'esc', false), keep_sampling = false; end;
            fprintf('Press escape to exit\n');
            pause(.2);
        end            
    
%% PsychToolbox screen version
    else
        % keep querying and displaying the input devices until an
        % escape key is pressed
        kb = input_device_keyboard;
        screen_pointer = scr;
        while keep_sampling
            device_list = input_device_list(true);

            % build the on screen text
            device_text={};
            for line = 1:size(device_list, 1)
                device_text(line) = { sprintf('%d) %s (%s) - %s', ...
                                        device_list.index(line), ...
                                        char(device_list.product(line)), ...
                                        char(device_list.type_short(line)), ...
                                        char(device_list.active_desc(line)) ...
                                        ) }; %#ok<AGROW>
            end

            device_text{end + 1} = '(Remember, you must plug in a device before starting MATLAB for it to register)'; %#ok<AGROW>
            device_text{end + 1} = 'Press ESCAPE to exit'; %#ok<AGROW>
            display_screen_text(device_text, screen_pointer, 'no wait', 16)
            if get_key_press([], -1, 'esc', false), keep_sampling = false; end;
        end
        clear Screen
    end
end



