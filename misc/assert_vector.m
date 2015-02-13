function [b, error_message] = assert_vector(a, direction, throw_error)
% Asserts/manipuates a variable to be a vector in a given direction or returns an error
%
% [B, ERROR_MESSAGE] = assert_vector(A [, DIRECTION, THROW_ERROR])
%
% Asserts that A is a numeric 1-D vector and returns it as B. If it is not a 1-D vector, B is empty
%   and ERROR_MESSAGE describes the problem.
%
% If DIRECTION is specified, the function asserts that A is a vector in the dimension specified by
%   DIRECTION (1 is vertical, 2 is horizontal). If A is a 1-D vector but not in the dimension
%   specified by DIRECTION, it is transposed to match DIRECTION. If DIRECTION is missing or 0, the
%   function does not care about the direction of the vector.
%
% If THROW_ERROR evaluates to true, assert_vector will throw a matlab error rather than returning
%   ERROR_MESSAGE. If THROW_ERROR is false, no error is thrown, allowing the calling function to
%   handle the problem. If the THROW_ERROR is omitted, it defaults to TRUE.
%
% Example:
%
%   [b, err_mes] = assert_vector([1;2;3]) % assert is vector, but don't care about direction
%         b =
%              1     
%              2
%              3
%         err_mes =
%              []
%
%   [b, err_mes] = assert_vector({1 'asd' 99}, 1) % assert is vertical vector (direction=1)
%         b = 
%             [         1]
%             ['asd'     ]
%             [        99]
%         err_mes =
%              []
%
%   [b, err_mes] = assert_vector([1 2;3 4], 1) % will return an error
%         ??? Error using ==> assert_vector at 79
%         ASSERT_VECTOR received an invalid argument that was a 2-D matrix
%
%   myVar = [1,2;3,4]; % example of progamatic use with THROW_ERROR=FALSE
%   [myVar, err_mes] = assert_vector(myVar, 2, false);
%   if ~isempty(err_mes), error('The myVar variable %s and needs to be a vector', err_mes); end;

% Copyright 2009-2010 Mike Claffey (mclaffey[]ucsd.edu)
%
% 12/19/10 spelling in documentation
% 04/05/10 added attempt to squeeze
% 02/27/09 original version

%% check the arguments
    if ~exist('direction', 'var') || isempty(direction), direction = 0; end;
    assert(isnumeric(direction) && direction >= 0 && direction <= 2, 'DIRECTION must be either 0, 1 or 2');
    if ~exist('throw_error', 'var'), throw_error = true; end;
    try
        throw_error = logical(throw_error);
    catch
        error('THROW_ERROR must evaulate to a boolean');
    end

%% check whether A is a vector

    b = [];
    error_message = [];
    
    % try sequeezing a
    try
        a = squeeze(a);
    end
    
    if ~isnumeric(a) && ~iscell(a)
        error_message = 'was not numeric or cell';
    elseif length(size(a)) > 2
        error_message = 'had more than 2 dimensions';
    elseif min(size(a)) > 1
        error_message = 'was a 2-D matrix';
    end

%% throw error, if applicable
    if throw_error && ~isempty(error_message)
        error('ASSERT_VECTOR received an invalid argument that %s', error_message')
    end

%% otherwise, transpose the direction of a, if needed
    b = a;
    if direction == 1
        if size(a, 2) > 1, b = a'; end;
    elseif direction == 2
        if size(a, 1) > 1, b = a'; end;
    end

    
end