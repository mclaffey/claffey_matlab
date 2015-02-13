function [vid] = vidz_regions_scale_rect(vid, region_name, percent_scale)
% Enlarge a rectangular region by a specified percentage
%
%   [vid] = vidz_regions_scale(vid, region_name, percent_scale)

%% get the region data

    region_data = vid.regions.(region_name);

%% adjust width

    % determine how large the change is in columns
    width_change = region_data.coords.width * (percent_scale - 1);
    half_width_change = width_change / 2;
    
    % adjust the left, not going below 1
    region_data.coords.left = round(region_data.coords.left - half_width_change);
    region_data.coords.left = max(1, region_data.coords.left);
    % adjust the right, not going beyond the pic width
    region_data.coords.right = round(region_data.coords.right + half_width_change);
    region_data.coords.right = min(vid.callibration.dims(2), region_data.coords.right);

%% adjust height

    % determine how large the change is in rows
    height_change = region_data.coords.height * (percent_scale - 1);
    half_height_change  = height_change  / 2;
    
    % adjust the top, not going beyond row 1
    region_data.coords.top = round(region_data.coords.top - half_height_change);
    region_data.coords.top = max(1, region_data.coords.top);
    % adjust the bottom, not going beyond the bottom of the pic
    region_data.coords.bottom = round(region_data.coords.bottom + half_height_change);
    region_data.coords.bottom = min(vid.callibration.dims(1), region_data.coords.bottom);
    
%% save the new size

    region_data.mask(:) = false;
    region_data.mask( ...
        region_data.coords.top:region_data.coords.bottom, ...
        region_data.coords.left:region_data.coords.right ) = true;
    
%% calculate centroid

    region_data.centroid = vidz_regions_calc_centroid(region_data.mask);
    
%% save the region data

    vid.regions.(region_name) = region_data;

    
end