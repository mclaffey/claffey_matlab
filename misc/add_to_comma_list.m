function [new_list] = add_to_comma_list(old_list, new_items)
% Adds items to a string of comma separated items
%
%   [new_list] = add_to_comma_list(old_list, new_items)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 08/31/10 original version

%% handle the new items

    if isempty(new_items)
        new_list = old_list;
        return
        
    elseif ischar(new_items)
        new_items_str = new_items;
        
    elseif iscell(new_items)
        new_items_str = new_items{1};
        for item_index = 2:length(new_items)
            new_items_str = [new_items_str ', ', new_items{item_index}]; %#ok<AGROW>
        end
        
    else
        error('add_to_comma_list:bad_new_items', 'new_items must be a string or cell array of strings')
    end
    
%% add new items to list

    if isempty(old_list)
        new_list = new_items_str;
    else
        new_list = [old_list ', ' new_items_str];
    end
            
end
