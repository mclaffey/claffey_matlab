function [varargout] = plot(e, varargin)
% Plots the data of trials within an emg_set   
%    
% FIGURE, if provided, is the handle to plot to
%
% CHANNEL_NAMES can be a cell array of DisplayNames to apply when plotting
%   each channel, which will appear in the legend. If left blank, it will
%   use the names from the emg_set. If 'none', no names will be applied.
%
% TRIAL_NAMES is same as CHANNEL_NAMES, except if left blank, the default
%   is 'trial 1', 'trial 2', 'trial 3'...
%
% CHANNEL_STYLES can be a cell array of LineSpecs, for example {'r:', 'b:', ...} 
%   If left blank, each channel is a different color, solid line
%
% SUBPLOT specified whether to plot each trial in a different subplot
%   (value of 'trials') or each channel ('channels'). If left blank all
%   channels and trials are plotted in one axes
%
% TIME determines whether or not trials with different time frames are either all
%   realigned to start at time zero (default value of 'aligned') or are
%   plotted in their original time frame ('original')
%
% SECTIONS is a cell array of sections that will have their start time
%   plotted in the graph
    
    
%% params

    p.channel_names = '';
    p.channel_styles = {'r:', 'b:', 'g;', 'y:', 'o:'};
    p.trial_names = '';
    p.subplot = '';
    p.sections = {};
    p.time = 'aligned';
    p.figure = [];
    p = paired_params(varargin, p);

%% error checking of parameters
    
    % channels
    channel_count = size(e,2);
    if isempty(p.channel_names), p.channel_names = e.channel_names; end;
    if strcmpi(p.channel_names, 'none'), p.channel_names = []; end;
    if ~isempty(p.channel_names) && length(p.channel_names) ~= channel_count,
        error('Number of channel names provided (%d) did not match number of channels (%d)', length(p.channel_names), channel_count);
    end
    if ~isempty(p.channel_styles) && length(p.channel_styles) < channel_count,
        error('Number of channel styles provided (%d) did not match number of channels (%d)', length(p.channel_styles), channel_count);
    end

    % trials
    trial_count = size(e,1);
    if isempty(p.trial_names), p.trial_names =  strcat({'trial '},num2str((1:trial_count)','%d')); end;
    if strcmpi(p.trial_names, 'none'), p.trial_names = []; end;
    if ~isempty(p.trial_names) && length(p.trial_names) ~= trial_count,
        error('Number of trial names provided (%d) did not match number of trials (%d)', length(p.trial_names), trial_count);
    end
    
    % sections
    if ~iscell(p.sections), p.sections = {p.sections}; end;
    section_count = length(p.sections);
    
%% select or create figure window
    
    leave_hold_on = false;
    
    % if a figure is specified, use it
    if ~isempty(p.figure)
        fig_handle = figure(p.figure);
        
    % if there is a current figure with a current aces that is not set to
    % hold, use that
    elseif ~isempty(get(0, 'CurrentFigure'))
        fig_handle = get(0, 'CurrentFigure');
        if isempty(get(fig_handle, 'CurrentAxes'))
            fig_handle = figure();
        else
            if ishold(get(fig_handle, 'CurrentAxes'))
                leave_hold_on = true;
            else
                fig_handle = figure();
            end;
        end
        
    % otherwise open a new figure
    else
        fig_handle = figure();
        axes('Parent', fig_handle);
    end
    
%% plot data

    % iterate through each trial and channel
    for trial = 1:trial_count
        
        if strcmpi(p.subplot, 'trials'), subplot(trial_count, 1, trial); end;
        
        for chan = 1:channel_count
            
            if strcmpi(p.subplot, 'channels'), subplot(channel_count, 1, chan); end;
        
            hold on
        
            % determine plot name
            if isempty(p.trial_names)
                if isempty(p.channel_names)
                    display_name = {};
                else
                    display_name = {'DisplayName', p.channel_names{chan}};
                end
            else
                if isempty(p.channel_names)
                    line_name = {'DisplayName', p.trial_names{trial}};
                else
                    line_name = {'DisplayName', sprintf('%s: %s', p.trial_names{trial}, p.channel_names{chan})};
                end
            end
            
            % determine plot style
            if isempty(p.channel_styles)
                plot_style = {};
            else
                plot_style = {p.channel_styles{chan}};
            end
            
            % get emg data
            emg_obj = e.data{trial, chan};
            if isempty(emg_obj), continue; end;
            
            % calculate value to realign the emg timebase, if specified
            switch p.time
                case 'aligned'
                    time_offset = emg_obj.time.start;
                    
                case 'original'
                    time_offset = 0;
                    
                otherwise
                    error('Unknown value for time argument: %s', p.time)
            end
            
            % plot emg data
            plot(emg_obj.time.base - time_offset, emg_obj.data, plot_style{:}, line_name{:});
            
            % plot sections
            for sect = 1:section_count
                if isempty(line_name)
                    sect_name = {'DisplayName', sprintf('%s (%d)', p.sections{sect}, trial)};
                else
                    sect_name = {'DisplayName', sprintf('%s (%s)', p.sections{sect}, line_name{2})};
                end
                try
                    plot_line(emg_obj.sections.(p.sections{sect}).time.start - time_offset, 'v', sect_name{:})
                catch
            end
            
            legend('show')

        end
    end
    
    if ~leave_hold_on
        hold(get(fig_handle, 'CurrentAxes'), 'off');
    end
    
%% return arguments if requested
    switch nargout
        case 0
            varargout = {};
        case 1
            varargout = {fig_handle};
        otherwise
            error('Wrong number of output arguments')
    end
    
end