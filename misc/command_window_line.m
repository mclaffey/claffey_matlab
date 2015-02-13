function command_window_line
    
    command_window_size = get(0,'CommandWindowSize');
    command_window_width = command_window_size(1) - 5;
    fprintf([repmat('-', 1, command_window_width) '\n']);
    
end

    
    
    
    
    
    
    
    
    