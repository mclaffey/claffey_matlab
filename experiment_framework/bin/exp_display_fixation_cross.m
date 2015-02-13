function exp_display_fixation(edata)
   exp_display_centered_text(edata, '+');
   Screen('Flip', edata.display.index);
end