function review(e, trial_list, channel_list, varargin)
% Manually plot and manipulate each trial in an emg_set
%
% review(E [, TRIAL_LIST, CHANNEL_LIST, VARARGIN])

% Copyright 2008-2011 Mike Claffey (mclaffey [] ucsd.edu)
%
% 02/15/11 allow specifiction of y limits (text boxes still need labeling)
% 12/12/08 add, delete section buttons
% 11/20/08 add mep button, more shortcuts
% 10/05/08 keyboard shortcuts
% 09/17/08 added command line feedback for validity changes
% 09/05/08 sorted trial filter variable

%% error checking

    % check e
    if isempty(e)
        error('An empty emg_set object was passed to emg/plot')
    elseif isempty(inputname(1));
        error('Can not pass an expression')
    end
    
    % check the trial numbers
    if ~exist('trial_list', 'var') || isempty(trial_list)
        trial_list = 1:size(e,1);
    elseif ~isnumeric(trial_list)
        error('TRIAL_LIST should be a numeric matrix or empty')
    elseif any(setdiff(trial_list, 1:size(e,1)))
        error('TRIAL_LIST contained trial numbers that do not exist in E')
    end
    
    % check the channel list
    if ~exist('channel_list', 'var') || isempty(channel_list)
        channel_list = e.channel_names;
    end
    if isnumeric(channel_list)
        channel_list = e.channel_names(channel_list);
    end
    
%% gather data

    emg_rev.var_name = inputname(1);
    emg_rev.zoom = '';
    emg_rev.trial_list = trial_list;
    emg_rev.curr_trial = emg_rev.trial_list(1);
    emg_rev.channel_list = channel_list;
    emg_rev.curr_channel = emg_rev.channel_list{1};
    emg_rev.y_lim = [-1 1]; % default
    
%% create figure and ui elements

    emg_rev.figure = figure('ResizeFcn', @resize_fcn, 'KeyPressFcn', @key_press_fcn);
    emg_rev.ax = axes('Parent', emg_rev.figure);
                        
    emg_rev.left_panel = uipanel(...
        'Parent', emg_rev.figure,...
        'BorderType', 'line', ...
        'Tag','left_panel');

    emg_rev.axes = axes(...
        'Parent', emg_rev.left_panel,...
        'Position', [.1 .1 .88 .8],...
        'Tag', 'plot_axes');

    emg_rev.y_min = uicontrol(...
        'Parent', emg_rev.left_panel,...
        'BackgroundColor',[1 1 1],...
        'Callback', {@emg_review_callback, 'y_lim'}, ...
        'String','-1',...
        'Style','edit',...
        'Tag','y_min_edit');

    emg_rev.y_max = uicontrol(...
        'Parent', emg_rev.left_panel,...
        'BackgroundColor',[1 1 1],...
        'Callback', {@emg_review_callback, 'y_lim'}, ...
        'String','1',...
        'Style','edit',...
        'Tag','y_max_edit');

    emg_rev.right_panel = uipanel(...
        'Parent', emg_rev.figure,...
        'BorderType', 'line', ...
        'Tag','right_panel');

    emg_rev.prev_trial_btn = uicontrol(...
        'Parent',emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'prev'}, ...
        'String','<',...
        'Tag','prev_trial_btn');

    emg_rev.next_trial_btn = uicontrol(...
        'Parent',emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'next'}, ...
        'String','>',...
        'Tag','next_trial_btn');

    emg_rev.trial_num_edit = uicontrol(...
        'Parent', emg_rev.right_panel,...
        'BackgroundColor',[1 1 1],...
        'Callback', {@emg_review_callback, 'jump'}, ...
        'String','1',...
        'Style','edit',...
        'Tag','trial_num_edit');

    emg_rev.trial_list_edit = uicontrol(...
        'Parent', emg_rev.right_panel,...
        'BackgroundColor',[1 1 1],...
        'Callback', {@emg_review_callback, 'trial_list'}, ...
        'String','',...
        'Style','edit',...
        'Tag','trial_list_edit');

    emg_rev.channel_listbox = uicontrol(...
        'Parent', emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'channel'}, ...
        'String', {},...
        'Style','listbox',...
        'Tag','channel_listbox');

    emg_rev.zoom_listbox = uicontrol(...
        'Parent', emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'zoom'}, ...
        'String', {},...
        'Style','listbox',...
        'Tag','section_listbox');
        
    emg_rev.valid_checkbox = uicontrol(...
        'Parent', emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'validity'}, ...
        'String', 'Is Valid',...
        'Style','checkbox',...
        'Tag','valid_checkbox');
    
    emg_rev.add_mep_btn = uicontrol(...
        'Parent',emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'add_mep'}, ...
        'String','Add MEP',...
        'Tag','add_mep_btn');

    emg_rev.add_section_btn = uicontrol(...
        'Parent',emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'add_section'}, ...
        'String','Add Section',...
        'Tag','add_section_btn');

    emg_rev.delete_section_btn = uicontrol(...
        'Parent',emg_rev.right_panel,...
        'Callback', {@emg_review_callback, 'delete_section'}, ...
        'String','Del Section',...
        'Tag','delete_section_btn');


    
    % save figure data
    guidata(emg_rev.figure, emg_rev);
        
