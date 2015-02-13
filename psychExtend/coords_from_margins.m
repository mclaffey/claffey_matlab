function [inner_coords] = coords_from_margins(margins, outer_coords)
% Creates a subwindow from a larger window using margins on each side
%
% outer_coords and inner_coords are 4-element coordinate arrays in the
% usual matlab format of [left coordinate, up coordinate, width, height].
%
% margins is what % smaller the inner_coords window should be on each side
% from the outer_coords window.
%   If margins is 1 element, that number is used on all four sides.
%   If it is 2 elements, the first is used on the left/rigth and the second
%       is used on the top/bottom
%   If it is 4 elements, those numbers are applied to the left, bottom, right,
%       and top
%
% Example: Assuming outer_coords = [0 0 1200 800]
%
%   coords_from_margins([.1], outer_coords) = [120 80 1080 720]
%       Creates a 10% margin on all sides
%
%   coords_from_margins([.1 .2], outer_coords) = [120 160 1080 640]
%       Creates a 10% margin on the left/right and a 20% margin on the
%       top/bottom
%
%   coords_from_margins([.1 .2 .3 .4], outer_coords) = [120 160 360 320]

%   mclaffey@ucsd.edu
%   Last updated April 28, 2008

%% error checking
    if length(margins) == 1
        margins = [margins(1) margins(1) 1-margins(1) 1-margins(1)];        
    elseif length(margins) == 2
        % only width and heigh margins were provided, so convert
        margins = [margins(1) margins(2) 1-margins(1) 1-margins(2)];
    elseif length(margins) == 4
        margins = [margins(1) margins(2) 1-margins(3) 1-margins(4)];
    else
        error('Wrong number of elements in margins')
    end
    if margins(3) - margins(1) <= 0, error('The left and right margins are more than 100%% of the window'); end;
    if margins(4) - margins(2) <= 0, error('The top and bottom margins are more than 100%% of the window'); end;

    if length(outer_coords) ~= 4
       error('the outer_coords must be 4 elements long')
    end
    
%% calculate the new coordinates using the requested margins
    screen_width = outer_coords(3);
    screen_height = outer_coords(4);
    outer_coords(3) = 1 - outer_coords(3);
    outer_coords(4) = 1 - outer_coords(4);

    inner_coords = round([screen_width screen_height screen_width screen_height] .* margins);
end
    
