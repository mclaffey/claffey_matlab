function [vid] = vidz_regions_scale(vid, region_name, percent_scale)
% Enlarge a region by a specified percentage
%
%   [vid] = vidz_regions_scale(vid, region_name, percent_scale)

%% determine if it is an ellipse

    region_is_ellipse = isfield(vid.regions.(region_name), 'ellipse_coords');
    
%% call the correct subfunction based on region shape

    if region_is_ellipse
        [vid] = vidz_regions_scale_ellipse(vid, region_name, percent_scale);
    else
        [vid] = vidz_regions_scale_rect(vid, region_name, percent_scale);
    end
    
end