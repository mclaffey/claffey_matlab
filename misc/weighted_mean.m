function [b] = weighted_mean(a, weights)
% Calculated a weighted average    
%
% [b] = weighted_mean(a, weights)

    b = a .* weights;
    b = sum(b) / sum(weights);
    
end
    