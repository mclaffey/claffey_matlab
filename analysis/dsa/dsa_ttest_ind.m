function [ttest_struct] = dsa_ttest_ind(data, group_col, data_col)
% Perform a dependent measures t-test on a normalized dataset
%
% [ttest_struct] = dsa_ttest_dep(data, group_col, data_col)
%
%   DATA must be a dataset containing the columns to analyze
%
%   GROUP_COL is a string containing the name of the column with the group labels
%
%   DATA_COL is a string containing the name of the column with the data to analyze
%
% See-also: dsa_ttest_ind, dsa_ttest

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/09/09 truncated to use dsa_ttest()

    ttest_struct = dsa_ttest('ind', data, group_col, data_col);
    
end
        
        
        
        