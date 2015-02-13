function [edata] = exp_initialize_display(edata)
% Test the screen setup and save the basic parameters returned by scr()

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/27/09 created separate function for exp_initialize_display_elements()
%
    
    % use the scr() command to open screen and gather screen parameters (sp)
    [display_index, edata.display] = scr();
    edata.display.index = display_index;
        
    % draw background
    exp_display_black_background(edata);
    
    % confirm the screen works
    DrawFormattedText(edata.display.index, ...
        'Screen works...', 'center', 'center', edata.display.colors.white);
    Screen('Flip', edata.display.index);

%% initialize display elements

    edata = exp_initialize_display_elements(edata);

%% close screen

    pause(.5);
    cls

    
end
