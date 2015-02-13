function openmp4(file_name)
% Open a mp4 file (uses system default)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 08/05/10 original

    system(sprintf('open %s', file_name));
    
end