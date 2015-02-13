function [edata] = exp_analysis_blocks(edata, trial_data)
% Calculate statistics for all blocks
%
%   There version included with the experiment framework
%   attempts to calculate rt and accuracy for go and stop trials

% 11/05/09 added to experiment framework

%% go trials - reaction time and accuracy

    % select go trials
    go_trials = trial_data(trial_data.trial_type=='go', :);
    
    % group by block and calculate average rt and correct
    go_stats = grpstats(go_trials, {'block'}, {'nanmean', 'nanstd'}, 'DataVars', {'rt', 'correct'});
    
    % Rename mean_correct to going correct and convert to percentage
    go_stats.going_correct = go_stats.nanmean_correct .* 100;
    go_stats.nanmean_correct = [];
    
    % get rid of unnecessary columns
    go_stats.GroupCount = [];
    go_stats.nanstd_correct = [];
    go_stats = dataset_rename_column(go_stats, 'nanmean_rt', 'mean_rt');
    go_stats = dataset_rename_column(go_stats, 'nanstd_rt', 'std_rt');
    
%% stop trials - accuracy    

    % select stop trials
    stop_trials = trial_data(trial_data.trial_type=='stop', :);
    
    % group by block and calculate average correct rate
    stop_stats = grpstats(stop_trials, 'block', {'mean'}, 'DataVars', {'correct'});
    
    % Rename mean_correct to stopping correct and convert to percentage
    stop_stats.stopping_correct = stop_stats.mean_correct .* 100;

%% join the going and stopping dataset

    % check to make sure there were stop trials to make stats from
    if ~isempty(stop_stats)
        block_stats = dataset_join(go_stats, stop_stats(:, 'stopping_correct'), {}, {}, 'outer');
    else
        % if there were no stop trials, just insert an empty column
        block_stats = dataset_add_columns(go_stats, 'stopping_correct', NaN);
    end
    
%% clean up    
    
    % sort by block
    block_stats = sortrows(block_stats, 'block');
    
    % append to edata
    edata.analysis.block_stats = block_stats;

end
