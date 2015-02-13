function [edata, trial_data] = exp_data_check(edata, trial_data)
% Stops execution if trial_data is empty or all rows have been completed

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 10/13/09 added all complete trials catch

    if isempty(trial_data)
        fprintf('The trial_data is empty.\n');
        edata.run_mode.stop_asap = true;
    end
    
    % try to see if there any trials that still need to be completed
    % the try-catch is in case trial_data doesn't have a COMPLETE column
    try %#ok<TRYNC>
        if all(trial_data.complete)
            fprintf('All trials in trial_data have been completed.\n');
            edata.run_mode.stop_asap = true;
        end            
    end
    
end