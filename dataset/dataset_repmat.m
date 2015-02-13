function [b] = dataset_repmat(a, row_multiplier)
% Replicate the rows of a dataset

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/06/09 original version

    b = a;
    for x = 1:row_multiplier-1
        b = vertcat(b, a);        
    end
    
end