function plot_emg_data(e, p)
% Plots the data signal and sections in a figure axis    
        
        x = e.time.base;
        y = e.data;

%% x zooming

        x_range = [];
        if p.zoom
            if ischar(p.zoom)
                try
                    x_range = [e.sections.(p.zoom).time.start - 0.1, e.sections.(p.zoom).time.end + 0.1];
                catch
                    warning('Zoom failed: section %s does not exist', p.zoom); %#ok<WNTAG>
                end
            elseif isnumeric(p.zoom) && length(p.zoom) == 1
                x_range = [p.zoom - 0.1, p.zoom + 0.1];

            elseif isnumeric(p.zoom) && length(p.zoom) == 2
                x_range = [p.zoom(1), p.zoom(2)];

            else
                error('bad zoom command')
            end
        end
    
%% plotting

        if p.is_new_figure, cla; end;
        hold('all');
        plot(x,y, 'DisplayName', 'Signal', 'Tag', 'Signal');

%% formatting, if in a new figure    
        if p.is_new_figure

            title('emg plot')
            xlabel('time')
            ylabel(sprintf('emg signal (%s)', e.tags.units));

            % y limits
            switch p.y_lim
                case 'auto'
                    y_lims = [-1.3 * max(e.data), 1.3 * max(e.data)];
                case ''
                    y_lims = [-emg_defaults('y_lim'), emg_defaults('y_lim')];
                otherwise
                    if ~isnumeric(p.y_lim) || length(p.y_lim(:)) > 2
                        error('y_lim value must be either auto, or a 1- or 2-element matric')
                    elseif length(p.y_lim) == 1
                        y_lims = [-p.y_lim, p.y_lim];
                    else
                        y_lims = [-p.y_lim(1), p.y_lim(2)];
                    end
            end
            ylim(y_lims);

            if ~isempty(x_range), xlim(x_range); end;

        end
    
%% sections
        y_lims = ylim;
        section_label_y = y_lims(1) + (.1 * diff(y_lims));

        if ~isempty(fieldnames(e.sections))
            section_names = fieldnames(e.sections);
            for x = 1:length(section_names)
                section = e.sections.(section_names{x});
                plot_args_section = {'Tag', sprintf('section_%s', section_names{x}), 'ButtonDownFcn', {@section_selected, 'start'}};
                plot_args_label = {'Tag', sprintf('label_%s', section_names{x}), 'ButtonDownFcn', {@section_selected, 'start'}};
                if section.time.duration == 0
                    % lines for 0-duration sections
                    plot_line(section.time.start, 'v', 'r', plot_args_section{:});
                    text('String', section_names{x}, 'Position', [section.time.start, section_label_y], 'HorizontalAlignment', 'center', plot_args_label{:});
                else
                    patch_x = [section.time.start section.time.start section.time.end section.time.end];
                    patch_y = [section.tags.metrics.min section.tags.metrics.max section.tags.metrics.max section.tags.metrics.min];
                    patch_y = patch_y + [diff(patch_y(1:2)).*-0.1 diff(patch_y(1:2)).*0.1 diff(patch_y(1:2)).*0.1 diff(patch_y(1:2)).*-0.1];
                    patch_color = [1 0 0];
                    patch(patch_x, patch_y, patch_color, 'FaceAlpha', .1, plot_args_section{:});
                    text('String', section_names{x}, 'Position', [section.time.start, section.tags.metrics.max*1.2], 'HorizontalAlignment', 'left', plot_args_label{:});
                end                
            end
        end
        
    if ~p.leave_hold_on
        hold(get(p.figure, 'CurrentAxes'), 'off');
    end

end