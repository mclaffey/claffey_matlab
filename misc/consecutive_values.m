function [b] = consecutive_values(a)
% Return a logical array indicating if each value in an array is the same as the previous
%
% [b] = consecutive_values(a)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 04/30/09 original version

    b = zeros(length(a),1);
    for x = 2:length(a)
        if a(x) == a(x-1), b(x) = 1; end;
    end
    
end