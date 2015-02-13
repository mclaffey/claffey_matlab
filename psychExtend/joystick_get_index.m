function [ordered_indices] = joystick_get_index(w)
% Returns the device index of 'Attack 3' joystick among USB devices

% Copyright 2008-2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 09/15/09 fixed bugs that prevented execution (igreenhouse)
% 01/23/08 original version

    % screen value of -1 (default) means use command window prompts
    % screen value of 0 means open a new screen
    % screen value > 0 uses that number screen pointer
    if nargin < 1, w = -1; end;
    if w == 0, w = Screen('OpenWindow', max(Screen('Screens'))); end
    
    %% joystick configuration
    try
        found_indices = GetGamepadIndices;
    catch
        fprintf('Error encountered with Gamepad. Function terminated.\n')
        return
    end
    
    joystick_count = length(found_indices);
    
    if joystick_count == 1
        ordered_indices = found_indices;
        report_one_found()
    elseif joystick_count == 2;
        ordered_indices(1) = prompt_for_joystick('left');
        ordered_indices(2) = prompt_for_joystick('right');
    else
        report_too_many_joysticks()
    end
    
    function report_one_found()
        prompt_text = sprintf('Only one joystick has been found and will be used. (index %d)', ordered_indices(1));
        if w
            display_instructions(w, {prompt_text 'Press any key to continue'});
        else
            fprintf([prompt_text '\n']);
        end        
    end

    function [j_index] = prompt_for_joystick(joystick_label)
        prompt_text = sprintf('Please click the trigger of the %s joystick', joystick_label);
        
        if w
            display_instructions(w, prompt_text, 'no wait')
        else
            fprintf([prompt_text '\n'])
        end
        
        % continually query each joystick for a button press
        button_is_down=0;
        while ~button_is_down
            for x = 1:joystick_count
                elements = PsychHID('Elements', found_indices(x));
                for element_number = 1:length(elements)
                    if elements(element_number).usagePageValue == 9 % a button
                        if PsychHID('RawState', device_index, element_number) > 0
                            button_is_down = 1;
                            j_index = found_indices(x);
                            break
                        end
                    end
                end
            end
        end
        
        if w
            Screen('Flip', w);
        end
cls
        
    end

end

