function [b] = dataset_clean(a)
    
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 4/24/09 original versin
    
    b = a;
    b = dataset_numericize_fields(b);
    b = dataset_nominalize_fields(a);
    
end