function [region_centroid] = vidz_regions_calc_centroid(region_mask)
% calculate centroid as percent of screen
%
%   [region_centroid] = vidz_regions_calc_centroid(region_mask)

    mask_dims = size(region_mask);

    region_props = regionprops(bwlabel(region_mask), 'Centroid');
    region_centroid = region_props.Centroid;
    region_centroid(1) = region_centroid(1) / mask_dims(1);
    region_centroid(2) = region_centroid(2) / mask_dims(2);
    
end
