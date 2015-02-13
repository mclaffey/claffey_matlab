function [gf] = graph_formatter(a)
% Use a single structure of paramters to format graphs
%
%   [gf] = graph_formatter()
%
%       When called without any arguments, it returns the default structure.
%
%   [gf] = graph_formatter(gf)
%
%       To format a graph, pass graph_formatter structure gf with the same fields as in the default
%       structure, but with any new values that should override the defaults.
%
%   [gf] = graph_formatter('build')
%
%       Provides interactive prompts for all possible values and then creates the matlab code
%       to configure an appropriate structure
%

% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 08/12/09 added gf=struct() & graph_formatter(gf) to build output
% 07/30/09 created interactive build mode
% 05/05/09 added tiny font size
% 04/14/09 moved figure/axis sizing to end to improve adherence to specifications
% 04/09/09 legend
% 04/01/09 major clean-up
% 03/01/09 original version
    
%% create default structure

    % handles
    gf.fig_handle = [];
    gf.axis_handle = [];
    gf.legend_handle = [];

    % size & location
    gf.fig_dimensions_inches = [4 4];
    gf.origin_on_screen_in_points = [];
    gf.units = [];

    % axis size/position relative to figure
    gf.axis_margins = [];
    gf.axis_position = [];

    % axis properties
    gf.title = '';
    gf.bg_color = [1 1 1];
    gf.colormap = 'bone';
    gf.box = 'off';

    % x axis
    gf.x_label = '';
    gf.x_lim = [];
    gf.x_increment = [];
    gf.x_ticks = [];
    gf.x_tick_labels = [];
    gf.x_tick_decimals = [];

    % y axis
    gf.y_label = '';
    gf.y_lim = [];
    gf.y_increment = [];
    gf.y_ticks = [];
    gf.y_tick_labels = [];
    gf.y_tick_decimals = [];

    % font
    gf.font_name = 'Helvetica';
    gf.font_size.title = 24;
    gf.font_size.general = 14;
    gf.font_size.x_label = 18;
    gf.font_size.y_label = 18;
    gf.font_size.legend = 14;

    
    % legend
    gf.legend_text = {};
    gf.legend_location = '';
    
%% if no argument was passed, return the default structure 
    if ~exist('a', 'var'), return; end
    
