function datatipinfo(e)
% Displays mouse over information on an emg_set object

    var_data = whos('e');
    channel_count = length(e.channel_names);
    
    % trial count
    if length(e) == 1
        fprintf('1 trial\n');
    else
        fprintf('%d trials\n', length(e));
    end
    
    % memory size
    if fix(var_data.bytes / 1024 / 1024)
        fprintf('Size: %1.1f Mb\n', var_data.bytes / 1024 / 1024);
    else
        fprintf('Size: %1.1f Kb\n', var_data.bytes / 1024);
    end
        
    % channel names
    switch channel_count
        case 0
            fprintf('Channel names: None\n');
        case 1
            fprintf('Channel name: %s\n', e.channel_names{1});
        otherwise
            fprintf('Channel names:\n');
            for x = 1:channel_count
                fprintf('   %d) %s\n', x, e.channel_names{x});            
            end
    end
end