function openwmv(file_name)
% Open a wmv file (uses system default)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% original

    system(sprintf('open %s', file_name));
    
end