function svn_update(file_or_dir_name)
% Update the current directory

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu_
%
% 07/20/09 use double quotes regardless of version
% 07/13/09 added ability to update a single file or directory
% 05/05/09 original version


    if ~exist('file_or_dir_name', 'var') || isempty(file_or_dir_name)
        command_str = 'update';
    else
        command_str = sprintf('update "%s"', file_or_dir_name);        
    end

    [svn_output] = svn_command(command_str);
    disp(svn_output);

end