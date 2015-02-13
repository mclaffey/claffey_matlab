function [a] = vertcat(a, b)
% Appends the trials of two emg_sets with the same number of channels    
    if size(a, 2) ~= size(b, 2)
        error('emg_sets must have equal number of channels')
    end 
    
    if ~isequal(a.channel_names, b.channel_names)
        warning('channel names were different, using names from first set') %#ok<WNTAG>
    end
    
    a.data = vertcat(a.data, b.data);
end
    
    