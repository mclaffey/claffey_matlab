function [edata, trial_data] = exp_data_delete_trials(edata, trial_data)
   
    delete_block = input('Delete which block? (RETURN to cancel): ');
    if isempty(delete_block), return; end;
    
    delete_rows = trial_data.block == delete_block;
    
    if any(delete_rows)
        confirm_string = sprintf('Are you sure you want to delete %d rows? (type ''yes''): ', sum(delete_rows));
        if strcmpi('yes', input(confirm_string, 's'))
            trial_data(delete_rows, :) = [];
            fprintf('Deleted.\n');
        else
            fprintf('Delete canceled\n');
        end
    else
        fprintf('There is no block %d in the data\n', delete_block);
    end
    
end