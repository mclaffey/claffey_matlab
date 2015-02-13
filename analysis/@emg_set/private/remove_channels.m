function [e] = remove_channels(e, remove_channels)
% Returns en emg_set after removing the specified channel names

	remove_channels = channel_names_to_indices(e, remove_channels);
    all_channels = 1:size(e, 2);
    keep_channels = setdiff(all_channels, remove_channels);
    
    e.data = e.data(:, keep_channels);
    e.channel_names = e.channel_names(keep_channels);    
end