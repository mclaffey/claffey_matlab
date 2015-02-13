function wait_until(wait_time)
% Wait until a specificied clock time
%
% Wait_until provides a convenient way to wait until a given clock time. There are two common ways
% to wait until a given time, but both have trade offs. Both involve a while loop until a given time
% is reached. If nothing is specified in the while loop, Matlab executes as quickly as possible,
% hogging the CPU. Pause(0.001) can be added to the while loop, but pause() is inaccurate below the
% 10 ms range. This function uses pause(0.01) until within 50 ms and then an expedited
% while loop for the last portion.

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 10/25/08 original version
    
    % Up until with 50 ms of the wait time, use 10 ms pauses
    while GetSecs < (wait_time - .05)
        pause(.01);
    end
    % With less than 50 ms to wait time, don't use pauses
    while GetSecs < wait_time; end;
end
    