function [n_above_threshold] = cumulative_above_threshold(signal_data, threshold, decline_rate)
% Calculates the number of consecutive elements in an array above a scalar threshold
%
% [n_above_threshold] = cumulative_above_threshold(SIGNAL_DATA, THRESHOLD, DECLINE_RATE)
%
% Iterates through SIGNAL_DATA and counts the number of consecutive elements
% that are greater in value than THRESHOLD. If a value is less than the
% THRESHOLD, it either decays at the exponential rate DECLINE_RATE, or
% resets to zero if DECLINE_RATE = 0.
%
% Example:
%   data = randn(10,1)
%   n_above = cumulative_above_threshold(data, -.1, 2)
%

% Copyright 2008 Mike Claffey mclaffey@ucsd.edu

% 9/11/2008
    
    if ~exist('decline_rate', 'var'), decline_rate = 2; end;

    signal_length = length(signal_data);
    n_above_threshold = zeros(1, signal_length);
    for n = 1:signal_length
        if n == 1
            previous_value = 0;
        else
            previous_value = n_above_threshold(n-1);
        end
        
        if signal_data(n) > threshold
            n_above_threshold(n) = previous_value + 1;
        else
            if decline_rate == 0
                n_above_threshold(n) = 0;
            else
                n_above_threshold(n) = max(0, previous_value/decline_rate - 1);
            end
        end
    end    

end
