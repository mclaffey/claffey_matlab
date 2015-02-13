function [time_text] = round_time_to_text(time_in_secs)
    
    assert(isnumeric(time_in_secs), 'Argument must be a scalar value');
    
%% seconds    
    time_value = abs(time_in_secs);

    if time_value <= 10
        time_text = sprintf('%1.1f seconds', round_decimal(time_value, 1));
        return
    elseif time_value < 50
        time_text = sprintf('%d seconds', round(time_value));
        return
    end
    
%% minutes
    
    time_value = time_value / 60;
        
    if time_value <= 3
        time_text = sprintf('%1.1f minutes', round_decimal(time_value, 1));
        return
    elseif time_value < 50
        time_text = sprintf('%d minutes', round(time_value));
        return
    end
    
%% hours
    
    time_value = time_value / 60;
        
    if time_value <= 3
        time_text = sprintf('%1.1f hours', round_decimal(time_value, 1));
        return
    elseif time_value < 18
        time_text = sprintf('%d hours', round(time_value));
        return
    end
    
%% days
    
    time_value = time_value / 24;
        
    if time_value <= 6
        time_text = sprintf('%d days', round(time_value));
    elseif time_value <= 30
        time_text = sprintf('%1.1f weeks', time_value / 7);
    elseif time_value <= (365 * 2)
        time_text = sprintf('%1.1f months', time_value / (365 / 12) );
    else
        time_text = sprintf('%1.1f years', time_value / 365 );
    end
end
