function [choice] = menu_str(prompt, menu_choices)
% Modified version of built-in menu function (see 'help menu_str')
%
% [choice] = menu_str(prompt, menu_choices)
%
%   prompt is a string containing the menu quesiton.
%   menu_choices is a cell array of string choices.
%
% menu_str returns the users select as the string they selected (as opposed to
%   built-in menu, which returns an integer). It applies lower() to this string
%   for ease of use in subsequent comaprisons (e.g. using the switch control syntax)
%
% menu_str automatically adds a 'Cancel' option to the menu_choices. if the user closes
%   the menu without answering, this is returned as a 'cancel' as well.

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/21/09 original version

%% check arguments
    assert(ischar(prompt), 'PROMPT argument must be a string');
    assert(iscell(menu_choices) && ischar(menu_choices{1}), 'MENU_CHOICES must be a cell array of strings');
    if ~ismember({'cancel'}, lower(menu_choices))
        menu_choices{end+1} = 'Cancel';
    end;
    
%% prompt    
    choice_num = menu(prompt, menu_choices);
    
%% convert response    

    if choice_num == 0
        choice = 'cancel';
    else
        choice = lower(menu_choices{choice_num});
    end

end