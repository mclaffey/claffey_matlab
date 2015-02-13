function [edata] = exp_menu_set_mode(edata, new_mode)
    
    % set the menu mode to the new value
    edata.menu.menu_mode = new_mode;
    
    % clear the command to trigger a user prompt in the new mode
    edata.menu.command = '';
    
    % set exit to false so exp_menu runs through the loop again
    edata.menu.exit = false;
    
end