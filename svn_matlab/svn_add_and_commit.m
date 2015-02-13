function svn_add_and_commit(file_or_dir_name)
% Add a local file to svn control and instantly commit

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/14/09 original version
    
%% determine path to add

    if ~exist('file_or_dir_name', 'var')
        file_or_dir_name = input('Type path to add (type FILE or DIR for dialogue boxes): ', 's');
        if isempty(file_or_dir_name), return; end;
        if strcmpi(file_or_dir_name, 'file'), file_or_dir_name = uigetfile('Select file to add to SVN control'); end;
        if strcmpi(file_or_dir_name, 'dir'), file_or_dir_name = uigetdir('Select directory to add to SVN control'); end;
    end
    
%% add and commit

    svn_add(file_or_dir_name);
    svn_commit(file_or_dir_name);
    
end