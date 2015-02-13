function [html] = cell2html(a, include_table_tag, first_row_as_heading, abbreviated_version)
% Produce html to dispay a cell

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/10/09 original version

    if ~exist('include_table_tag', 'var'), include_table_tag = true; end;
    if ~exist('first_row_as_heading', 'var'), first_row_as_heading = false; end;
    
    if include_table_tag
        %html = '<table cellpadding="4" cellspacing="0" border="1">';
        html = '<table>';
    else
        html = '';
    end
    
    for row = 1:size(a,1)
        html = [html, '<tr>']; %#ok<AGROW>
        if first_row_as_heading && row==1
            tag = 'th';
        else
            tag = 'td';
        end
            
        for col = 1:size(a,2)
            html = [html, sprintf('<%s>%s</%s>', tag, any2str(a{row, col}), tag)]; %#ok<AGROW>
        end
        html = [html, '</tr>']; %#ok<AGROW>
    end
    html = [html, '</table>'];
    
%% if there are any % in the text, escape them properly
    html = strrep(html, '%', '%%');

    
end