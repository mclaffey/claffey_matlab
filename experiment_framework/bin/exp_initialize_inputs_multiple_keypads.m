function [edata] = exp_initialize_inputs_multiple_keypads(edata, keypad_count, get_single_key)
% Keyboard initialization for two keypads
        
    if IsOSX
        edata.inputs.main_keyboard_index = input_device_by_prompt('Press a key on the main keyboard: ', 'keyboard');
        fprintf('\n');
    else
        % PC's don't need a keyboard index
        edata.inputs.main_keyboard_index = [];
        edata.inputs.response_index = [];
    end
    
%% get required number of keypads

    edata.inputs.keypad_indices = nan(1, keypad_count);
    edata.inputs.key_nums = nan(1, keypad_count);
    edata.inputs.key_names = cell(1, keypad_count);
    
    for x = 1:keypad_count
        
        % For Mac's, get input device index
        if IsOSX
            key_prompt = sprintf('Press a key on keypad %d: ', x);
            edata.inputs.keypad_indices(x) = input_device_by_prompt(key_prompt, 'key');
        end
        
        % if there is a single response key
        if get_single_key
            fprintf('Which key:... ');
            if IsOSX
                [was_pressed, press_time, pressed_key] = get_key_press(edata.inputs.keypad_indices(x), [], {}, true);
            else
                [was_pressed, press_time, pressed_key] = get_key_press([], [], {}, true);
            end
            edata.inputs.key_nums(x) = pressed_key(1);
            edata.inputs.key_names{x} = KbName(edata.inputs.key_nums(x));
            fprintf('%s\n', edata.inputs.key_names{x});
        else
            fprintf('\n');
        end
    end
        
end
