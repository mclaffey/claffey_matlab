function exp_display_centered_arrow(edata, direction)
% Draw a centerd arrow pointing to left or right
%
%   exp_display_centered_arrow(edata, 'left')
%   exp_display_centered_arrow(edata, 'right')

% 11/05/09 original version

    % use a big font
    old_font_size = Screen(edata.display.index, 'TextSize', 72);

    % draw the arrrow
    if strcmpi(direction, 'left')
        exp_display_centered_text(edata, '<');
    elseif strcmpi(direction, 'right')
        exp_display_centered_text(edata, '>');
    else
        try, cls; end;
        error('Unrecognized direction %s', direction);
    end
    
    % reset the font size
    Screen(edata.display.index, 'TextSize', old_font_size);
    
end
