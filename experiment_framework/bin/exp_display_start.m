function [edata] = exp_display_start(edata)
% If there isn't currently a valid screen, open a new one    
%
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/27/09 added try-catch around WindowKind
%          removed code to do picture-in-picture for debug mode
    
%% if there is a currently valid screen index, return as is    
    try %#ok<TRYNC>
        if Screen(edata.display.index, 'WindowKind')
            return
        end
    end

%% otherwise, try opening a new screen using the scr() function    
    
    try
        if edata.run_mode.debug
            % if using multiple displays,  open in the last one
            if length(Screen('Screens')) > 1
                [edata.display.index, screen_paramters] = scr();
                
            % if using one display, open a picture-in-picture window
            else
                [edata.display.index, screen_paramters] = scr();
            end
        else
            [edata.display.index, screen_paramters] = scr();
        end
        
%% catch errors are return debugging tips

    catch
        if ~exist('screen_parameters', 'var')
            % The scr command failed completely. Rethrow the error.
            fprintf('Failed to open PsychToolbox screen using scr():\n')
            rethrow(lasterror);
        elseif isfield('initialization_message', screen_parameters)
            disp(screen_parameters.initialization_message)
            fprintf('PsychToolbox failed to open a screen (see details above). Try running again.\n')
        else
            fprintf('PsychToolbox failed to open a screen. Try calling scr() directly to debug.\n')
        end
        return
    end

end