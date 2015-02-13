function format_graph(ax_h, the_title, x_label, x_lim, x_ticks, x_tick_labels, y_label, y_lim, y_ticks, y_tick_labels)
% Set the main properties of an axis with a single command
%
% format_graph(ax_h, the_title, x_label, x_lim, x_ticks, x_tick_labels, y_label, y_lim, y_ticks, y_tick_labels)

    % axis title
    if ~isempty(the_title),     title(ax_h, the_title);                     end;
    
    % y axis
    if ~isempty(y_label),       ylabel(ax_h, y_label);                      end;
    if ~isempty(y_lim),         ylim(ax_h, y_lim);                          end;
    if ~isempty(y_ticks);       set(ax_h, 'YTick', y_ticks);                end;
    if ~isempty(y_tick_labels), set(ax_h, 'YTickLabels', y_tick_labels);    end;
    
    % x axis
    if ~isempty(x_label),       xlabel(ax_h, x_label);                      end;
    if ~isempty(x_lim),         xlim(ax_h, x_lim);                          end;
    if ~isempty(x_ticks);       set(ax_h, 'XTick', x_ticks);                end;
    if ~isempty(x_tick_labels), set(ax_h, 'XTickLabels', x_tick_labels);    end;
        
end