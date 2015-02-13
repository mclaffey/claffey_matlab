function [edata] = exp_initialize_inputs_2nd_device_single_key(edata)
% Keyboard initialization for single key on a response device
        
    if IsOSX
        edata.inputs.main_keyboard_index = input_device_by_prompt('Press a key on the main keyboard: ', 'keyboard');
        fprintf('\n');
        edata.inputs.response_index = input_device_by_prompt('Press a key on the response keyboard: ', 'key');
        fprintf('\n');
    else
        % PC's don't need a keyboard index
        edata.inputs.main_keyboard_index = [];
        edata.inputs.response_index = [];
    end
    
%% determine which keys to use for responses

    edata.inputs.key_name = 'space';
    edata.inputs.key_num = KbName(edata.inputs.key_name);

    fprintf('Default response key is %s.\n', edata.inputs.key_name);
    use_defaults = input_yesno('Use default keys?', 'yes');
    
%% if user specified, customize response keys

    if ~use_defaults
        fprintf('Press key on response device to use for response:... ');
        [was_pressed, press_time, pressed_key] = get_key_press(edata.inputs.response_index, [], {}, true);
        edata.inputs.key_num = pressed_key(1);
        edata.inputs.key_name = KbName(edata.inputs.key_num);
        fprintf('key = ''%s''\n', edata.inputs.key_name);
    end
    
end
