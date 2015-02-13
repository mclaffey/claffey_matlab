function svn_diff(file_name, compare_to_online)
% Compare differences between local and repository vesions of a file

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu_
%
% 07/20/09 use double quotes regardless of version
% 07/13/09 original version

    assert(logical(exist('file_name', 'var')), 'Must provide a file name');
    if ~exist('compare_to_online', 'var'), compare_to_online = false; end;
    compare_to_online = logical(compare_to_online);

%% determine whether to compare to online version    
    
    if compare_to_online
        command_str = 'diff -r BASE:HEAD ';
    else
        command_str = 'diff ';
    end

%% run command    
    
    command_str = sprintf('%s "%s"', command_str, file_name);        
    [svn_output] = svn_command(command_str);
    disp(svn_output);

end