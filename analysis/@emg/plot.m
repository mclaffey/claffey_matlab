function [varargout] = plot(e, varargin)
% Plots the emg data with interactive features for editing the emg object   
%    
% Y_LIM can be either 'auto' to scale to the data, a single number for
%   symetrical limits, or a 2-element matric with [min, max] limits. If
%   nothing is provided, emg_default('y_lim') is used
%
% ZOOM can either be a section name or a specified time point
%
% FIGURE can specify an existing figure handle to plot into, using the
%   current axes
%
% VAR can be a variable to save to in the base workspace when changes are
%   made to the plot
%
% SAVE_CALLBACK can be a function to run whenever changes are made. The
%   first argument passed will be the updated emg object

% Copyright 2008-2011 Mike Claffey (mclaffey[]ucsd.edu)
%
% 02/15/11 fixed bugs with y_lims
% 08/03/09 fixed display of section names with underscores
% 09/02/08 fixed: Warning: line XData length (2) and YData length (4) must be equal.


%% error checking

    if isempty(e)
        error('An empty emg object was passed to emg/plot')
    end
        
%% params

    p.y_lims = '';    
    p.zoom = '';
    p.figure = [];
    p.save_var = inputname(1);
    p = paired_params(varargin, p);
    
%% select or create figure window
    
    p.leave_hold_on = false;
    p.is_new_figure = false;
    
    % if a figure is specified, use it
    if ~isempty(p.figure)
        figure(p.figure);
        
    % if there is a current figure with a current aces that is not set to
    % hold, use that
    elseif ~isempty(get(0, 'CurrentFigure'))
        p.figure = get(0, 'CurrentFigure');
        if isempty(get(p.figure, 'CurrentAxes'))
            p.is_new_figure = true;
        else
            if ishold(get(p.figure, 'CurrentAxes'))
                p.leave_hold_on = true;
            else
                p.is_new_figure = true;
            end;
        end
        
    % otherwise open a new figure
    else
        p.is_new_figure = true;
    end

    % create the figure and axes, if needed
    if p.is_new_figure
        p.figure = figure();
        p.h.ax = axes('Parent', p.figure);
    end


%% zoom control



%% data
        
    x = e.time.base;
    y = e.data;

%% determine x range to zoom to
    x_lims = [];
    if p.zoom
        if ischar(p.zoom)
            try
                x_lims = [e.sections.(p.zoom).time.start - 0.1, e.sections.(p.zoom).time.end + 0.2];
            catch
                warning('EMG:Zoom_section_missing', 'Zoom failed: section %s does not exist', p.zoom);
            end
        elseif isnumeric(p.zoom) && length(p.zoom) == 1
            x_lims = [p.zoom - 0.1, p.zoom + 0.1];

        elseif isnumeric(p.zoom) && length(p.zoom) == 2
            x_lims = [p.zoom(1), p.zoom(2)];

        else
            error('bad zoom command')
        end
    else
        x_lims = [e.time.start e.time.end];
    end

%% determine y limits

    if isempty(p.y_lims)
        y_lims = [-emg_defaults('y_lim'), emg_defaults('y_lim')];
        
    elseif ischar(p.y_lims) && strcmpi(p.y_lims, 'auto')
        y_lims = [-1.3 * max(e.data), 1.3 * max(e.data)];
        
    elseif isnumeric(p.y_lims)
        if length(p.y_lims) == 1
            y_lims = [-p.y_lims, p.y_lims];
        elseif length(p.y_lims) == 2
            y_lims = p.y_lims;
        else
            error('if y_lims is a matrix, it must have only 1 or 2 elements')
        end
    else
        error('y_lims value must be either auto, or a 1- or 2-element matric')
    end    
    
%% plotting

    hold('all');
    plot(x,y, 'DisplayName', 'Signal', 'Tag', 'Signal');
    
    if ~isempty(x_lims), xlim(x_lims); end;
    if ~isempty(y_lims), ylim(y_lims); end;

    if p.is_new_figure
        title('emg plot')
        xlabel('time')
        ylabel(sprintf('emg signal (%s)', e.tags.units));
    end
    
%% sections
    y_lims = ylim;
    section_label_y = y_lims(1) + (.1 * diff(y_lims));

    if ~isempty(fieldnames(e.sections))
        section_names = fieldnames(e.sections);
        % escape underscore characters, otherwise matlab subscripts the next character
        section_labels = cellfun_easy(@strrep, section_names, '_', '\_');        
        for x = 1:length(section_names)
            section = e.sections.(section_names{x});
            plot_args_section = {'Tag', sprintf('section_%s', section_names{x}), 'ButtonDownFcn', {@section_selected, 'start'}};
            %plot_args_label = {'Tag', sprintf('label_%s', section_names{x}), 'ButtonDownFcn', {@section_selected, 'start'}};
            plot_args_label = {'Tag', sprintf('label_%s', section_names{x})};
            if section.time.duration == 0
                % lines for 0-duration sections
                text('String', section_labels{x}, 'Position', [section.time.start, section_label_y], 'HorizontalAlignment', 'center', plot_args_label{:});
                plot_line(section.time.start, 'v', 'r', plot_args_section{:});
            else
                text('String', section_labels{x}, 'Position', [section.time.start, section.tags.metrics.max*1.2], 'HorizontalAlignment', 'left', plot_args_label{:});
                [patch_x, patch_y, patch_color] = calc_patch_arguments(section);
                patch(patch_x, patch_y, patch_color, 'FaceAlpha', .1, plot_args_section{:});
            end                
        end
    end

    if ~p.leave_hold_on
        hold(get(p.figure, 'CurrentAxes'), 'off');
    end

