function [varargout] = scr(open_mini_window)
% Opens a PsychToolBox screen and saves ID to variable 'w'
%
% [w, screen_parameters, screen_open_text] = scr([OPEN_MINI_WINDOW])
%
% If OPEN_MINI_WINDOW is not provided or is zero, scr() opens a full screen
%
% To open a mini window that does not cover the full screen (useful in
% debugging), set OPEN_MINI_WINDOW = 1 through 4. The window will open in a
% quarter of the screen, with 1 being the top-left, 2 being top-right, 3
% bottom-right, 4 bottom-left
%
% If the function is saved to an output argument, the screen pointer is
% returned
%
% If no output argument is provided, the screen pointer to the variable w
% in the base workspace 
%

% Copyright 2008-2011 Mike Claffey mclaffey[]ucsd.edu
%
% 01/20/11 added colors
% 04/24/09 save initialization text from evalc to screen paramters
% 02/27/09 used evalc to capture the OpenWindow command text
% 02/05/09 added feature for gathering screen parameters
% 09/18/08 upgrade to function and pip option
    
    if ~exist('open_mini_window', 'var')
        open_mini_window = 0;
    elseif ~isnumeric(open_mini_window) || open_mini_window < 0 || open_mini_window > 4
        error('open_mini_window must be a scalar between 0 and 4')
    end 

    if IsOSX
        % This command doesn't work for PCs
        Screen('Preference','VisualDebugLevel',0);
    end
    screen_id = max(Screen('Screens'));
    
    fprintf('Opening PsychToolbox Screen using scr()...\n');
    if ~open_mini_window
        % evalc is used because it captures all the text that OpenWindow spews to the command window
        [screen_start_text, w] = evalc('Screen(screen_id, ''OpenWindow'');');
    else
        screen_pos = Screen('Rect', screen_id);
        switch open_mini_window
            case 1
                mini_coords = coords_from_margins([.02 .02 .5 .5], screen_pos);
            case 2
                mini_coords = coords_from_margins([.5 .02 .02 .5], screen_pos);
            case 3
                mini_coords = coords_from_margins([.5 .5 .02 .02], screen_pos);
            case 4
                mini_coords = coords_from_margins([.02 .5 .5 .02], screen_pos);
        end
        [screen_start_text, w] = evalc('Screen(screen_id, ''OpenWindow'', 255, mini_coords);');
    end

%% set text defaults

    Screen('TextSize', w, 36);
    Screen('TextFont', w, 'Arial');
    Screen('TextColor', w, 255); %white

%% gather screen paraters

    if nargout >= 2
        screen_parameters = struct();
        
        if ~open_mini_window
            [screen_parameters.width, screen_parameters.height] = Screen(w, 'WindowSize');
            screen_parameters.x_center=screen_parameters.width/2;
            screen_parameters.y_center=screen_parameters.height/2;
        else
            screen_parameters.width = mini_coords(3) - mini_coords(1);
            screen_parameters.height = mini_coords(4) - mini_coords(2);
            screen_parameters.x_center = mini_coords(1) + screen_parameters.width / 2;
            screen_parameters.y_center = mini_coords(2) + screen_parameters.height / 2;
        end
            

        if IsOSX
            screen_parameters.colors.black=BlackIndex(w); % Should equal 0.
            screen_parameters.colors.white=WhiteIndex(w); % Should equal 255.
        else
            screen_parameters.colors.black=0; % Should equal 0.
            screen_parameters.colors.white=255; % Should equal 255.
        end
        
        screen_parameters.colors.red = [255 0 0];
        screen_parameters.colors.green = [0 255 0];
        screen_parameters.colors.blue = [0 0 255];
        screen_parameters.colors.purple = [255 0 255];
        screen_parameters.colors.brown = [140 40 10];
        
        
        screen_parameters.initializtion_message = screen_start_text;
    end
    
%% output arguments    
    
    if nargout == 0
        % if not output variables were requested, assign w to global workspace        
        assignin('base', 'w', w);

    elseif nargout == 1
        varargout = {w};

    elseif nargout == 2
        varargout = {w, screen_parameters};

    elseif nargout == 3
        varargout = {w, screen_parameters, screen_start_text};
        
    else
        error('More than two output variables were requested')
    end
    
end
