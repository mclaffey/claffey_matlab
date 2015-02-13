function [path_str] = genpath_no_svn(start_directory)
% Generates a path string similar to genpath() but exludes .svn directories

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 03/07/09 original version

    % add the start_directory
    path_str = [start_directory pathsep];
    
    % look for any folders/files and stop if the directory is empty
    sub_dirs = dir(start_directory);
    if isempty(sub_dirs), return; end;
    
    % otherwise iterate through the contents and recursively add non-.svn subdirectories
    for x = 1:length(sub_dirs)
        if      sub_dirs(x).isdir && ...
                ~strcmp(sub_dirs(x).name, '.') && ...
                ~strcmp(sub_dirs(x).name, '..') && ...
                ~strncmp(sub_dirs(x).name, '@', 1) && ...
                ~strcmp(sub_dirs(x).name, 'private') && ...
                ~strcmp(sub_dirs(x).name, '.svn')
            [path_str] = [path_str genpath_no_svn(fullfile(start_directory, sub_dirs(x).name))]; %#ok<AGROW>
        end
    end
end
