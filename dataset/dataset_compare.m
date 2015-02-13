function [results] = dataset_compare(a, b)
% Find differences between two datasets
%   
%   dataset_compare(a, b)
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/27/09 original version

    a2 = struct(a);
    b2 = struct(b);
    
%% variable names

    results.a_name = inputname(1);
    results.b_name = inputname(2);
    
%% observation differences

    results.rows_in_a = size(a,1);
    results.rows_in_b = size(b,1);
    results.row_count_difference = results.rows_in_a - results.rows_in_b;
    
%% field name differences

    results.columns_in_a = size(a,2);
    results.columns_in_b = size(b,2);
    results.column_count_difference = results.columns_in_a - results.columns_in_b; 
    results.fields_in_common = intersect(a2.varnames, b2.varnames);
    results.missing_in_a = setdiff(b2.varnames, a2.varnames);
    results.missing_in_b = setdiff(a2.varnames, b2.varnames);
    
%% class differences of variables

    class_diffs = {};
    for x = 1:length(results.fields_in_common)
        var_name = results.fields_in_common{x};
        class_a = class(a.(var_name));
        class_b = class(b.(var_name));
        if ~strcmpi(class_a, class_b)
            class_diffs = vertcat(class_diffs, {var_name class_a class_b}); %#ok<AGROW>
        end
    end
    if isempty(class_diffs)
        results.class_differences = [];
    else
        results.class_differences = dataset({class_diffs, 'var_name', results.a_name, results.b_name});
        results.class_differences = dataset_nominalize_fields(results.class_differences, {'var_name', results.a_name, results.b_name});
    end
    
%% are datasets the same

    results.is_equal = (...
        results.row_count_difference == 0 & ...
        results.column_count_difference == 0 & ...
        isempty(results.missing_in_a) & ...
        isempty(results.missing_in_b) ...
        );        
    
end