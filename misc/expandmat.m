function [b] = expandmat(a, x)
%EXPANDMAT Creates multiple copies of each element in an area
%   B = expandmat(A,X) creates a large matrix B consisting of X copies of
%   each element in A. Unlike repmat, which repeats the entire sequence of
%   a matrix, expandmat keeps each element in the original order while
%   creating multiple copies of it.
%
%   Example:
%       expandmat([1 2 3], 3) = [1 1 1 2 2 2 3 3 3]
%       expandmat({'hi' 'world'}, 2) = {'hi' 'hi' 'world' world'}

% Created by mikeclaffey@yahoo.com
% Last updated April 17, 2008

    % Error checking - input matrix a must be a one dimensional matrix. if
    % it is a vertical vector, it is temporarily flipped for processing
    if ndims(a) == 2
        if size(a,2) == 1
            a = a';
            need_flip = 1;
        elseif size(a,1) == 1
            need_flip = 0;
        else
            error('input matrix ''a'' must be a 1-dimensional matrix')
        end
    else
        error('input matrix ''a'' must be a 1-dimensional matrix')
    end

    % for each element in a, create x duplicates of it and append it to the
    % new matrix b
    b = [];
    for i = 1:length(a)
        b = [b repmat(a(i), 1, x)]; %#ok<AGROW>
    end

    % if the input matrix a was flipped because it was originally vertical,
    % flip the output matrix b to be vertical as well
    if need_flip, b = b'; end;
end