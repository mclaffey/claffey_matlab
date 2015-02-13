function [ttest_struct] = ttest_ind_packaged(a, b)
% Returns an informative structure for independement means ttest    
%
%   [ttest_struct] = ttest_ind_packaged(a, b)

% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 02/01/10 added error checking
% 04/24/09 original version

%% error check arguments

    if length(a) == 1 || length(b) == 1
        error('Arrays must contain more than one element');
    end

%% perform test


    [h,p,ci,stats] = ttest2(a, b);
    ttest_struct.is_sig = p < .05;
    ttest_struct.result = sprintf('t(%d)=%1.2f, %s', stats.df, stats.tstat, p_value_text(p));
    ttest_struct.input_data = {a, b};
    ttest_struct.means = cellfun(@mean, ttest_struct.input_data);
    ttest_struct.stds = cellfun(@std, ttest_struct.input_data);
    
end