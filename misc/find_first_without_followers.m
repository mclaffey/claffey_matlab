function [find_index] = find_first_without_followers(search_vector, follower_search_range)
% Find the first true element in an array without immediately following true values
%
% [find_index] = find_first_without_followers(search_vector, follower_search_range)

% Copyright 2009 Mike Claffey
%
% 08/17/09 original version
    
    last_valid_find_index = [];
    search_start_index = 1;
    keep_searching = true;
    while keep_searching
        % search for the next true point
        find_index = find_first_after(search_vector, search_start_index);
        
        % if not found, return the last valid find index
        if isempty(find_index)
            find_index = last_valid_find_index;
            return
        end
        
        % determine how far to look for followers
        follower_data_end = min(length(search_vector), find_index + follower_search_range);
        
        % look for followers
        follower_find_index = find_first_after(search_vector(1:follower_data_end), find_index);
    
        % if no followers are found, return this find point
        if isempty(follower_find_index)
            return
        end
        
        % otherwise, save this find point and keep searching
        last_valid_find_index = follower_find_index;
    end
    
end