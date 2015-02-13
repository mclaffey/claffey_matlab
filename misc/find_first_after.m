function [find_index] = find_first_after(search_vector, index_to_search_after)
% Find the first true element in an array starting after a given index
%
% [find_index] = find_first_after(search_vector, index_to_search_after)

% Copyright 2009 Mike Claffey
%
% 08/17/09 original version
    
    modified_search_vector = search_vector(index_to_search_after+1:end);
    find_index = find(modified_search_vector, 1, 'first');
    find_index = index_to_search_after + find_index;
    
end