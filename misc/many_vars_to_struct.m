function [the_struct] = many_vars_to_struct(varargin)
% Takes an unlimited number of arguments and collects them into a structure    
    
    the_struct = struct();
    for x = 1:nargin
        the_struct.(inputname(x)) = varargin{x};
    end
end