function [vid] = vidz_query_physical_dimensions(vid, mode)
% Determine the physical size of each pixel
%
% Note: Units are assumed to be meters
%
% [vid] = vidz_query_physical_dimensions(vid)
%
%    Manually prompts user for width and height
%
% [vid] = vidz_query_physical_dimensions(vid, [width height])
%
%   Provide the width and height as a matrix, no user prompt
%

%% if no mode is provided, prompt user

    if ~exist('mode', 'var')
        width = input('Enter physical width: ');
        height = input('Enter physical height: ');
        
%% if mode is provided and is a matrix, use those dimensions

    elseif isnumeric(mode)
        assert(numel(mode)==2, 'MODE variable must have two elements: [width height]');
        width = mode(1);
        height = mode(2);
        
    end
    
%% record values    

    vid.params.physical_dims = [width height];
    
%% set the clip aspect ratio to match the physical aspect ratio

    aspect_ratio = width / height;
    height_pixel_count = vid.params.data_extract_clip_size(2);
    width_pixel_count = round(aspect_ratio * height_pixel_count);
    vid.params.data_extract_clip_size(1) = width_pixel_count;
    
    vid.params.pixel_edge_length = width / width_pixel_count;
    
%% report    

    fprintf('Physical width = %1.3f m by height = %1.3f m\n', ...
        vid.params.physical_dims(1), vid.params.physical_dims(2));
    fprintf('Clip width = %d pixels by height = %d pixels\n', ...
        vid.params.data_extract_clip_size(1), vid.params.data_extract_clip_size(2));
    fprintf('Pixel size = %1.1f mm on each edge\n', vid.params.pixel_edge_length * 1000);

end