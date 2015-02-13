function [answer] = input_restricted(prompt, possible_answers, default_answer)
% Based on built-in input() but re-prompts user if answer is not in acceptable list
%
% [answer] = input_restricted(prompt, possible_answers, DEFAULT_ANSWER)
%
% DEFAULT_ANSWER is the value to return if no input is provided (i.e. the user hits ENTER).
% If this value is empty, the user must explicitly type a value from POSSIBLE_ANSWERS.
%
% See-also: input, input_yesno
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/22/09 original version
    
%% check input arguments

    assert(ischar(prompt), 'PROMPT must be a string');
    assert(iscell(possible_answers), 'POSSIBLE_ANSWERS must be a cell array');
    if ~exist('default_answer', 'var'), default_answer = ''; end;

    answer_is_ok = false;
    while ~answer_is_ok

        answer = input(prompt, 's');
        
        % if the user did not provide an answer (hit ENTER)
        if isempty(answer)
            if ~isempty(default_answer)
                answer = default_answer;
                answer_is_ok = true;
            else
                fprintf('You must enter one of the acceptable answers:\n')
                cellfun_easy(@fprintf, '\t%s\n', possible_answers);
            end
            
        % if the user provided an answer, check it
        else
            if ismember(answer, possible_answers)
                answer_is_ok = true;
            else
                fprintf('The response was not one of the acceptable answers:\n')
                cellfun_easy(@fprintf, '\t%s\n', possible_answers);
            end
        end
    end
    
end