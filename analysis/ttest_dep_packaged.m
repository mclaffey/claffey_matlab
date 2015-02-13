function [ttest_struct] = ttest_dep_packaged(a, b)
% Returns an informative structure for dependement means ttest    
%
%   [ttest_struct] = ttest_dep_packaged(a, b)

% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 02/01/10 added error checking
% 10/06/09 fixed weird bug: was calling means() instead of mean(), so not sure how it ever worked
% 03/29/09 original version
    
%% error check arguments

    if length(a) == 1 || length(b) == 1
        error('Arrays must contain more than one element');
    end

%% perform test


    [h,p,ci,stats] = ttest(a, b);
    ttest_struct.is_sig = p < .05;
    ttest_struct.result = sprintf('t(%d)=%1.2f, %s', stats.df, stats.tstat, p_value_text(p));
    ttest_struct.input_data = [a, b];
    ttest_struct.means = mean(ttest_struct.input_data);
    ttest_struct.stds = std(ttest_struct.input_data);
    
end