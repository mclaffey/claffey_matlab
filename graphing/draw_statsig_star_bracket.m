function [handles] = draw_statsig_star_bracket(figure1, coords, bracket_text)
% Draw a stat sig bracket on a graph using graph coordinates
%
% [handles] = draw_statsig_star_bracket(figure1, coords, [bracket_text])

% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 03/18/09 original version
    
    if ~exist('bracket_text', 'var') || isempty(bracket_text), bracket_text = '*'; end;
    line_properties = {'LineWidth', 2, 'Color', 'k'};
    font_size = 48;
    font_vertical_displacement = 6;
    if strcmpi(bracket_text, 'n.s.')
        font_size = 16;
        font_vertical_displacement = 40;
    end;

%% determine the coordinates of the bracket

    x1 = coords(1);
    y1 = coords(2);
    x2 = coords(3);
    y2 = coords(4);
    width = x2-x1;
    height = y2-y1;   
    
%% Create and position textbox
    handles.text = text(x1, y1, bracket_text, 'FontSize', font_size, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    text_extent = get(handles.text, 'Extent');
    text_width = text_extent(3) * 1.3;
    text_height = text_extent(4);
    text_x = mean([x1, x2]);
    text_left = text_x - (text_width / 2);
    text_right = text_x + (text_width / 2);
    text_y = y2 - (text_height / font_vertical_displacement);
    set(handles.text, 'Position', [text_x, text_y, 0]);

%% draw left side
    handles.left_vert = line([x1 x1],[y1 y2], line_properties{:});
    handles.left_horz = line([x1 text_left], [y2 y2], line_properties{:});

%% draw right side
    handles.right_vert = line([x2 x2], [y1, y2], line_properties{:});
    handles.right_horz = line([text_right x2], [y2, y2], line_properties{:});

end