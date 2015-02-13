function [vid] = vidz_query_time_all(vid, callibration_duration, data_duration)
% Query the user for the timing of the callibration and data within a video
    
    % callibration timing
    vid.timing.callibration_start = query_seconds('Enter start time of callibration');
    if exist('callibration_duration', 'var')
        vid.timing.callibration_duration = callibration_duration;
    else
        vid.timing.callibration_duration = query_seconds('Enter duration of callibration');
    end
    
    % data timing
    vid.timing.data_start = query_seconds('Enter start time of data clip');
    if exist('data_duration', 'var')
        vid.timing.data_duration = data_duration;
    else
        vid.timing.data_duration = query_seconds('Enter duration of data clip');
    end

end