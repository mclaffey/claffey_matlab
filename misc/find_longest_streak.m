function [streak_start, streak_length] = find_longest_streak(a)
% Finds the longest consecutive streak of 1's in a logical array
%
% [STREAK_START, STREAK_LENGTH] = find_longest_streak(A)
%
%   Searches through logical vector A and finds the longest consecutive streak of true (1) values.
%   Returns STREAK_START as the beginning element of the streak, and STREAK_LENGTH as the total
%   number of 1's in the streak

% Copyright 2008-2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 02/23/09 added documentation
% 09/01/09 original version

    streak_start = [];
    streak_length = [];
    
%% cancel now if there aren't any streaks
    if ~any(a), return; end;

%% detect the streaks    
    streak_lengths = zeros(length(a), 1);
    x = 1;
    while x <= length(a)
        if a(x) == 0
            x = x + 1;
        else
            streak_end = find(a(x:end)==0, 1, 'first');
            if streak_end
                streak_lengths(x) = streak_end - 1;
                x = streak_end + x - 1;
            else
                streak_lengths(x) = length(a) - x + 1;
                break
            end
        end
    end
    
%% find the longest streak
    [streak_length, streak_start] = max(streak_lengths);
    
end