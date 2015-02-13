function [exp, trial_data] = stop1_block_interim_rest(exp, trial_data, w)
%STOP1_BLOCK_INTERIM_REST Provide a rest to subject (press spacebar to continue)

    stop1_draw_background(exp, w);
    DrawFormattedText(w, exp.language.rest_text, 'center', 'center')
    Screen('Flip',w);

    % wait for keypress
    get_key_press(exp.keyboard.main_keyboard_index, 0, {'space'}, true)
    Screen('Flip',w);

end
