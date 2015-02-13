function vid = vidz_regions_query_circle(vid, f, region_name, prompt, circle_radius)

%% query user for boundaries

    if ~exist('prompt', 'var') || isempty(prompt)
        prompt = 'Click at center of region...\n';
    end
    
    % set focus
    figure(f);
    set(0, 'CurrentFigure', f)    
    
    % get center point
    fprintf('%s\n', prompt);
    region_center = ginput(1);

%% set pixel mask

    circle_x = round(region_center(1));
    circle_y = round(region_center(2));
    
    % create an array of booleans the size of the image where each element
    % inside the region is true
    region_mask = false(vid.callibration.dims);
    for i = 1:size(region_mask, 1);
        for j = 1:size(region_mask, 2);
            x = j;
            y = i;
            point_distance = pdist([circle_x, circle_y; x, y]);
            region_mask(i,j) = (point_distance <= circle_radius);
        end
    end
    
%% save region

    vid = vidz_regions_save_new(vid, region_name, region_mask);
    vid.regions.(region_name).circle_coords = [circle_x, circle_y];
    vid.regions.(region_name).circle_radius = circle_radius;    

end