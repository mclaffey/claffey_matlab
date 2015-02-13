function [is_empty] = isempty(e)
% Returns true if there are no emg objects or channel names in an emg_set
    is_empty = isempty(e.data) && isempty(e.channel_names);
end