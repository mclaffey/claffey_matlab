function stop1_display_go_stimuli(edata, td)
        
    old_font_size = Screen('TextSize', edata.display.index, 96);
    
    if td.direction == 'left' %#ok<STCMP>
        exp_display_centered_text(edata, '<   ');
    else
        exp_display_centered_text(edata, '   >');
    end
        
    Screen('TextSize', edata.display.index, old_font_size);
    
end