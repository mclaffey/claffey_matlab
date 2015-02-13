function draw_statsig_star_bracket(figure1, coords)
    
    [x1, y1, x2, y2] = deal(coords);
    width = x2-x1;
    height = y2-y1;
    star_x1 = x1 + 0.4 * width;
    star_x2 = x1 + 0.6 * width;    
    
    % draw left side
    annotation(figure1, 'line', [x1 x1],[y1 y2]);
    annotation(figure1, 'line', [x1 star_x1], [y2, y2]);

    % draw right side
    annotation(figure1, 'line', [star_x2 x2], [y2, y2]);
    annotation(figure1, 'line', [x2 x2], [y2, y1]);

    % Create textbox
    annotation(figure1, ...
        'textbox','String',{'*'},...
        'Margin',0,...
        'HorizontalAlignment','center',...
        'FontSize',48,...
        'FitHeightToText','off',...
        'LineStyle','none',...
        'Position',[star_x1 0.4765 0.7917 0.06851 0.08565]);
