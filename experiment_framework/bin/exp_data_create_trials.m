function [edata, trial_data] = exp_data_create_trials(edata, trial_data)
    
    block_data = dataset();    
        
    % scramble the data
    block_data = randperm_chop(block_data);
                
    % format and add it to trial data
    [edata, trial_data] = exp_data_append_trials(edata, trial_data, block_data);
            
end