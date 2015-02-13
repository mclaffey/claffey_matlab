function [f] = vidz_display_region_all(vid)
% Display all regions

    f = vidz_display_snapshot(vid);

    region_names = fieldnames(vid.regions);
    
    for x = 1:length(region_names); 
        vidz_display_region(vid, region_names{x});
    end

end