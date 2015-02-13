function [relevant_active_devices] = input_device_by_prompt(prompt_text, filter_type)
% Prompts the user to activate a device and returns the relevant index
%
% [relevant_active_devices] = input_device_by_prompt(PROMPT_TEXT, FILTER_TYPE)
%
%   PROMPT_TEXT is the text displayed to the user to indicate which input
%       device should be clicked, typed on, etc
%
%   FILTER_TYPE limits the type of input device (keyboard, joystick, etc) that will be accepted. See
%       help on input_device_find() for complete details.
%
% It is possible to return more than one active device, so the
% calling function must deal with this possibility.
%
% See also: input_device_by_prompt, input_device_find, input_device_keyboard,
%   input_device_list, input_device_report

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/29/09 addition to help file
% 10/27/08 added ListenChar
% 10/22/08 cleaned up help
% 04/23/08 original version

    if ~exist('filter_type', 'var'), filter_type = ''; end;
    
    relevant_devices = input_device_find(filter_type);
    
    if isempty(relevant_devices)
        error('No devices of type %s were found.', filter_type)
    end
    
    % wait for all devices of relevant type to be inactive before beginning
    % the search. this prevents automatically finding the device that
    % issued the command (e.g. the main keyboard)
    while ~isempty(input_device_find(filter_type, true)), pause(.05); end;
    
    % now search for the first relevant, active device
    try
        ListenChar(2);
        fprintf(prompt_text);
        relevant_active_devices = input_device_find(filter_type, true);
        while isempty(relevant_active_devices)
            pause(.05);
            relevant_active_devices = input_device_find(filter_type, true);
        end;
    catch
        ListenChar(0);
        rethrow(lasterr);
    end
    ListenChar(0);
    
end