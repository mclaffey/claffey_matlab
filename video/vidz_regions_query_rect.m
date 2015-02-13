function vid = vidz_regions_query_rect(vid, f, region_name, prompt)

%% query user for boundaries

    if ~exist('prompt', 'var'),
        prompt = 'Drag rectangle over area...';
    end
    
    fprintf('%s\n', prompt);
    region_rect = getrect(f);

%% set pixel mask

    % rounding for pixel indices
    region_coords = rec2coords(region_rect);

    % create an array of booleans the size of the image where each element
    % inside the region is true
    region_mask = false(vid.callibration.dims);
    region_mask( ...
        region_coords.top:region_coords.bottom, ...
        region_coords.left:region_coords.right ) = true;
    
%% save region

    vid = vidz_regions_save_new(vid, region_name, region_mask);
    vid.regions.(region_name).coords = region_coords;

end