%% Resize function

    function resize_fcn(src, eventdata) %#ok<INUSD>
        
        emg_rev = guidata(gcbf);
        
        fig_pos = getpixelposition(emg_rev.figure);
        fig_w = fig_pos(3);
        fig_h = fig_pos(4);
        rp_w = 100;
        
        setpixelposition(emg_rev.left_panel,        [1 1 fig_w-rp_w fig_h]);
        setpixelposition(emg_rev.y_min,             [15 fig_h-40 35 30]);
        setpixelposition(emg_rev.y_max,             [65 fig_h-40 35 30]);
        setpixelposition(emg_rev.right_panel,       [fig_w-rp_w 1 rp_w fig_h]);
        setpixelposition(emg_rev.prev_trial_btn,    [10 fig_h-40 35 30]);
        setpixelposition(emg_rev.next_trial_btn,    [55 fig_h-40 35 30]);
        setpixelposition(emg_rev.trial_num_edit,    [10 fig_h-70, rp_w-20 20]);
        setpixelposition(emg_rev.trial_list_edit,   [10 fig_h-100, rp_w-20 20]);
        setpixelposition(emg_rev.valid_checkbox,    [10 fig_h-130, rp_w-20 20]);
        setpixelposition(emg_rev.channel_listbox,   [10 fig_h-260, rp_w-20 100]);
        setpixelposition(emg_rev.zoom_listbox,      [10 fig_h-370, rp_w-20 100]);
        setpixelposition(emg_rev.add_mep_btn,       [10 fig_h-410, rp_w-20 30]);
        setpixelposition(emg_rev.add_section_btn,   [10 fig_h-445, rp_w-20 30]);
        setpixelposition(emg_rev.delete_section_btn,[10 fig_h-480, rp_w-20 30]);
        
    end
%% Key Press Function

    function key_press_fcn(src, eventdata) %#ok<INUSL>
        if ~isempty(eventdata.Modifier) && strcmpi(eventdata.Modifier{1}, 'control')
            switch eventdata.Key
                case 'space'
                    % toggle validity
                    emg_rev=guidata(gcbf);
                    set(emg_rev.valid_checkbox, 'Value', ~get(emg_rev.valid_checkbox, 'Value'));
                    update_emg_review(emg_rev, 'validity')
                case 'v'
                    % make valid
                    emg_rev=guidata(gcbf);
                    set(emg_rev.valid_checkbox, 'Value', 1);
                    update_emg_review(emg_rev, 'validity')
                case 'i'
                    % make invalid
                    emg_rev=guidata(gcbf);
                    set(emg_rev.valid_checkbox, 'Value', 0);
                    update_emg_review(emg_rev, 'validity')
                case 'z'
                    % zoom out
                    zoom_list = get(emg_rev.zoom_listbox, 'String');
                    set(emg_rev.zoom_listbox, 'Value', find(strcmpi('(none)', zoom_list)));
                    update_emg_review(guidata(gcbf), 'zoom')                                        
                case 't'
                    % zoom in to tms
                    zoom_list = get(emg_rev.zoom_listbox, 'String');
                    set(emg_rev.zoom_listbox, 'Value', find(strcmpi('tms', zoom_list)));
                    update_emg_review(guidata(gcbf), 'zoom')                                        
                case '1'
                    % zoom in to mep1
                    zoom_list = get(emg_rev.zoom_listbox, 'String');
                    set(emg_rev.zoom_listbox, 'Value', find(strcmpi('mep', zoom_list)));
                    update_emg_review(guidata(gcbf), 'zoom')                                        
                case '2'
                    % zoom in to mep2
                    zoom_list = get(emg_rev.zoom_listbox, 'String');
                    set(emg_rev.zoom_listbox, 'Value', find(strcmpi('mep2', zoom_list)));
                    update_emg_review(guidata(gcbf), 'zoom')                                        
                case 'leftarrow'
                    % prev trial
                    update_emg_review(guidata(gcbf), 'prev')                    
                case 'rightarrow'
                    % next trial
                    update_emg_review(guidata(gcbf), 'next')                    
            end
        end
    end

