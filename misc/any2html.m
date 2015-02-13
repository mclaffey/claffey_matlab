function [html] = any2html(a)
% Display any variable as html

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/10/09 original version

    html = '';
    
    switch class(a)
        case 'numeric'
            html_write('<p>%s<p>', mat2str(a));
        case 'char'
            html_write('<p>%s<p>', a);
        case 'dataset'
            html_write(dataset_html_display(a));
        case 'cell'
            html_write(cell2html(a));
        case 'struct'
            html_write('<table border=1 cellspacing=0 cellpadding=5><tr><th>Field</th><th>Value</th></tr>');
            field_names = fieldnames(a);
            for x = 1:length(field_names)
                html_write('<tr><td align=right>%s</td>', field_names{x});
                html_write('<td align=left>%s</td></tr>', any2html(a.(field_names{x})));
            end
        otherwise
            html_write('<p>%s?</p>', class(a));
    end
                
    function html_write(varargin)
        html = [html, sprintf(varargin{:})];
    end
end