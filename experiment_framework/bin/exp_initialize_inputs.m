function [edata] = exp_initialize_inputs(edata)
% Finds input devices and confirms keys being used
    
    if IsOSX
        edata.inputs.main_keyboard_index = input_device_by_prompt('Please press any key on the main keyboard\n', 'keyboard');
    else
        % PC's don't need a keyboard index
        edata.inputs.main_keyboard_index = [];
    end
    
end
