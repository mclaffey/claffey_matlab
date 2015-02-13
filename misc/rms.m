function [b] = rms(a)
% Compute root-mean-square

    b = sqrt(mean(a.^2));
end