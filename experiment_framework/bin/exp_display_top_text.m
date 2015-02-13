function exp_display_top_text(edata, varargin)

    assert(ischar(varargin{1}), 'Second argument must be a string');
    screen_text = sprintf(varargin{:});
    
    text_size = Screen('TextSize', edata.display.index);
    text_vertical_position = text_size * 2;
    
    DrawFormattedText(edata.display.index, screen_text, 'center', text_vertical_position, edata.display.colors.white);

end