function [e_mean] = mean(e)
% Create a mean trace across all sweeps for each channel

    sweep_count = size(e,1);
        
    all_sweeps = nan(sweep_count, length(e.data{1,1}.data));
    for trial = 1:sweep_count
        all_sweeps(trial,:) = e.data{trial,1}.data;
    end

    sweep_mean = mean(all_sweeps);
    e_mean = emg(sweep_mean, 2000);
    
end

