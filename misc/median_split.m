function [median_split_labels] = median_split(values)
% Return low/high labels for values based on median
%
%   [median_split_labels] = median_split(values)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 09/30/09 original version
   
    median_value = median(values);
    [median_split_labels] = iif(values < median_value, {'low'}, {'high'});
    
end