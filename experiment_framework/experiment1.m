function experiment1(command)
% Shell script to open main menu or run commands for experiment
%
% Framework Instructions: give this file a unique name for your experiment
%   for example: stroop1, stop_signal2
%
% Usage:
%
%   experiment1   % no arguments
%
%       Opens the main menu
%
%   experiment1(COMMAND)
%
%       Run the specified command without opening menu
%
%       For example: experiment1('run')
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 01/21/11 added documentation of option to custom menu
% 10/12/09 cleaned up

    % if a command wasn't specified, set the command variable to empty
    if ~exist('command', 'var'), command = ''; end;
    
    % the menu_data structure is used by the exp_menu() function that is
    % called at the end.
    % add the command (even if empty) to the structure
    menu_data.command = command;
    
%% Customization    
    
    % To add single options to the Custom menu, use this format:
    
    % menu_data.menu_choices.custom = {...
    %    'My custom option' ; ...
    
    
    % To add sub menus, use the following format:
    
    % menu_data.menu_choices.my_submenu = {...
    %    'Submenu Choice 1' ; ...
    %    'Submenu Choice 2' ; ...
    %    };        
    
        
%% Execution

    % the exp_menu() handles the menu functionality
    
    exp_menu(command, menu_data);
    
end


