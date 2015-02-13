function [vid] = vidz_regions_create_halves(vid, split_horizontally_bln, split_index, region_names)
% Divide the screen into two regions (not necessarily exactly halfves)
%
%   [vid] = vidz_regions_create_halves(vid, split_horizontally_bln, split_index, region_names)

%% round split index

    split_index = round(split_index);

%% first region
    
    % create the region variable
    region_1 = false(size(vid.callibration.image));
    
    if split_horizontally_bln
        % for horizontal, mark columns to left of split_index as true
        region_1(:, 1:split_index) = true;
    else
        % for vertical, mark rows above split_index as true
        region_1(1:split_index, :) = true;
    end
        
    % save region
    vid = vidz_regions_save_new(vid, region_names{1}, region_1);
    
%% second region
    
    % create the region variable
    region_2 = false(size(vid.callibration.image));
    
    if split_horizontally_bln
        % for horizontal, mark columns to right of split_index as true
        region_2(:, split_index+1:end) = true;
    else
        % for vertical, mark rows below split_index as true
        region_2(split_index+1:end, :) = true;
    end

    % save region
    vid = vidz_regions_save_new(vid, region_names{2}, region_2);
    
end
    
    
    
    