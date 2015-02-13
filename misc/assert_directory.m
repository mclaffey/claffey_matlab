function assert_directory(dir_name)
% Creates a directory and all containing directories as needed
%
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/18/09 original version

    containing_dir = [];
    while ~isempty(dir_name)
        if ~exist('containing_dir', 'var');
            [containing_dir, dir_name] = strtok(dir_name, filesep);
            containing_dir = [filesep containing_dir];
        else
            [first_dir, dir_name] = strtok(dir_name, filesep);
            containing_dir = [containing_dir filesep first_dir];
        end
        if ~exist(containing_dir, 'dir')
            mkdir(containing_dir);
        end
    end
end