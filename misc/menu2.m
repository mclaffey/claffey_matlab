function [response] = menu2(menu_str, menu_choices)
% Enhanced menu based on built-in menu()
%
%   - converts all menu choices to lower case for easy comparison with switch
%   - forced normal/floating menu even if docked is default
%
% [response] = menu2(menu_str, menu_choices)

% Copyright 2009-2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 09/02/10 added docking feature

%% set docked status to normal/floating

    old_dock_status = get(0,'DefaultFigureWindowStyle');
    set(0,'DefaultFigureWindowStyle','normal')

%% present menu

    response = menu(menu_str, menu_choices);
    if isempty(response), response=false; return; end;
    response = lower(menu_choices{response});
    
%% return dock status

    set(0,'DefaultFigureWindowStyle', old_dock_status)

end