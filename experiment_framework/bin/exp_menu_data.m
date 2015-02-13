function [edata] = exp_menu_data(edata, loaded_from_workspace, menu_data, command, calling_file)
% Helper function to create the menu_data structure
%
%   [edata] = exp_menu_data(edata, loaded_from_workspace, menu_data, command, calling_file)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 10/21/09 added link to this file in warning message
% 10/12/09 added warning about using the experiment framework's edata

%% menu_data structure
%
%   menu_data.calling_file
%   menu_data.command
%   menu_data.menu_mode
%   menu_data.menu_choices.main
%                         .uninitialized
%                         .settings
%                         .practice
%                         .<other names>
%   menu_data.exit

    menu_data = assert_field(menu_data, 'calling_file', calling_file);
    menu_data = assert_field(menu_data, 'command', command);
    menu_data = assert_field(menu_data, 'menu_mode');
    menu_data = assert_field(menu_data, 'menu_choices');
    menu_data = assert_field(menu_data, 'exit', false);

%% determine the initial menu mode

    if isempty(menu_data.menu_mode)
        if loaded_from_workspace
            menu_data.menu_mode = 'main';
        else
            menu_data.menu_mode = 'uninitialized';
        end;
    end
    
%% check that the experiment abbreviation matches

    [calling_file_dir, calling_file_name, calling_file_ext] = fileparts(calling_file);

    if isfield(edata, 'experiment_abbreviation')
        if strcmpi(edata.experiment_abbreviation, 'your_experiment_abbreviation')
            fprintf('The command %s does not appear to initialize any edata for itself and is defaulting\n', calling_file_name);
            fprintf('to the experiment framework''s edata. Copy exp_initialize_edata to your bin folder.\n');
            fprintf('(message from %s)\n', link_text('edit', 'exp_menu_data'));
            menu_data.exit = true;
        elseif ~strcmpi(edata.experiment_abbreviation, calling_file_name)
            fprintf('The command entered was %s, but the data in the workspace is for the %s experiment.\n', calling_file_name, edata.experiment_abbreviation);
            fprintf('You will need to clear edata from the workspace before running a different experiment.\n');
            fprintf('(message from %s)\n', link_text('edit', 'exp_menu_data'));
            menu_data.exit = true;
        end
    else
        edata.experiment_abbreviation = calling_file_name;
    end
    
%% save it to edata

    edata.menu = menu_data;
    
end