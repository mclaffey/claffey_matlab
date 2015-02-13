function svn_commit(file_or_dir_name)
% Commit local file changes to online repository   

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/20/09 use double quotes regardless of platform
% 07/13/09 commit message and filename needed double quotes for pc's
% 05/08/09 added quotes to handle filenames with spaces
% 05/05/09 original version
    
%% commit message

    commit_message = input('Enter commit message: ', 's');
    if isempty(commit_message)
        fprintf('Commit cancelled\n');
        return
    else
        commit_message = sprintf(' -m "%s"', commit_message);
    end
    
%% command

    if exist('file_or_dir_name', 'var')
        command_str = sprintf('commit "%s" %s', file_or_dir_name, commit_message);            
    else
        command_str = sprintf('commit %s', commit_message);
    end
    
%% execute command    
    svn_output = svn_command(command_str);
    disp(svn_output);
    
end