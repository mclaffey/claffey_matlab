function [patch_handle] = highlight_rectangle(region_x_lims, region_y_lims, region_color, region_alpha)
% Highlights a rectangular area of a graph
%
% [patch_handle] = highlight_rectangle(region_x_lims, region_y_lims, region_color, region_alpha)
%
% Note that highlight_rectangle will not adjust the axis to make itself visible.
%
% Example:
%
%   The following highlights a rectangle from 2 to 5 on the x axis and 100 to 300 on the
%   y axis, with the color red ([red=1 green=0 blue=0]) and 60% opacity
%
%       highlight_rectangle([2 5], [100 300], [1 0 0], .6)
%
% Copyright 2009 Mike Claffey (mclaffey[]csd.edu)
%
% 07/31/09 original version

   x = region_x_lims([1 2 2 1]);
   y = region_y_lims([1 1 2 2]);
   region_color = reshape(region_color, [1 1 3]);
   
   patch_handle = patch(x, y, region_color, 'FaceAlpha', region_alpha, 'EdgeColor', 'none');
   
end