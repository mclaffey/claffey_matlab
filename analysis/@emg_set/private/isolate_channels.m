function [e] = isolate_channels(e, keep_channels)
% Returns an emg_set with only the specified channels

    keep_channels = channel_names_to_indices(e, keep_channels);
    
    if max(keep_channels) > length(e.channel_names)
        error('Channel requested (%d) was greater than number of channels (%d)', max(keep_channels), length(e.channel_names))
    end
    
    e.data = e.data(:, keep_channels);
    e.channel_names = e.channel_names(keep_channels);
end