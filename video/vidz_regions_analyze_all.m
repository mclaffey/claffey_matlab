function [vid] = vidz_regions_analyze_all(vid)
% Calculate metrics of selected object relative to all regions

    region_names = fieldnames(vid.regions);
    
    for region_num = 1:length(region_names)
        region_name = region_names{region_num};
        vid = vidz_regions_analyze_individual(vid, region_name);        
    end

end