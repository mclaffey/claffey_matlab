function [button,rt] = joystick_get_trigger_button(joystick_indices)
% Wait for a trigger press    

    no_trigger_click = 1;
    start_time = GetSecs;

    valid_keys = [2 3 4 5];

    while no_trigger_click
        for x = 1:length(joystick_indices)
            joystick_index = joystick_indices(x);
            elements = PsychHID('Elements', joystick_index);
            for element_number = 1:length(elements)
                if elements(element_number).usagePageValue == 9 % a button
                    if PsychHID('RawState', joystick_index, element_number) > 0
                        if ismember(element_number, valid_keys)
                            button = elements(element_number).elementIndex;
                            rt = GetSecs - start_time;
                            no_trigger_click=0; %#ok<NASGU>
                            return
                        end
                    end
                end
            end
        end
    end
end