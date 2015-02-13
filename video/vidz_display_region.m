function vidz_display_region(vid, region_name)
% Display a region as a transparent overlay in the current figure
%
%   vidz_display_region(vid, region_name)

    if isfield(vid.regions.(region_name), 'color')
        region_color = vid.regions.(region_name).color;
    else
        region_color = [1 0 0];
    end
    alpha_value = 0.3;
    

%% Create region image

    region_mask = vid.regions.(region_name).mask;
    region_image = zeros([size(region_mask) 3]);
    for x = 1:3
        region_image(:,:,x) = double(region_mask) * region_color(x);
    end

%% draw the image

    hold on    
    region_handle = image(region_image);
    
%% make transparent
    
    alpha_image = zeros(size(region_mask));
    alpha_image(region_mask(:)) = alpha_value;
    set(region_handle, 'AlphaData', alpha_image);
    drawnow;

%%

end