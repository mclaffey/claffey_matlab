function [coords] = rec2coords(rec)
% Build a structure of useful dimensions from a [left top width height] rec
%
%   [coords] = rec2coords(rec)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 04/04/10 original version
%

    coords.left = round(rec(1));
    coords.top = round(rec(2));
    
    coords.right = round(rec(1) + rec(3));
    coords.bottom = round(rec(2) + rec(4));
    
    coords.width = coords.right-coords.left;
    coords.height = coords.bottom-coords.top;
    
    coords.x_center = round(rec(1)-1 + rec(3) / 2);
    coords.y_center = round(rec(2)-1 + rec(4) / 2);
        
end
    
    
    
    
    