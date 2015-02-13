function [e] = safe_data_grow(e, trial_indices)
% Grows the emg_set.data cell by adding empty emg objects
%
% It is possible to assign an emg_object to a trial which is larger than the existing e.data cell
% matrix. Matlab will automatically expand the cell matrix, but it does so by adding empty cells.
% This can create problems when functions are called on the emg_set and empty cells are returned
% instead of empty emg() objects. This function safely grows the emg_set.data cell matrix by adding
% empty emg objects.
%
% Example:
%   new_trials = [1000 1006 1200]
%   e = safe_data_grow(e, new_trials)

% Copyright Mike Claffey mclaffey@ucsd.edu
% 9/17/08 initial version

    max_new_trial = max(trial_indices(:));
    trial_count = size(e,1);
    if max_new_trial <= trial_count, return; end;
    
    new_trials = max_new_trial - trial_count;
    channel_count = size(e,2);
    e.data((trial_count+1):max_new_trial,:) = repmat({emg()},new_trials,channel_count);

end