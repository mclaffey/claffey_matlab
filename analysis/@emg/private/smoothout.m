function [b] = smoothout(a)
% Simple smoothing by taking each point to the max of it and it's two neighbors
%
% NOTE: Does not work with negative numbers

    b=a;
    for i = 2:length(a)-1
        b(i) = max(a(i-1:i+1));
    end
end