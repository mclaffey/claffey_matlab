function [edata, trial_data] = exp_menu_custom(edata, trial_data)
% Handle custom menu commands specific to an experiment
%
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/11/09 original version

% Modify the code below after copying to experiment/bin directory

    switch edata.menu.command
        
          case 'custom'
              fprintf('There are no custom commands for this experiment.\n');
              edata.menu.command = 'exit';        
              % Replace the lines above with this command to change to custom submenu: 
              %     [edata] = exp_menu_set_mode(edata, 'custom');

% Example function:
%
%         case 'my custom menu choice'
%             [edata, trial_data] = my_custom_function(edata, trial_data);
%             edata.menu.command = 'exit';        
                
    end
    
end