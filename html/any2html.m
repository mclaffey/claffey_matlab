function [html] = any2html(a, size_limit)
% Display any variable as html
%
%   [html] = any2html(a, size_limit)
%
% See-also: webc

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/26/10 fixed error with logicals of more than one element
% 07/30/09 now throws any unrecognized classes to any2str
% 06/02/09 structures now show each element
% 05/29/09 added size_limit
% 04/16/09 display using temp file if no output arguments
% 04/10/09 original version

%% Check size limit

    if ~exist('size_limit', 'var'), size_limit = 20; end;

    html = '';
    
    switch class(a)
        case 'double'
            html_write('<p>%s</p>', any2str(a));
        case 'logical'
            html_write('<p>%s</p>', any2str(a));
        case 'char'
            a = strrep(a, sprintf('\n'), '</p><p>');
            html_write('<p>%s</p>', a);
        case 'dataset'
            html_write(dataset_html_display(a, size_limit));
        case 'cell'
            html_write(cell2html(a));
        case 'struct'
            field_names = fieldnames(a);
            for z = 1:length(a)
                html_write(sprintf('<p>Item %d of structure</p>', z));
                html_write('<table border=1 cellspacing=0 cellpadding=5><tr><th>Field</th><th>Value</th></tr>');
                for x = 1:length(field_names)
                    html_write('<tr><td align=right>%s</td>', field_names{x});
                    html_write('<td align=left valign=center>%s</td></tr>', any2html(a(z).(field_names{x}), size_limit));
                end
                html_write('</table>');
            end
        otherwise
            html_write('<p>%s</p>', any2str(a));
    end
        
%% if no output is requested, display the results in a web browser
    if nargout == 0
        webc(html);
    end

%% helper function                
    function html_write(varargin)
        html = [html, sprintf(varargin{:})];
    end
end