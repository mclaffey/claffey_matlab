function [is_scalar_boolean] = isscalar_strict(a)
% Improves upon the built-in isscalar to reject datasets, structures, etc
    
    is_scalar_boolean = isscalar(a) && ~isa(a, 'dataset') && ~isa(a, 'struct');
    
end