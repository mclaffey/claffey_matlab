function [ttest_struct] = dsa_ttest(ttest_type, data, group_col, data_col, pairing_col)
% Perform an t-test on a normalized dataset
%
% This function does not need to be called directly by the user, who should call either
%   dsa_ttest_ind or dsa_ttest_dep. This function serves common processing for both of
%   those routines
%
% [ttest_struct] = dsa_ttest_ind(ttest_type, data, group_col, data_col, [pairing_col])
%
%   ttest_type is either 'ind' or 'dep'. See dsa_ttest_ind or dsa_ttest_dep for more help.

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/20/09 added pairing col variable for proper pairing of dep t-test
% 05/09/09 created dsa_ttest as common routine for dsa_ttest_ind and dsa_ttest_dep
% 05/06/09 added group labels
% 04/24/09 original version

%% check arguments
    assert(isa(data, 'dataset'), 'First argument must be a dataset');
    assert(ischar(group_col), 'GROUP_COL must be a string');
    assert(ischar(data_col), 'DATA_COL must be a string');
    column_names = get(data, 'VarNames');
    assert(ismember(group_col, column_names), 'GROUP_COL is not a column in DATA');
    assert(ismember(data_col, column_names), 'DATA_COL is not a column in DATA');
    
%% create group values

    group_values = unique(data.(group_col));
    group_values = any2cell(group_values);
    if length(group_values) > 2,
        fprintf('Group Values:\n');
        disp(group_values)
        error('More than two values were found in group_col (see above), use dsa_anova_rm');
    elseif length(group_values) < 2,
        fprintf('Group Values:\n');
        disp(group_values)
        error('Less than two group values were found');
    end

    group_a_name = any2str(group_values{1});
    group_b_name = any2str(group_values{2});

    switch ttest_type
        case 'ind'
            data_group_a = data.(data_col)(data.(group_col)==group_values{1});
            data_group_b = data.(data_col)(data.(group_col)==group_values{2});
        case 'dep'
            data_paired = dataset_rows2cols(data, pairing_col, group_col, data_col);
            data_group_a = data_paired.([group_a_name '_' data_col]);
            data_group_b = data_paired.([group_b_name '_' data_col]);            
            ttest_struct = ttest_dep_packaged(data_group_a, data_group_b);
        otherwise
            error('First argument must be ''ind'' or ''dep''')
    end


    

    
%% check for nan values

    if any(isnan(data_group_a))
        error('Some values in the %s group were NaN. Exclude before passing to dsa_ttest', group_a_name);
    elseif any(isnan(data_group_b))
        error('Some values in the %s group were NaN. Exclude before passing to dsa_ttest', group_b_name);
    end
    
%% perform ttest

    switch ttest_type
        case 'ind'
            ttest_struct = ttest_ind_packaged(data_group_a, data_group_b);
        case 'dep'
            ttest_struct = ttest_dep_packaged(data_group_a, data_group_b);
        otherwise
            error('First argument must be ''ind'' or ''dep''')
    end
    
%% construct result strings 

    ttest_struct.groups = sprintf('%s vs. %s', any2str(group_values{1}), any2str(group_values{2}));
    if ttest_struct.is_sig
        ttest_struct.text = sprintf('%s (M = %1.2f, SD=%1.2f) is different than %s (M = %1.2f, SD = %1.2f), %s', ...
            group_a_name, ttest_struct.means(1), ttest_struct.stds(1), ...
            group_b_name, ttest_struct.means(2), ttest_struct.stds(2), ...
            ttest_struct.result);
    else
        ttest_struct.text = sprintf('%s (M = %1.2f, SD=%1.2f) is not different than %s (M = %1.2f, SD = %1.2f), %s', ...
            group_a_name, ttest_struct.means(1), ttest_struct.stds(1), ...
            group_b_name, ttest_struct.means(2), ttest_struct.stds(2), ...
            ttest_struct.result);
    end
    
end
        
        
        
        