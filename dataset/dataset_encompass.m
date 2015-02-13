function [a] = dataset_encompass(a, b)
% Expands a dataset to include all the columns of another dataset
%
%   A = dataset_encompass(A, B)
%
%   Any columns that are in B but not in A are added to A. These new columns
%   contained default values based on the data type of the columns in B
%
%   This function is primarily for making two datasets compatible before appending
%   them to one another
%
% Example:
%   A = dataset({[1;2], 'subject'}, {[95;87], 'score'})
% 
%         A = 
%             subject    score
%             1          95   
%             2          87   
% 
%   B = dataset({[3;4], 'subject'}, {{'easy';'difficult'}, 'level'})
% 
%         B = 
%             subject    level          
%             3          'easy'         
%             4          'difficult'    
% 
%   C = dataset_encompass(A, B)
% 
%         C = 
%             subject    score    level 
%             1          95       ''    
%             2          87       ''    

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/21/09 allow for handling of empty datasets
% 02/09/09 added handling of logicals
% 10/05/08 original version

%% error checking

    assert(isa(a, 'dataset'), 'First argument must be either a dataset');
    assert(isa(b, 'dataset'), 'Second argument must be either a dataset');

%% determine which fields need to be added
    
    fields_missing_from_a = setdiff(get(b,'VarNames'), get(a, 'VarNames'));
    new_col_count = length(fields_missing_from_a);

%% in the special case that both datasets are empty, use this code    
    
    if isempty(a) && isempty(b)
        for x = 1:new_col_count
            a.(fields_missing_from_a{x}) = b.(fields_missing_from_a{x});
        end

%% otherwise, determine the default value type for each field and add columsn to A

    else

        default_values = cell(1, new_col_count);
    
        for x = 1:new_col_count
            b_value = b.(fields_missing_from_a{x});
            if isnumeric(b_value) || islogical(b_value)
                default_values{x} = NaN;
            elseif  ischar(b_value) || isa(b_value, 'nominal') || iscell(b_value)
                default_values{x} = {''};
            else
                error('unknown class for column %s', fields_missing_from_a{x})
            end
        end

        a = dataset_add_columns(a, fields_missing_from_a, default_values);
    end    
    
end