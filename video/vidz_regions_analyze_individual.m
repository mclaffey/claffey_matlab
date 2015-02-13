function [vid] = vidz_regions_analyze_individual(vid, region_name)
% Calculate metrics of selected object relative to specified regions

%% setup variables

    region_data = vid.regions.(region_name);
    
    if isempty(region_data)
        warning('vidz_regions_analyze_individual:empty_region', 'region %s is empty. skipping analysis...', region_name);
        return
    end
    
    region_mask = region_data.mask;
    
%% calculate pixel overlap

    region_mask_video = repmat(region_mask, [1 1 vid.data.frames]);
    overlap_video = region_mask_video & vid.object.video;
    overlap_count_by_frame = squeeze(sum(sum(overlap_video, 1), 2));

    region_data.contains_object = vidz_helper_get_metric_struct(vid, overlap_count_by_frame > 0);
    
    region_data.percent_of_object = vidz_helper_get_metric_struct(vid, overlap_count_by_frame ./ vid.object.pixel_count);
        
%% calculate distance between region and object

    % first calculate distance as percent of arena
    distances_to_object = pdist([region_data.centroid; [vid.object.x, vid.object.y ]] )';
    % then convert distance to physical units
    distances_to_object = distances_to_object * vid.params.physical_dims(1);
    region_data.distance_to_object = vidz_helper_get_metric_struct(vid, distances_to_object(1:vid.data.frames));
    
%% assign back to vid

    vid.regions.(region_name) = region_data;

%%
end