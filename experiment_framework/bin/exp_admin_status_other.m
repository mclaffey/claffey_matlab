function exp_admin_status_other(edata, trial_data)
    
    fprintf('Number of successful stop trials: %d\n', sum(trial_data.trial_type=='stop' & nz(trial_data.correct, 0)));
    
    % go rt
    go_rt = nanmean(trial_data.rt(trial_data.trial_type=='go' & nz(trial_data.correct, 0)));
    fprintf('Go RT: %1.3f secs\n', go_rt);
    
    % stopping
    ssd = ssd_analyzer(trial_data.ssd, trial_data.correct, 'ssd_method', 'last half');
    fprintf('SSD:   %1.3f secs (last half method)\n', ssd);
    fprintf('SSRT:  %1.3f secs\n', go_rt - ssd);

end