function [edata, trial_data] = exp_menu(command, menu_data)
% Prompt user (if necessary) and call appropriate function

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 02/03/11 added results row
% 01/18/11 removed report from subject analysis command
% 11/05/09 feedback option now displays the figure
% 10/14/09 added command to switch to the custom menu
% 08/10/09 renamed to exp_menu
%          changed input arguments
%          refactored many parts to be separate functions
% 07/31/09 changed feedback function to display matlab figure, not PTB screen
% 07/30/09 updated analysis section
% 07/27/09 revised version

%% determine the path of the file that called exp_menu

% this version has historically worked, but it produced an error on a PC using version 7.3    
%    calling_file = dbstack(1, '-completenames');
%    calling_file = calling_file(1).file;
%
% switched to this
    calling_file = dbstack('-completenames');
    calling_file = calling_file(2).file;

%% make sure current experiment directory is at the top of the search path

    exp_admin_add_paths(calling_file);
    
%% load or initalize edata & trial_data

    [edata, trial_data, loaded_from_workspace] = exp_admin_load_vars;
    
%% initialize the menu structure in edata

    [edata] = exp_menu_data(edata, loaded_from_workspace, menu_data, command, calling_file);        
                    
%% prepare to process a menu command

    while isfield(edata, 'menu') && ~edata.menu.exit
        
        % set edata.menu.exit to true so it will exit the loop unless a command below
        % tells it to repeat
        edata.menu.exit = true;
                
        % display the menu command as a hyperlink in the command window and
        % add to history
        if ~isempty(edata.menu.command)
            command_text = sprintf('%s(''%s'')', edata.experiment_abbreviation, edata.menu.command);
            fprintf('Running command: %s\n', link_text('matlab', command_text));
        end
        
        % check for any commands in a custom menu file
        [edata, trial_data] = exp_menu_custom(edata, trial_data);
    
        switch edata.menu.command
            
%% if no command is specified, prompt the user

            case ''
                edata = exp_menu_prompt(edata);
                
%% cancel
        
            case {'cancel', 'exit', 'skip'}
                % do nothing, will exit on the next loop

%% basic options

            case {'initialize', 'init'}
                [edata, trial_data] = exp_initialize;

            case 'run'
                [edata, trial_data] = exp_run(edata, trial_data);

            case 'reset'
                [edata, trial_data] = exp_reset(edata, trial_data);

            case 'status'
                exp_admin_status();
                
            case {'list files', 'ls'}
                exp_admin_file_links(edata);

%% change settings            

            case 'change settings'
                [edata] = exp_menu_set_mode(edata, 'settings');

            case 'edata'
                [edata] = exp_initialize_edata;
                edata.menu.exit = true;
                
            case 'inputs'
                [edata] = exp_initialize_inputs(edata);
                
            case 'display'
                [edata] = exp_initialize_display(edata);
                
            case 'sound'
                [edata] = exp_initialize_audio(edata);
                
            case {'update file locations', 'update file locs', 'files'}
                edata.files = exp_files(edata);

            case 'tms'
                [edata] = exp_initialize_tms(edata);
                
            case 'fmri'
                [edata] = exp_initialize_fmri(edata);
                
%% practice
            case 'practice'
                [edata] = exp_menu_set_mode(edata, 'practice');

%% data
            case 'manage data'
                [edata] = exp_menu_set_mode(edata, 'data');

            case {'add trials', 'add'}
                [edata, trial_data] = exp_data_add_prepare(edata, trial_data);
                
            case 'delete trials'
                [edata, trial_data] = exp_data_delete_trials(edata, trial_data);
                
            case {'view data', 'view'}
                [edata, trial_data] = exp_data_view(edata, trial_data);
                
            case {'view blocks'}
                exp_admin_block_status(edata, trial_data);
                
            case 'reinitialize'
                [edata, trial_data] = exp_data_reinitialize(edata, trial_data);                
                

%% show feedback            

            case 'feedback'
                edata = exp_analysis_blocks(edata, trial_data);
                figure;
                edata = exp_analysis_blocks_plot(edata, trial_data);
                disp(edata.analysis.block_stats);

%% load/save an existing subject            

            case {'load subject', 'load'}
                [edata, trial_data] = exp_admin_load_subject(edata);

            case {'save subject', 'save'}
                exp_admin_save_subject_analysis(edata, trial_data);

%% analysis            

            case 'analysis'
                [edata] = exp_menu_set_mode(edata, 'analysis');
                
            case {'analyze subject', 'analyze'}
                [edata, trial_data] = exp_analysis_subject(edata, trial_data);
                exp_admin_save_vars(edata, trial_data);
                exp_admin_save_subject_analysis(edata, trial_data);
                
            case {'anl'}
                [edata, trial_data] = exp_analysis_subject(edata, trial_data);
                
            case {'command line report', 'report'}
                exp_analysis_subject_report

            case {'publish html report', 'publish'}
                exp_analysis_publish(edata, trial_data);
                exp_analysis_open_html(edata, trial_data);
                
            case {'open html report', 'html'}
                exp_analysis_open_html(edata, trial_data);
                
            case {'create results row', 'row'}
                sub_row = exp_analysis_subject_row(edata, trial_data);
                dataset_csv_clipboard(sub_row);
                
            case {'consolidate subjects', 'consolidate'}
                exp_analysis_consolidate(edata);

%% administrative options            

            case 'admin'
                [edata] = exp_menu_set_mode(edata, 'admin');

            case 'create zips'
                exp_admin_zip(edata);

            case 'create help'
                if ~exist('m2html', 'file'), fprintf('The <a href="http://www.artefact.tk/software/matlab/m2html/">m2html library</a> could not be found\n'); return; end;
                m2html('mfiles', edata.files.base_dir, 'htmldir','help', 'recursive','on','globalHypertextLinks','on')

%% switch to the custom menu

            case 'custom'
                [edata] = exp_menu_set_mode(edata, 'custom');

                
%% unrecognized commands

            otherwise
                fprintf('Unrecognized command: %s\n', edata.menu.command);

        end
        
        %% save variables to the global workspace
        exp_admin_save_vars(edata, trial_data);

    end
    
end