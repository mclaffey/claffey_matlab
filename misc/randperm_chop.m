function [b] = randperm_chop(a, keep_count)
% Randomizes an array and only keeps a specified number of elements
%
% [B] = randperm_chop(A, [KEEP_count])
%
% KEEP_COUNT is the number of elements to keep after array A has been randomized. If
%   KEEP_COUNT is omitted, no elements are removed from array A. If KEEP_COUNT is less
%   than 1, it is considered a percentage of the number of elements in A. Note: a value
%   of 1 will be considered 1 element, not 100%.
%
% If A is an matrix (more than 1 dimension) or dataset, the first dimension (rows) are randomized.
%
% If A is an integer, it is automically expanded to [1:A].
%
% Example:
%   a = [1 2 3 4 5];
%   b = randperm_chop(a, 3)
%
%   b = 
%       2   1   3
%
%   b = randperm_chop(a, .4)
%
%   b =
%       4   3
%
%   randperm_chop(100, 5)
%
%   ans =
%       [85 16 23 49 5]
%
% See also: randperm, randperm_in_groups

% Copyright Mike Claffey 2009 (mclaffey[]ucsd.edu)
%
% 01/19/11 fixed typo in documentation
% 02/09/09 original version


    flip_at_end = false;
    if size(a,1)==1, a=a'; flip_at_end = true; end;
    if isnumeric(a) && max(size(a)) == 1, a = [1:a]'; end;
    if ~exist('keep_count', 'var'), keep_count = length(a); end;
    assert(isnumeric(keep_count), 'KEEP_COUNT must be empty or a numeric value');
    if keep_count < 1, keep_count = round(keep_count * length(a)); end;
    
    b = a(randperm(length(a)),:);
    b = b(1:keep_count, :);
    
    if flip_at_end, b=b'; end;
    
end
    
    
    
    