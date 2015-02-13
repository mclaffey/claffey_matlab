function [channel_indices] = channel_names_to_indices(e_set, channel_names)
% Converts the string names of channels to scalar indices    
    
    channel_indices = [];

    % if channel_names are already numeric indices, return as is
    if isnumeric(channel_names)
        channel_indices = channel_names;
        return
    end
    
    % if channel_names is a logical, convert to numeric indices
    if islogical(channel_names)
        channel_indices = find(channel_names);
    end
    
    % if channel_names is ':', return all channels
    if isequal(channel_names, ':') || isequal(channel_names, {':'})
        channel_indices = 1:size(e_set, 2);
        return
    end

    % if not a cell, convert to one for uniform handling
    if ~iscell(channel_names), channel_names = {channel_names}; end
    
    % now find the location of each name in the list of channel names
    for x = 1:length(channel_names)
        channel_index = find(strcmpi(e_set.channel_names, channel_names{x}));
        if channel_index
            channel_indices = horzcat(channel_indices, channel_index);
        else
            error('emg_set:channel_names_to_indices:unknown_channel_name', 'Invalid channel name: %s', channel_names{x})
        end;
    end
end