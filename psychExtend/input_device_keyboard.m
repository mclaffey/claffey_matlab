function [keyboard_index] = input_device_keyboard(show_warning)
% Returns the index of the first full keyboard found, ignoring keypads
%
% input_device_keyboard([SHOW WARNING])
%
% SHOW_WARNING is an optional boolean that defaults to true. To suppress warnings,
%   pass a true value

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)

% 01/16/2009 added warning suppression
% 09/01/2008 original version

    keyboard_index = input_device_find('keyboard');
    
    if isempty(keyboard_index)
        warning('Could not find a full keyboard') %#ok<WNTAG>
    elseif length(keyboard_index) > 1
        
        % show warning by default
        if ~exist('show_warning', 'var'), show_warning = true; end;
        
        if show_warning
            warning('Found multiple keyboards, using first found') %#ok<WNTAG>
        end
        keyboard_index = keyboard_index(1);
    end
end