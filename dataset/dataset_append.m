function [a] = dataset_append(a, b)
% Adds observations similar to vertcat, but creates new fields as needed
%
%   [C] = dataset_append(A, B)
% 
%   vertcat requires the columns (fields) in each dataset to be the same, whereas dataset_append
%   adds the missing columns to each dataset before appending 
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
%   C = dataset_append(A, B)
% 
%         C = 
%             subject    score    level          
%             1           95      ''             
%             2           87      ''             
%             3          NaN      'easy'         
%             4          NaN      'difficult'    

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 02/09/09 fixed bug for missing fields, should used setxor not setdiff
% 10/23/08 performance tweak in emcompass
% 10/05/08 original version

    if ~isempty(a) && ~isa(a, 'dataset')
        error('First argument must be either a dataset or empty variable')
    end
    if ~isempty(b) && ~isa(b, 'dataset')
        error('Second argument must be either a dataset or empty variable')
    end
        
    if isempty(a)
        a = b;
        return
    elseif isempty(b)
        return
    end
    
%% add any missing fields to A
    
    if ~isempty(setxor(get(a,'VarNames'), get(b, 'VarNames')))
        a = dataset_encompass(a, b);
        b = dataset_encompass(b, a);
    end
    
%% make column order the same and append    
    b = b(:, get(a,'VarNames'));
    try
        a = vertcat(a, b);
    catch
        compare_results = dataset_compare(a,b);
        fprintf('\n\n');
        command_window_line;
        fprintf('Comparison of datasets:\n');
        disp(compare_results);
        fprintf('Comparison of column classes:\n');
        disp(compare_results.class_differences);
        fprintf('VERTCAT command of dataset_append is producing an error\n');
        fprintf('See dataset_compare() data above, may be helpful.\n');
        rethrow(lasterror);
    end
    
end