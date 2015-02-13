function [t] = sampling_time(time_arg, point_arg)
% [t] = sampling_time(time_arg, point_arg)
%
%   time_arg can be sampling rate or [start_time, end_time]
%
%   point_arg can be number_of_points or actual data

% 07/10/13 t.sampling_rate is rounded automatically to avoid
%          rounding/floating point issues


%% list of all variables
    t.start = 0;
    t.duration = 0;
    t.sampling_rate = 0;
    t.points = 0;
    t = class(t, 'sampling_time');
    
    if nargin == 0, return; end;

%% process arguments amount number of points    
    switch length(point_arg)
        case 1
            t.points = point_arg;
        otherwise
            t.points = length(point_arg);
    end
    if round(t.points) ~= t.points
        warning('point_arg is not an integer')
        keyboard
    end

%% process arguments amount time frame    
    switch length(time_arg)
        case 1
            t.sampling_rate = time_arg;
            t.start = 0;
            t.duration = t.points / t.sampling_rate;
        case 2
            t.start = time_arg(1);
            t.duration = time_arg(2) - t.start;
            % t.sampling_rate = t.points / t.duration; % original
            t.sampling_rate = round_decimal(t.points / t.duration, 4);
        otherwise
            error('time_arg must either be the sampling_rate or [start_time end_time] matrix')
    end
    
%%
    if abs(round(t.sampling_rate) - t.sampling_rate) > 0 && abs(round(t.sampling_rate) - t.sampling_rate) <  1e-10;
        warning('rounding issue detected');
    end;

end