%% plotting

    update_emg_review(emg_rev, 'initialize');


%% callback function

    function emg_review_callback(src, eventdata, update_mode) %#ok<INUSL>
        update_emg_review(guidata(gcbf), update_mode)
    end
        
%% Control updater

    function update_emg_review(emg_rev, update_mode)
        
        % load emg data
        e_set = evalin('base', emg_rev.var_name);
        var_eval_str = sprintf('%s.data{%d, %d}', emg_rev.var_name, emg_rev.curr_trial, channel_names_to_indices(e_set, emg_rev.curr_channel));
        e = evalin('base', var_eval_str);
        need_to_save = false;
        if isempty(e), e = emg(); end;
        section_names = fieldnames(e.sections);

        zoom_list = {'(none)'; '(peak)'};
                
        switch update_mode
            case 'initialize'
                % do nothing
                
            case 'y_lim'
                emg_rev.y_lim = [-1 1];
                y_min = str2double(get(emg_rev.y_min, 'String'));
                y_max = str2double(get(emg_rev.y_max, 'String'));
                if ~isempty(y_min) && ~isnan(y_min), emg_rev.y_lim(1) = y_min; end;
                if ~isempty(y_max) && ~isnan(y_max), emg_rev.y_lim(2) = y_max; end;
                
            case 'next'
                emg_rev.curr_trial = emg_rev.trial_list(find(emg_rev.trial_list > emg_rev.curr_trial, 1, 'first'));
                if isempty(emg_rev.curr_trial), emg_rev.curr_trial = emg_rev.trial_list(end); end;
                
            case 'prev'
                emg_rev.curr_trial = emg_rev.trial_list(find(emg_rev.trial_list < emg_rev.curr_trial, 1, 'last'));
                if isempty(emg_rev.curr_trial), emg_rev.curr_trial = emg_rev.trial_list(1); end;
                
            case 'jump'
                emg_rev.curr_trial = str2double(get(emg_rev.trial_num_edit, 'String'));
                if emg_rev.curr_trial > max(emg_rev.trial_list), emg_rev.curr_trial = max(emg_rev.trial_list); end;
                if emg_rev.curr_trial < min(emg_rev.trial_list), emg_rev.curr_trial = min(emg_rev.trial_list); end;
                
            case 'trial_list'
                trial_list_expression = strtrim(get(emg_rev.trial_list_edit, 'String'));
                if isempty(trial_list_expression)
                    new_trial_list = 1:size(e_set,1);
                else
                    try
                        new_trial_list = evalin('base', trial_list_expression);
                    catch
                        fprintf('Trial list expression did not evaluate properly:\n\t%s\n', trial_list_expression);
                        new_trial_list = [];
                    end
                end
                if ~isempty(new_trial_list)
                    if islogical(new_trial_list)
                        new_trial_list = find(new_trial_list);
                    else
                        new_trial_list = sort(new_trial_list);
                    end;
                    emg_rev.trial_list = new_trial_list;
                    if ~any(ismember(new_trial_list, emg_rev.curr_trial))
                        emg_rev.curr_trial = new_trial_list(1);
                    end
                end
                
            case 'channel'
                emg_rev.curr_channel = emg_rev.channel_list{get(emg_rev.channel_listbox, 'Value')};
                
            case 'zoom'
                zoom_val = get(emg_rev.zoom_listbox, 'String');
                zoom_val = zoom_val{get(emg_rev.zoom_listbox, 'Value')};
                switch zoom_val
                    case {'', '(none)'}
                        emg_rev.zoom = '';
                    case '(peak)'
                        emg_rev.zoom = '';
                    otherwise
                        emg_rev.zoom = zoom_val;
                end
                
            case 'validity'
                e.tags.valid = get(emg_rev.valid_checkbox, 'Value');
                need_to_save = true;
                % report in command line
                if ~isempty(emg_rev.var_name)
                    fprintf('%s(%d, %d).tags.valid = %d\n', ...
                        emg_rev.var_name, emg_rev.curr_trial, get(emg_rev.channel_listbox, 'Value'), e.tags.valid);
                end
                
            case 'add_mep'
                
                if isfield(e.sections, 'mep')
                    warndlg('Current trial already has an mep section');
                    return
                end

                [mep_times] = ginput(2);
                e.sections.mep = mep_times(:, 1)';
                need_to_save = true;

                % report in command line
                if ~isempty(emg_rev.var_name)
                    fprintf('%s(%d, %d).sections.mep = [%f %f]\n', ...
                        emg_rev.var_name, emg_rev.curr_trial, mep_times(:, 1)');
                end

                
            case 'add_section'
                
                section_name = inputdlg('Enter section name: ','Add New Section', 1, {'mep2'});
                if isempty(section_name), return; else section_name = section_name{1}; end;
                
                if isfield(e.sections, section_name)
                    warndlg('Current trial already has a section with that name');
                    return
                end

                [mep_times] = ginput(2);
                e.sections.(section_name) = mep_times(:, 1)';
                need_to_save = true;
                
                % report in command line
                if ~isempty(emg_rev.var_name)
                    fprintf('%s(%d, %d).sections.%s = [%f %f]\n', ...
                        emg_rev.var_name, emg_rev.curr_trial, section_name, mep_times(:, 1)');
                end

                
            case 'delete_section'
                
                section_name = inputdlg('Enter section name: ','Delete Section', 1);
                if isempty(section_name), return; else section_name = section_name{1}; end;
                
                if ~isfield(e.sections, section_name)
                    warndlg('Current trial does not have a section with that name');
                    return
                end

                e.sections.(section_name) = [];
                need_to_save = true;

                % report in command line
                if ~isempty(emg_rev.var_name)
                    fprintf('%s(%d, %d).sections.%s = []\n', ...
                        emg_rev.var_name, emg_rev.curr_trial, section_name);
                end
                
            otherwise
                error('Unrecognized')
        end

        % save changes to emg, if necessary
        if need_to_save
            assignin('base', 'temp_emg_plot_variable', e);
            evalin('base', sprintf('%s = temp_emg_plot_variable;', var_eval_str));
            evalin('base', 'clear temp_emg_plot_variable');
        end
        
        % save figure data
        guidata(emg_rev.figure, emg_rev);
        
        % reload emg data to display any changes from above
        e_set = evalin('base', emg_rev.var_name);
        var_eval_str = sprintf('%s.data{%d, %d}', emg_rev.var_name, emg_rev.curr_trial, channel_names_to_indices(e_set, emg_rev.curr_channel));
        e = evalin('base', var_eval_str);
        if isempty(e), e = emg(); end;
        section_names = fieldnames(e.sections);

        % update: trial edit box
        set(emg_rev.trial_num_edit, 'String', emg_rev.curr_trial);
                        
        % update: zoom list box
        new_zoom_list = [zoom_list; section_names];
        set(emg_rev.zoom_listbox, 'String', new_zoom_list);
        if isempty(emg_rev.zoom)
            set(emg_rev.zoom_listbox, 'Value', 1);
        elseif any(ismember(new_zoom_list', emg_rev.zoom))
            set(emg_rev.zoom_listbox, 'Value', find(ismember(new_zoom_list, emg_rev.zoom)));
        else
            set(emg_rev.zoom_listbox, 'Value', 1);
        end
    
        % update: plot
        emg_obj_name = sprintf('%s{%d, %d}', emg_rev.var_name, emg_rev.curr_trial, channel_names_to_indices(e_set, emg_rev.curr_channel));
        cla;
        warning off EMG:Zoom_section_missing
        if ~isempty(e) && ~isempty(e.data)
            plot(e, 'figure', emg_rev.figure, 'zoom', emg_rev.zoom, 'save_var', emg_obj_name, 'y_lims', emg_rev.y_lim);
        else
            cla(emg_rev.figure)
        end
        warning on EMG:Zoom_section_missing
        
        % update valid box
        set(emg_rev.valid_checkbox, 'Value', e.tags.valid);
        
        % update: channel list box
        set(emg_rev.channel_listbox, 'String', emg_rev.channel_list);
        set(emg_rev.channel_listbox, 'Value', channel_names_to_indices(e_set, emg_rev.curr_channel));
        
    end
    
end