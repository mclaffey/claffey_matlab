function [b] = randperm_in_groups(a, group_size)
% Generate a index that randomizes items in groups of a certain size    
% 
% [B] = randperm_in_groups(A, N)
%
%   randperm_in_groups randomizes items in arrays while keeping N-items at a time in
%   consecutive order.
%
%   if A is a scalar, it is treated as the total number of items.
%
%   if A is an array, the rows of the array are randomized, keep N-items in a row in consecutive
%   order.
%
%  Example:
%     randperm_in_groups(12,3)
%     ans =
%          7
%          8
%          9
%          1
%          2
%          3
%          4
%          5
%          6
%         10
%         11
%         12
%
% See-also: randperm, randperm_chop

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/05/09 fixed bug related to item count (Cinco de Mayo!)
% 04/23/09 allowed first argument to be an array to randomized
% 04/20/09 cleaned up code
% 02/17/09 original version

    if isscalar(a) && ~isa(a, 'dataset') % isscalar erroneously evaluates datasets as scalars
        item_count = a;
        array_to_randomize = [];
    else
        array_to_randomize = a;
        item_count = size(a, 1);
    end

    group_count = item_count / group_size;
    assert(mod(group_count,1)==0, 'item_count must be a multiple of group_size');

    group_order = randperm(group_count)';
    b = expandmat(group_order, group_size) .* group_size - repmat([(group_size-1):-1:0]',group_count,1);

    if ~isempty(array_to_randomize)
        b = array_to_randomize(b, :);
    end
    
end