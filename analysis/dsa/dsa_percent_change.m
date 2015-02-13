function [b] = dsa_percent_change(a, base_col, compare_col, new_col)
% Create a new column that is the calculation of the % change between two columns
%
%   dsa_percent_change(a, base_col, compare_col, new_col)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/13/09 original version
    
    b = a;
    b.(new_col) = ( a.(compare_col) - a.(base_col) ) ./ a.(base_col) * 100;
    
end