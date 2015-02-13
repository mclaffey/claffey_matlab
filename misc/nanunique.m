function [b] = nanunique(a)
% Returns unique values excluded NaN
%
%   [b] = nanunique(a)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 09/21/09 original version

    % a nominal doesn't have NaN and throws an error on isnan, so bypass
    if isa(a, 'nominal')
        b = a;
        
    % all other variables, remove NaN values
    else
        b = ~isnan(a);
    end

%% return unique values

    b = unique(b);
    
end