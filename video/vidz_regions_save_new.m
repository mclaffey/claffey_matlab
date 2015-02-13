function [vid] = vidz_regions_save_new(vid, region_name, region_mask, region_color)
% Save a new mask into the region structure of vid
%
%   Also determines centroid and assigns a random color, if needed.
%
%   [vid] = vidz_regions_save_new(vid, region_name, region_mask, region_color)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 08/24/2010 original version

%% save mask

    vid.regions.(region_name).mask = region_mask;
    
%% save color

    % select a random color if none was specified
    if ~exist('region_color', 'var')
        % save a copy of the current colormap
        current_colormap = colormap();
        
        % pick a random color from the jet colormap
        jet_colormap = colormap(jet);
        region_color = jet_colormap(randperm_chop(size(jet_colormap(), 1), 1), :);
        
        % return to current colormap
        colormap(current_colormap);

    end
    
    % save color
    vid.regions.(region_name).color = region_color;    

%% centroid

    vid.regions.(region_name).centroid = vidz_regions_calc_centroid(region_mask);

%%

end