function [edata, trial_data] = exp_data_append_trials(edata, existing_trial_data, new_trial_data)
% Add all necessary columns, change column format and order

%% if the subject number isn't specified in the columns definition, write it in

    col_defs = edata.columns.definitions;
    subject_row = strcmpi(col_defs(:,1), 'subject');
    if any(subject_row)
        if isnan(cell2mat(col_defs(subject_row, 2)))
            col_defs{subject_row, 2} = edata.subject_id;
        end
    end    

%% perform changes based on edata.column_definitions

    new_trial_data = exp_data_format_trials(new_trial_data, col_defs);
        
%% add a trial_num column of consecutive integers
    
    try
        last_trial_num = nz(max(existing_trial_data.trial_num), 0);
    catch
        last_trial_num = 0;
    end
    new_trial_count = size(new_trial_data,1);
    new_trial_nums = last_trial_num+1:last_trial_num+new_trial_count;
    new_trial_data.trial_num = new_trial_nums';
    
%% assign a block number if there is not already a value

    if all(isnan(new_trial_data.block))
        try
            last_block_num = nz(max(existing_trial_data.block), 0);
        catch
            last_block_num = 0;
        end
        new_block_num = last_block_num + 1;
        new_trial_data.block(:) = new_block_num;
    end
    
%% append the new data

    trial_data = dataset_append(existing_trial_data, new_trial_data);
    
end
