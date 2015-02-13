function [is_in_ellipse] = is_point_inside_ellipse(x0, y0, a, b, x, y)
% Determine if a point is in an ellipse
% Based on http://www.mathworks.com/matlabcentral/newsreader/view_thread/169873

    t = 0; % ellpse is not rotated relative to x axis

    X = (x-x0)*cos(t)+(y-y0)*sin(t); % Translate and rotate coords.
    Y = -(x-x0)*sin(t)+(y-y0)*cos(t); % to align with ellipse

    % this was previously < 1, which did not include the perimeter of the
    % ellipse
    is_in_ellipse = X^2/a^2+Y^2/b^2 <= 1;
    
end
