function [a] = exprnd_bounded(exp_mean, exp_min, exp_max, exp_interval, row_count, column_count)
% Similar to exprnd except the values can be bound by a mininum/maximum
%
%   [a] = exprnd_bounded(target_mean, minimum_value, max_value, value_intervals, row_count, column_count)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/23/09 added optimization to make sure mean of data was close to mean specified in arguments
% 03/05/09 original version

    original_exp_mean = exp_mean;
    mean_deviation_tolerance = .001;
    mean_is_close_enough = false;
    while ~mean_is_close_enough
        a = nan(row_count, column_count);
        elements_that_need_values = isnan(a(:));
        while any(elements_that_need_values)
            a(elements_that_need_values) = exprnd(exp_mean, sum(elements_that_need_values), 1);
            elements_that_need_values = a(:) < exp_min | a(:) > exp_max;
        end
        a = round(a ./ exp_interval) .* exp_interval;
        
        % check the mean
        data_mean = mean(a);
        mean_deviation = (original_exp_mean - data_mean) / original_exp_mean;
        if abs(mean_deviation) < mean_deviation_tolerance
            mean_is_close_enough = true;
        else    
            exp_mean = exp_mean * (1 + mean_deviation / 2);
        end
            
    end
    
end