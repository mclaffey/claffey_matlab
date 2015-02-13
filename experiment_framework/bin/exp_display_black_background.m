function exp_display_black_background(edata)
% Draw black background

    Screen('FillRect', edata.display.index, edata.display.colors.black)
    
    % Note that this does not include a Flip command, so other elements can be drawn on top

end