function [edata] = exp_initialize_inputs_keyboard_left_and_right(edata)
% Simple keyboard initialization for a left and right key
        
    if IsOSX
        edata.inputs.main_keyboard_index = input_device_by_prompt('Press a key on the response keyboard: ', 'keyboard');
        fprintf('\n');
    else
        % PC's don't need a keyboard index
        edata.inputs.main_keyboard_index = [];
    end
    
%% determine which keys to use for responses

    edata.inputs.left_key_name = 'z';
    edata.inputs.right_key_name = '/?';
    edata.inputs.left_key_num = KbName(edata.inputs.left_key_name);
    edata.inputs.right_key_num = KbName(edata.inputs.right_key_name);

    fprintf('Default keys are %s on the left and %s on the right.\n', ...
        edata.inputs.left_key_name, edata.inputs.right_key_name);
    use_defaults = input_yesno('Use default keys?', 'yes');
    
%% if user specified, customize response keys

    if ~use_defaults
        fprintf('Press key for left hand, left key:... ');
        [was_pressed, press_time, pressed_key] = get_key_press(edata.inputs.main_keyboard_index, [], {}, true);
        edata.inputs.left_key_num = pressed_key(1);
        edata.inputs.left_key_name = KbName(edata.inputs.left_key_num);
        fprintf('key = ''%s''\n', edata.inputs.left_key_name);

        fprintf('Press key for left hand, right key:... ');
        [was_pressed, press_time, pressed_key] = get_key_press(edata.inputs.main_keyboard_index, [], {}, true);
        edata.inputs.right_key_num = pressed_key(1);
        edata.inputs.right_key_name = KbName(edata.inputs.right_key_num);
        fprintf('key = ''%s''\n', edata.inputs.right_key_name);
    end
    
end
