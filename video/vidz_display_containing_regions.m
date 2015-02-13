function vidz_display_containing_regions(vid, frame_num)
% Highlight any regions which contain the object during a given frame
%
%   vidz_display_containing_regions(vid, frame_num)

    region_names = fieldnames(vid.regions);
    
%% iterate through each region

    for x = 1:length(region_names);
        
        region_name = region_names{x};

        % determine if region contains object for specified frame
        region_contains_object = vid.regions.(region_name).contains_object.by_frame(frame_num);
        
        % if it doesn, call the region highlighting funciton
        if region_contains_object
            vidz_display_region(vid, region_name);
        end
    end    
    
end
