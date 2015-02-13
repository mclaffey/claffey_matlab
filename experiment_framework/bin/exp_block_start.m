function [edata, trial_data] = exp_block_start(edata, trial_data)
% If at the beginning of the block, perform specified functions

    if ~is_new_block(), return; end;
    
%% Perform these actions at the beginning of the block    

    current_block = trial_data.block(edata.current_trial);

    exp_display_centered_text(edata, 'Starting block %d\n\n(press space bar to begin)', current_block);
    Screen('Flip', edata.display.index);

    % wait for keypress
    get_key_press(edata.inputs.main_keyboard_index, 0, {'space'}, true)
    Screen('Flip', edata.display.index);

%% helper function (PROBABLY DO NOT NEED TO MODIFY THIS CODE)

    function [is_new] = is_new_block()

        % if there isn't a block column in trial_data, return
        if edata.current_trial == 1
            is_new = true;
        elseif ~ismember('block', get(trial_data, 'VarNames'))
            is_new = false;
        elseif trial_data.block(edata.current_trial) ~= trial_data.block(edata.current_trial-1)
            is_new = true;
        else
            is_new = false;
        end
    end
    
end
