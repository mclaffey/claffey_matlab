 function [stats] = dsa_anova_rm(data, group_cols, y_col, subject_col)
% Perform a repeated measures anova on a dataset    
%
% [stats] = dsa_anova_rm(data, group_cols, y_col, subject_col)
%
% Function used to be called dataset_anova_rm but was moved to the dsa group (dataset analytics)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/13/09 throw warning if there are nan values in any of the grouping columns
% 06/09/09 changed layout of results
% 05/27/09 got rid of factor name in fields, now 'is_sig' and 'result'
% 05/12/09 throws error is there are any missing cells
% 04/10/09 renamed to dsa_anova_rm and changed argument order
% 04/08/09 added warning about nan rows
% 04/09/09 correction, was displaying (M =, SD = ) when actually was (M =, SEM = ) 
% 03/01/09 (approx) original version
    
%% figure out column names

    col_names = get(data, 'VarNames');
    
    % subject column
    if ~exist('subject_col', 'var') || isempty(subject_col), subject_col = 'subject'; end;
    assert(ismember(subject_col, col_names), sprintf('Subject column ''%s'' could not be found', subject_col));
    
    % group columns
    if ischar(group_cols), group_cols = {group_cols}; end
    assert(iscell(group_cols), 'Group columns argument must be a char or cell');
    assert(all(ismember(group_cols, col_names)), 'Not all grouping columns were found in the dataset');
    group_cols = horzcat({subject_col}, group_cols);
    
%% check that there are multiple levels for each grouping column

    for x = 1:length(group_cols);
        try %#ok<TRYNC> - use a try because not all data types support isnan (e.g. nominals)
            if any(isnan(data.(group_cols{x})))
                error('There are nan values in grouping column: %s', group_cols{x});
            end
        end
        if length(unique(data.(group_cols{x}))) <= 1
            error('There was only one level for the grouping variable: %s', group_cols{x});
        end
    end
    
%% aggregate the data (doesn't effect anything if data is already aggregated)

    data = dataset_grpmean(data, group_cols, y_col);
    y = data.(y_col);
    
%% check that all subjects have equal number of cells

    [any_missing, missing_group_values, complete_cell_data] = dsa_find_missing_cells(data, group_cols{1});
    if any_missing
        error('The following subjects are missing cells:\n%s', mat2str(missing_group_values'));
    end
    
%% check if there are any NaN values

    nan_rows = isnan(data.(y_col));
    if any(nan_rows)
        errordlg(sprintf('There are %d record(s) with NaN values. ANOVA will not be accurate.', sum(nan_rows)));
    end
    
%% build the group variable

    group = cell(1, length(group_cols));
    for x = 1:length(group_cols);
        col_data = data.(group_cols{x});
        if isa(col_data, 'nominal'), col_data = droplevels(col_data); end;
        group{x} = col_data;
    end

%% build the other arguments for the anova

    model_arg = {'model', length(group_cols)-1};
    random_arg = {'random', 1};
    var_names_arg = {'varnames', group_cols};
    display_arg = {'display', 'off'};
    anova_args = {model_arg{:}, random_arg{:}, var_names_arg{:}, display_arg{:}};
    
%% perform the anova

    [p, table, anova_stats, terms] = anovan(y, group, anova_args{:});
    
    % package up the results;
    stats = struct('is_sig', false, 'result', '');
    
%% create a summary field for each effect/interaction level of the anova
    for x=2:size(table,1)-2
        if strcmpi('fixed', table{x,8})
            row_name = str2field_name(table{x,1});
            
            % Record significance
            factor_is_significant = table{x,7} < .05;
            stats.is_sig = stats.is_sig || factor_is_significant;
            
            % Produce text result
            degrees_of_freedom = table{x,11};
            if rem(degrees_of_freedom,1)~=0
                error('Non-interger degrees of freedom');
            end
            
            factor_result = sprintf('Effect of %s on %s is %s, F(%d,%d)=%1.2f, %s', ...
                row_name, ...
                y_col, ...
                iif(factor_is_significant, 'SIGNIFICANT', 'not significant'), ...
                table{x,3}, ...
                degrees_of_freedom, ...
                table{x,6}, ...
                p_value_text(table{x,7}));
            stats.result = [stats.result, sprintf('%s\n', factor_result)];
        end
    end
    
    stats.table = table;
    
%% factor details

    for comparison_number = 1:length(group_cols);
        factor_details = [];
        factor_details.factor = group_cols{comparison_number};
        factor_details.is_sig = [];
        
        dimension_arg = {'dimension', comparison_number};
        compare_args = {display_arg{:}, dimension_arg{:}};

        warning('off', 'stats:multcompare:IgnoringRandomEffects');
        [c,m,h,gnames] = multcompare(anova_stats, compare_args{:});

        % fix up the comparisons table
        c = dataset({c, 'level_a', 'level_b', 'min_diff', 'diff', 'max_diff'});
        c.significant = c.min_diff > 0 | c.max_diff < 0;
        c.a_mean = m(c.level_a, 1);
        c.b_mean = m(c.level_b, 1);
        c.level_a = nominal(c.level_a, gnames(unique(c.level_a)));
        c.level_b = nominal(c.level_b, gnames(unique(c.level_b)));
        c = c(:, {'level_a', 'a_mean', 'level_b', 'b_mean', 'diff', 'significant'});
        factor_details.is_sig = any(c.significant);
        factor_details.comparisons = c;
        
        % get rid of the subject comparison table
        if strcmpi(factor_details.factor, 'subject')
            factor_details.comparisons = [];
        end

        % display means as fields
        for x = 1:length(m);
            level_name = str2field_name(gnames{x});
            factor_details.levels.(level_name) = sprintf('(M = %1.3f, SEM = %1.3f)', m(x,1), m(x,2));
        end
        
        % append to overall report
        stats.factors(comparison_number) = factor_details;
    end
    
end