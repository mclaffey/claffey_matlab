function display(e)
%DISPLAY Display information about an emg_set in the command window

    disp(' ');
    disp([inputname(1),' = '])
    
    if isempty(e)
        fprintf('\t[empty emg_set object]\n\n');
        return
    end
    
    var_data = whos('e');
    channel_count = length(e.channel_names);
    
    % trial count
    if length(e) == 1
        fprintf('\t1 trial\n');
    else
        fprintf('\t%d trials\n', length(e));
    end
    
    % memory size
    if fix(var_data.bytes / 1024 / 1024)
        fprintf('\tSize: %1.1f Mb\n', var_data.bytes / 1024 / 1024);
    else
        fprintf('\tSize: %1.1f Kb\n', var_data.bytes / 1024);
    end
        
    % channel names
    switch channel_count
        case 0
            fprintf('\tChannel names: None\n');
        case 1
            fprintf('\tChannel name: %s\n', e.channel_names{1});
        otherwise
            fprintf('\tChannel names:\n');
            for x = 1:channel_count
                fprintf('\t   %d) %s\n', x, e.channel_names{x});            
            end
    end
    
    disp(' ');
end
