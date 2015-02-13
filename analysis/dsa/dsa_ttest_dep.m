function [ttest_struct] = dsa_ttest_dep(data, pairing_col, group_col, data_col)
% Perform a dependent measures t-test on a normalized dataset
%
% [ttest_struct] = dsa_ttest_dep(data, pairing_col, group_col, data_col)
%
%   DATA must be a dataset containing the columns to analyze
%
%   PAIRING_COL is a string contiaing the name of the column to use to pair values
%
%   GROUP_COL is a string containing the name of the column with the group labels
%
%   DATA_COL is a string containing the name of the column with the data to analyze
%
% See-also: dsa_ttest_ind, dsa_ttest

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 10/06/09 fixed argument list in documentation
% 05/20/09 added pairing column variable
% 05/09/09 truncated to use dsa_ttest()

    ttest_struct = dsa_ttest('dep', data, group_col, data_col, pairing_col);
end
        
        
        
        