%% return arguments if requested
    switch nargout
        case 0
            varargout = {};
        case 1
            varargout = {p.figure};
        case 2
            varargout = {p.figure, p};
        otherwise
            error('Wrong number of output arguments')
    end

%% ----------------------------------------------------------------------
%   Callback and helper functions
%  ----------------------------------------------------------------------

%% callback functions

    function section_selected(src, eventdata, move_mode, params) %#ok<INUSL>
        
        cur_pt = get(gca, 'CurrentPoint');
        
        switch move_mode
            case 'start'
                params.origin = cur_pt(1,1);
                params.section_h = src;
                params.section_tag = get(params.section_h, 'Tag');
                params.section_name = params.section_tag(9:end);
                params.old_x = get(params.section_h, 'XData');
                params.section_width = max(diff(params.old_x));
                params.label_tag = sprintf('label_%s', params.section_name);
                params.label_h = findobj('Tag', params.label_tag);
                params.label_old_position = get(params.label_h, 'Position');
                if iscell(params.label_old_position)
                    params.label_old_position = params.label_old_position{1};
                end
                
                % determine which part of the section to move based on click
                % location
                if params.section_width == 0
                    params.move_mode = 'move_all';
                elseif cur_pt(1) < (params.old_x(1) + params.section_width * .1)
                    params.move_mode = 'move_left_edge';
                elseif cur_pt(1) > (params.old_x(3) - params.section_width * .1)
                    params.move_mode = 'move_right_edge';
                else
                    params.move_mode = 'move_all';
                end

                set(params.section_h, 'Selected', 'on');
                set(gcbf, 'WindowButtonMotionFcn', {@section_selected, params.move_mode, params})
                set(gcbf, 'WindowButtonUpFcn', {@section_selected, 'stop', params})
                set(gcbf, 'CurrentCharacter', ' ');

            case 'move_all'
                x_offset = cur_pt(1,1) - params.origin(1);
                new_x = params.old_x + x_offset;
                set(params.section_h, 'XData', new_x);
                set(params.label_h, 'Position', params.label_old_position + [x_offset 0 0]);
                
            case 'move_left_edge'
                x_offset = cur_pt(1) - params.origin(1);
                new_x = params.old_x + [x_offset x_offset 0 0]';
                set(params.section_h, 'XData', new_x);
                set(params.label_h, 'Position', params.label_old_position + [x_offset 0 0]);
                
            case 'move_right_edge'
                x_offset = cur_pt(1) - params.origin(1);
                new_x = params.old_x + [0 0 x_offset x_offset]';
                set(params.section_h, 'XData', new_x);
                
            case 'stop'
                set(params.section_h, 'Selected', 'off');
                set(gcbf, 'WindowButtonMotionFcn', '')
                set(gcbf, 'WindowButtonUpFcn', '')
                
                params.new_x = get(params.section_h, 'XData');
                [section] = update_section(params, p);
                [patch_x, patch_y, patch_color] = calc_patch_arguments(section);
                set(params.section_h, 'YData', patch_y);
                
            otherwise
                error('Unknown section_selected mode')
        end
    end

%% update after section has changed
    
    function [section] = update_section(params, p)
        if isempty(p.save_var), return; end;
        
        e = evalin('base', p.save_var);

        % switch to parenthesis form for reporting changes
        if strfind(p.save_var, '{')
            p.save_var = strrep(p.save_var, '{', '(');
            p.save_var = strrep(p.save_var, '}', ')');
        end

        if params.section_width == 0
            e = shift_section_time(e, params.section_name, 'START', params.new_x(1));
            fprintf('%s.sections.%s = %f\n', p.save_var, params.section_name, params.new_x(1));
         else
            e = shift_section_time(e, params.section_name, 'LIMITS', params.new_x([1 3]));
            fprintf('%s.sections.%s = [%f %f]\n', p.save_var, params.section_name, params.new_x(1), params.new_x(3));
        end

        %
        
        assignin('base', 'temp_emg_plot_variable', e);
        evalin('base', sprintf('%s = temp_emg_plot_variable;', p.save_var));
        evalin('base', 'clear temp_emg_plot_variable');
        
        section = e.sections.(params.section_name);
        
    end

    function [patch_x, patch_y, patch_color] = calc_patch_arguments(section)
        if section.time.duration == 0
            patch_x = [section.time.start section.time.start];
            patch_y = get(gca,'YLim');
        else
            patch_x = [section.time.start section.time.start section.time.end section.time.end];
            patch_y = [section.tags.metrics.min section.tags.metrics.max section.tags.metrics.max section.tags.metrics.min];
            patch_y = patch_y + [diff(patch_y(1:2)).*-0.1 diff(patch_y(1:2)).*0.1 diff(patch_y(1:2)).*0.1 diff(patch_y(1:2)).*-0.1];
        end
        patch_color = [1 0 0];
    end
    
end