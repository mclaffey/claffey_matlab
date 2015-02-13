function [vals] = iif(boolean_expressions, true_values, false_values)
% Returns one of two possible values depending on the truth of a third argument
%
% Form 1 - Scalar
%
%   The simplest form takes a single boolean argument and returns the second argument if
%   the boolean is true and the third argument if the boolean is false
%
%   [val] = iif(boolean_expression, true_value, false_value)
%
%   Example:
%
%   > p = 0.07;
%   > fprintf('The value is %s', iif(p < .05, 'Significant', 'Not Significant'))
%   ans = 
%       The value is Not Significant
%   > p = 0.02;
%   > fprintf('The value is %s', iif(p < .05, 'Significant', 'Not Significant'))
%   ans = 
%       The value is Significant
%
% Form 2 - Matrix
%
%   iif() can also work in matrix form. If the first argument is a logical array,
%   the second and third arguments must be matrices or cells of equal length.
%   iif() returns the corresponding value from the second or third argument based
%   on the truth of each value in the first.
%
%   [vals] = iif(boolean_expressions, true_values, false_values)
%
%   Example:
%
%   > subject_responded_with_left_hand = [true true false true]';
%   > left_hand_reaction_time = [0.51 0.45 NaN 0.53]';
%   > right_hand_reaction_time = [NaN NaN 0.49 NaN]';
%   > iif(subject_responded_with_left_hand, left_hand_reaction_time, right_hand_reaction_time)
%   ans =
%       0.51
%       0.45
%       0.49
%       0.53
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 06/09/09 original version 

    n = length(boolean_expressions);
    
%% if there is only a single boolean value, take all of either the true or false values    
    if n == 1
        if boolean_expressions
            vals = true_values;
        else
            vals = false_values;
        end
        
%% if there are multiple boolean expressions, take the corresponding true or false values        
    else
    
        if length(true_values)~=n, true_values=repmat(true_values, n, 1); end;
        if length(false_values)~=n, false_values=repmat(false_values, n, 1); end;

        vals = false_values;
        vals(logical(boolean_expressions)) = true_values(logical(boolean_expressions));
    end
end