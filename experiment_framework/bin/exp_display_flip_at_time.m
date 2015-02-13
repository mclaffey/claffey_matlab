function exp_display_flip_at_time(edata, flip_time)
    
    Screen('Flip', edata.display.index, flip_time);
    wait_until(flip_time);
    
end
