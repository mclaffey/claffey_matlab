function [answer_boolean] = input_yesno(prompt, default_answer)
% Prompts user to answer a yes or no question in the command line
%
% [answer_boolean] = input_yesno(prompt, DEFAULT_ANSWER)
%
% input_yesno() prompts the user to respond with either y, yes, n or no. If the user provides
% an unrecognizable answer they are are reprompted.
%
% answer_boolean is TRUE if the user replies 'yes' or 'y', and false for 'no' or 'n'
%
% DEFAULT_ANSWER is the value to return if no input is provided (i.e. the user hits ENTER).
%   If this value is empty, the user must explicitly type a value from POSSIBLE_ANSWERS. Note:
%   DEFAULT_ANSWER can be a value other than yes or no, but the user can not type any value other than
%   yes, y, no or n.
%
% See-also: input, input_restricted
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/10/09 made output answer variable be a boolean (yes = true, no = false)
% 07/22/09 original version
    
%% check input arguments

    assert(ischar(prompt), 'PROMPT must be a string');
    if ~exist('default_answer', 'var') || isempty(default_answer), default_answer = ''; end;
    
%% populate prompt text

    switch default_answer
        case ''    
            default_text = '';
        case {'yes', 'y'}
            default_text = '. ENTER for yes';
        case {'no', 'n'}
            default_text = '. ENTER for no';
        otherwise
            default_text = sprintf('. ENTER for %s', default_answer);
    end

    prompt = sprintf('%s (type ''yes'' or ''no''%s): ', prompt, default_text);
    
%% call input_restricted to prompt user

    [answer] = input_restricted(prompt, {'yes', 'y', 'no', 'n'}, default_answer);
    
    answer_boolean = strcmpi(answer, 'yes') || strcmpi(answer, 'y');
    
end