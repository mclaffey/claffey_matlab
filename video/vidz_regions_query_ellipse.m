function vid = vidz_regions_query_ellipse(vid, f, region_name, prompts)

    region_data = [];

%% query user for boundaries

    if ~exist('prompts', 'var'),
        prompts = {'Click at top/bottom of elliptical region...\n', 'Click at left/right of elliptical region...\n'};
    end

    set(0, 'CurrentFigure', f)    
    
    % get top point
    fprintf('%s\n', prompts{1});
    region_top = ginput(1);

    % get side point
    fprintf('%s\n', prompts{2});
    region_side = ginput(1);

%% set pixel mask

    ellipse_x0 = round(region_top(1));
    ellipse_y0 = round(region_side(2));
    ellipse_half_width = abs(round(region_side(1)-region_top(1)));
    ellipse_half_height = abs(round(region_side(2)-region_top(2)));
    
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
    
%% save region

    vid = vidz_regions_save_new(vid, region_name, region_mask);
    vid.regions.(region_name).ellipse_coords = [ellipse_x0, ellipse_y0, ellipse_half_width, ellipse_half_height];    

end