%% if the interactive build argument was passed, do that

    if ischar(a)
        
        assert(strcmpi('build', a), 'The only string argument accepted is ''build''');

        % open a temp file
        temp_file_name = [tempname '.m'];
        fid = fopen(temp_file_name, 'w');
        if fid < 0, error('Could not open temp file for writing'); end;
        
        % prompt for the variable name
        gf_var_name = input('What do you want the variable name to be? (ENTER for gf): ', 's');
        if isempty(gf_var_name), gf_var_name = 'gf'; end;
        fprintf(fid, '\t %s = struct();\n', gf_var_name);

        % prompt for a value for each field
        field_list = fieldnames(gf);
        for x = 1:length(field_list)
            field_answer = input(sprintf('%s (default is %s) = ', field_list{x}, any2str(gf.(field_list{x}))), 's');
            if ~isempty(field_answer)
                if strcmpi(field_answer, 'exit'), break; end;
                % if the answer doesn't evaluate to a valid matlab expression, wrap it in quotes
                try
                    evalc(field_answer);
                catch
                    field_answer = ['''' field_answer '''']; %#ok<AGROW>
                end

                fprintf(fid, '\t %s.%s = %s;\n', gf_var_name, field_list{x}, field_answer);
            end        
        end

        % finish writing file and open
        fprintf(fid, '\t graph_formatter(%s);\n', gf_var_name);
        fclose(fid);
        edit(temp_file_name);

        return
    end
    
%% if an argument was passed, combine it with the default structure    

    % report any unrecognized fields
    passed_fields = fieldnames(a);
    recognized_fields = fieldnames(gf);
    unrecognized_fields = setdiff(passed_fields, recognized_fields);
    if ~isempty(unrecognized_fields)
        warning('graph_formatter:invalid_fields', 'The following fields in the argument were not recognized')
        disp(unrecognized_fields);
    end
        
    % concatenate the argument with the default, with the argument values taking precedence
    warning('off', 'catstruct:DuplicatesFound');
    gf = catstruct(gf, a);

    
%% Figure out handles
    % if neither a figure or axis handles were passed, use the current
    if isempty(gf.fig_handle) && isempty(gf.axis_handle)
        gf.fig_handle = gcf;
        gf.axis_handle = get(gf.fig_handle, 'CurrentAxes');
    elseif isempty(gf.axis_handle) && ~isempty(gf.fig_handle)
        gf.axis_handle = get(gf.fig_handle, 'CurrentAxes');
    end
    assert(~isempty(axescheck(gf.axis_handle)), 'Invalid axes handle');
    if isempty(gf.fig_handle)    
        gf.fig_hanel = get(gf.axis_handle, 'Parent');
    end
    
%% units

    if isempty(gf.units)
        gf.units = get(gf.fig_handle, 'Units');
    end
    
%% font size

    font_sizes_by_word();
    if ~isempty(gf.font_size.general),     set(gf.axis_handle, 'FontSize', gf.font_size.general);              end;
    % axis and title font size are set if/when the text is inserted (below)
    
%% axis properties
    if ~isempty(gf.bg_color),      set(gf.fig_handle, 'Color', gf.bg_color);                end;
    if ~isempty(gf.title),         title(gf.axis_handle, gf.title, 'FontSize', gf.font_size.title); end;
    if ~isempty(gf.colormap),      colormap(gf.colormap);                       end;
    if ~isempty(gf.box),            set(gf.axis_handle, 'box', gf.box);                       end;
    
%% y properties
    if ~isempty(gf.y_label),       ylabel(gf.axis_handle, gf.y_label, 'FontSize', gf.font_size.y_label);                  end;
    if ~isempty(gf.y_lim),         ylim(gf.axis_handle, gf.y_lim);                          end;
    if ~isempty(gf.y_increment)
        gf.y_lim = get(gf.axis_handle, 'ylim');
        gf.y_ticks = gf.y_lim(1):gf.y_increment:gf.y_lim(2);
    end
    if ~isempty(gf.y_ticks)
        set(gf.axis_handle, 'YTick', gf.y_ticks)
    else
        gf.y_ticks = get(gf.axis_handle, 'YTick');
    end
    if ~isempty(gf.y_tick_decimals)
        gf.y_tick_labels = cellfun_easy(@sprintf, sprintf('%%1.%df', gf.y_tick_decimals), gf.y_ticks);
    end
    if ~isempty(gf.y_tick_labels), set(gf.axis_handle, 'YTickLabel', gf.y_tick_labels);    end;

%% x properties
    if ~isempty(gf.x_label),       xlabel(gf.axis_handle, gf.x_label, 'FontSize', gf.font_size.x_label);                  end;
    if ~isempty(gf.x_lim),         xlim(gf.axis_handle, gf.x_lim);                          end;
    if ~isempty(gf.x_increment)
        gf.x_lim = get(gf.axis_handle, 'xlim');
        gf.x_ticks = gf.x_lim(1):gf.x_increment:gf.x_lim(2);
    end
    if ~isempty(gf.x_ticks)
        set(gf.axis_handle, 'XTick', gf.x_ticks);
    else
        gf.x_ticks = get(gf.axis_handle, 'XTick');
    end;
    if ~isempty(gf.x_tick_decimals)
        gf.x_tick_labels = cellfun_easy(@sprintf, sprintf('%%1.%df', gf.x_tick_decimals), gf.x_ticks);
    end
    if ~isempty(gf.x_tick_labels), set(gf.axis_handle, 'XTickLabel', gf.x_tick_labels);    end;

%% legend

    % if the legend text is specified, create the legend
    if ~isempty(gf.legend_text) || ~isempty(gf.legend_location)
        gf.legend_handle = legend(gf.legend_text);
    else
        % otherwise, see if we can grab an existing legend
        gf.legend_handle = legend(gf.axis_handle);
        
    end

    % if the arguments say to turn off the legend, do so
    if strcmpi(gf.legend_location, 'off')
        legend('off')
        
    % otherwise, if there is a legend, format it
    elseif ~isempty(gf.legend_handle)
        if ~isempty(gf.legend_location)
            set(gf.legend_handle, 'Location', gf.legend_location);
        end
        if ~isempty(gf.font_size.legend)
            set(gf.legend_handle, 'FontSize', gf.font_size.legend);
        end
    end
            
%% figure size
    
    if ~isempty(gf.fig_dimensions_inches)
        set(gf.fig_handle, 'WindowStyle', 'normal');
        set(gf.fig_handle, 'Units', 'inches');
        fig_position = get(gf.fig_handle, 'Position');
        if ~isempty(gf.fig_dimensions_inches(1)), fig_position(3) = gf.fig_dimensions_inches(1); end;
        if ~isempty(gf.fig_dimensions_inches(2)), fig_position(4) = gf.fig_dimensions_inches(2); end;
        drawnow; % this has to be called for the subsequent set-position command to have an effect
        set(gf.fig_handle, 'Position', fig_position);
        
        % set the paper dimensions to be the same as the dimensions show on the screen
        set(gf.fig_handle, 'PaperPositionMode', 'auto');
    end


%% figure position on screen
    if ~isempty(gf.origin_on_screen_in_points)
        set(gf.fig_handle, 'WindowStyle', 'normal');
        set(gf.fig_handle, 'Units', 'points');
        fig_position = get(gf.fig_handle, 'Position');
        fig_position(1:2) = gf.origin_on_screen_in_points;
        set(gf.fig_handle, 'Position', fig_position);
    end

%% axis position

    if ~isempty(gf.axis_margins)
        set(gf.fig_handle, 'Units', 'normalized');
        gf.axis_position(1) = gf.axis_margins(1);
        gf.axis_position(2) = gf.axis_margins(2);
        gf.axis_position(3) = 1 - gf.axis_margins(1) - gf.axis_margins(3);
        gf.axis_position(4) = 1 - gf.axis_margins(2) - gf.axis_margins(4);
    end
    if ~isempty(gf.axis_position)
        set(gf.axis_handle, 'Position', gf.axis_position)
    end;

%% units

    set(gf.fig_handle, 'Units', gf.units);
    
%% helper function to determine font sizes

    function font_sizes_by_word
        if ischar(gf.font_size)
            warning('off', 'MATLAB:warn_r14_stucture_assignment');
            switch gf.font_size
                case {'tiny', 't'}
                    gf.font_size.title = 8;
                    gf.font_size.general = 8;
                    gf.font_size.x_label = 8;
                    gf.font_size.y_label = 8;
                    gf.font_size.legend = 8;
                case {'small', 's'}
                    gf.font_size.title = 12;
                    gf.font_size.general = 10;
                    gf.font_size.x_label = 12;
                    gf.font_size.y_label = 12;
                    gf.font_size.legend = 10;
                case {'medium', 'med', 'm'}
                    gf.font_size.title = 24;
                    gf.font_size.general = 14;
                    gf.font_size.x_label = 18;
                    gf.font_size.y_label = 18;
                    gf.font_size.legend = 14;
                case {'large', 'l'}
                    gf.font_size.title = 36;
                    gf.font_size.general = 18;
                    gf.font_size.x_label = 24;
                    gf.font_size.y_label = 24;
                    gf.font_size.legend = 18;
                otherwise
                    error('Unrecognized font size %s (use small/medium/large)', gf.font_size)
            end
        end
    end
        
end