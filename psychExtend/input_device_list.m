function [device_list] = input_device_list(return_as_dataset)
% Builds a cell of which input devices are connected and active
%
%   [device_list] = input_device_list([RETURN_AS_DATASET])
%
% If optional argument RETURN_AS_DATASET is true, then results are converted to
%   a dataset and returned. If false or not included, results are returned as cell.
% 
% Columns:
%   1) device index
%   2) device name
%   3) transport
%   4) long type
%   5) short type (see 'HELP input_device_find')
%   6) is active? (true or false)
%   7) active descriptor (KEY IS DOWN, BUTTON DOWN, Inactive, unknown)

% Copyright 2008-2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 02/20/09 error handling for PCs
% 02/09/09 improved documentation, dataset field types
% 04/23/08 original version

 
    if ~exist('return_as_dataset', 'var'), return_as_dataset=false; end;

    if ispc
        error('input_device_list depends on PsychHID, which is only implemented for Mac OS X')
    end
    
%% get information on all input devices
    devices = PsychHID('Devices');
    number_of_devices = length(devices);
    device_list = cell(number_of_devices, 7);
    
%% iterate through each device
    for n=1:number_of_devices
        
%% determine device type
        is_keyboard = false;
        is_movable = false;
        device_type_long = lower(devices(n).usageName);
        if any(findstr(device_type_long, 'keyboard'))
            if any(findstr(lower(devices(n).product), 'keypad'))
                device_type_short = 'keypad';
            else
                device_type_short = 'keyboard';
            end
            is_keyboard = true;
        elseif any(findstr(device_type_long, 'mouse'))
            device_type_short = 'mouse';
            is_movable = true;
        elseif any(ismember(n, GetGamepadIndices))
            device_type_short = 'joystick';
            is_movable = true;
        else
            device_type_short = 'unknown';
        end

%% determine device status
        device_status = 'Inactive';
        is_active = false;
        if is_keyboard
            if KbCheck(n)
                device_status = 'KEY IS DOWN';
                is_active = true;
            end
        elseif is_movable
            % if its a mouse or joystick, check to see if any button is
            % pushed
            elements = PsychHID('Elements', n);
            for element_number = 1:length(elements)
                if elements(element_number).usagePageValue == 9 % a button
                    if PsychHID('RawState', n, element_number) > 0
                        device_status = 'BUTTON DOWN';
                        is_active = true;
                        break
                    end
                end
            end
        else
            device_status = 'unknown';
        end

%% add device to list        
        device_list(n,:) = {n devices(n).product devices(n).transport device_type_long device_type_short is_active device_status};
    end
    
%% if requested, return as dataset
    if return_as_dataset
        device_list = dataset({device_list, 'index', 'product', 'transport', 'type_long', 'type_short', 'active', 'active_desc'});
        device_list.index = cell2mat(device_list.index);
        device_list.product = nominal(device_list.product);
        device_list.transport = nominal(device_list.transport);
        device_list.type_long = nominal(device_list.type_long);
        device_list.type_short = nominal(device_list.type_short);
        device_list.active = logical(cell2mat(device_list.active));
        device_list.active_desc = nominal(device_list.active_desc);
    end
end



