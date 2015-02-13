function [stats] = dataset_anova_rm(data, y_col, group_cols, subject_col)
% Outdated function: see dsa_anova_rm

    warning('dataset_anova_rm:outdated', 'Outdated! Function was renamed to dsa_anova_rm and argument order changed');
    
    if exist('subject_col', 'var')
        stats = dsa_anova_rm(data, group_cols, y_col, subject_col);
    else
        stats = dsa_anova_rm(data, group_cols, y_col);
    end
    
end