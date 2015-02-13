function [vid] = vidz_regions_scale_ellipse(vid, region_name, percent_scale)
% Enlarge an ellipse region by a specified percentage
%
%   [vid] = vidz_regions_scale(vid, region_name, percent_scale)

%% get the region data

    region_data = vid.regions.(region_name);
    
%% get ellipse parameters

    ellipse_x0 =            region_data.ellipse_coords(1);
    ellipse_y0 =            region_data.ellipse_coords(2);
    ellipse_half_width =    region_data.ellipse_coords(3);
    ellipse_half_height = 	region_data.ellipse_coords(4);
    
%% scale ellipse

    ellipse_half_width = ellipse_half_width * percent_scale;
    ellipse_half_height = ellipse_half_height * percent_scale;
    
%% make mask
    
    % create an array of booleans the size of the image where each element
    % inside the region is true
    region_mask = false(vid.callibration.dims);
    for i = 1:size(region_mask, 1);
        for j = 1:size(region_mask, 2);
            x = j;
            y = i;
            region_mask(i,j) = is_point_inside_ellipse(...
                ellipse_x0, ellipse_y0, ellipse_half_width, ellipse_half_height, x, y);
        end
    end    
    
%% save the region data

    vid = vidz_regions_save_new(vid, region_name, region_mask);
    vid.regions.(region_name).ellipse_coords = [ellipse_x0, ellipse_y0, ellipse_half_width, ellipse_half_height];    
    
end