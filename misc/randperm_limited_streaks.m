function [b] = randperm_limited_streaks(a, streak_limit, iteration_limit)
% Randomize a sequence while limiting streaks of the same values
%
% [b] = randperm_limited_streaks(a)
%
%   Do not allow any consecutive values
%
% [b] = randperm_limited_streaks(a, streak_limit)
%
%   Allow streaks of the same value up to length streak_limit (e.g. 3, 10)
%
% [b] = randperm_limited_streaks(a, streak_limit, iteration_limit)
%
%   By default, the function gives up after 500 iterations and throws an error. Provide the
%   iteration_limit argument to change this limit
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/30/09 original version

    if ~exist('streak_limit', 'var'), streak_limit = 1; end;
    if ~exist('iteration_limit', 'var'), iteration_limit = 500; end;
    b = a;
    iteration_count = 0;
    streak_limit = streak_limit - 1;
    
    
    streak_length = streak_limit + 1;
    while streak_length > streak_limit
        b = randperm_chop(b);
        [streak_start, streak_length] = find_longest_streak(consecutive_values(b));
        iteration_count = iteration_count + 1;
        
        if iteration_count == iteration_limit
            error('Failed to find a satisfactory sequence before iteration limit')
        end
    end
    
end