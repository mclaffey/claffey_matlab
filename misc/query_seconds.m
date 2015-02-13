function [answer] = query_seconds(prompt)
% Prompt user to enter a time either in seconds or minute:seconds format

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 03/09/11 factored math out to time_str2secs
% 08/03/10 added copyright

    original_answer = input(sprintf('%s (in seconds or m:ss): ', prompt), 's');
    
    [answer] = time_str2secs(original_answer);
    
end