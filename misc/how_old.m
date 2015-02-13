function [age_string] = how_old(time_value)
% Return a string indicating how old a time_value is
%
%   [age_string] = how_old(time_value)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 09/09/09 original version

    assert(isnumeric(time_value), 'TIME_VALUE must be numeric');
    age_in_days = now() - time_value;
    age_in_secs = age_in_days * 24 * 60 * 60;
    age_string = round_time_to_text(age_in_secs);
    
end