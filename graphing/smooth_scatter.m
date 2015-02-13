%function smooth_scatter(x, y)
%%
    x = xxx_go_data.trial_num
    y = xxx_go_data.cue_rt
    
%% Plot the original data
    close all
    scatter(x,y)
    hold on
    
%% Plot moving average clouds

    bin_sizes = round(length(y) * [.08]);
    for bin_size = bin_sizes
        averaged_y = moving_average(y, bin_size);
        scatter(x, averaged_y, 'r.');
    end
    
%% Plot a moving average line

    averaged_y = moving_average(y, round(length(y) * .15));
    plot(x, averaged_y, 'r');
    
    %end
    






%%
end