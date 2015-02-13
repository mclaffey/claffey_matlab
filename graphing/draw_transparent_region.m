function [region_handle] = draw_transparent_region(pixels, region_color, alpha_value)
% Overlay a transparent image on the current axes
%
%   [region_handle] = draw_transparent_region(pixels, region_color, alpha_value)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 08/05/10 cleaned up from original
   
    % if the hold state is currently off, make a note to return it to that 
    need_to_turn_hold_off = ~ishold();

    % create image
    for x = 1:3
        region_image(:,:,x) = double(pixels) * region_color(x); %#ok<AGROW>
    end

    % overlay image
    hold on
    region_handle = image(region_image);

    % make is transparent
    alpha_image = zeros(size(pixels));
    alpha_image(pixels(:)) = alpha_value;
    set(region_handle, 'AlphaData', alpha_image);
    
    % return hold state
    if need_to_turn_hold_off, hold off; end;
        
end
