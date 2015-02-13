function [edata, trial_data] = exp_block_feedback(edata, trial_data)
% Display feedback graphs for block
    
%% If there isn't an active screen, create one

    [edata] = exp_display_start(edata);
    
%% annoying PC bug fix

    % I have not been able to resolve a bug on PCs that after the first Screen('Flip')
    % command, the get_key_press function blanks the screen. The cludgey fix is to flip a blank
    % screen, do a meaningless get_key_press, and then all subsequent screens will display ok
    % (mike c. 03-02-09)
    if ispc
        Screen('Flip', edata.display.index);
        get_key_press(edata.inputs.main_keyboard_index, -1, {'space'}, false);
        Screen('Flip', edata.display.index);
    end
    
%% display message while graph is being generated

    Screen('TextSize', edata.display.index, 36);
    exp_display_centered_text(edata, 'Generating feedback graph...');
    Screen('Flip', edata.display.index);

%% open a figure

    if edata.run_mode.debug
        f_handle = figure('Visible','on');
    else
        % it is faster to create figures that are not visible
        f_handle = figure('Visible','off');
    end

%% calculate block stats and plot

    edata = exp_analysis_blocks(edata, trial_data);
    edata = exp_analysis_blocks_plot(edata, trial_data);
    % display calculated stats in the command window
    disp(edata.analysis.block_stats);

%% display subject graph on screen

    exp_display_black_background(edata);
    figure_to_ptb_screen(f_handle, edata.display.index);
    close(f_handle);
    DrawFormattedText(edata.display.index, 'press SPACE BAR to advance', 'center');
    Screen('Flip',edata.display.index);

    % wait for keypress
    get_key_press(edata.inputs.main_keyboard_index, 0, {'space'}, true);
    Screen('Flip', edata.display.index);
        
end
