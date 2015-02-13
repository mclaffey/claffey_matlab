function svn_add(file_or_dir_name)
% Add a local file to svn control

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/20/09 made double quote regardless of platform
% 07/13/09 added double quotes around file name for pc version
% 05/05/09 initial version
    
%% determine path to add

    if ~exist('file_or_dir_name', 'var')
        file_or_dir_name = input('Type path to add (type FILE or DIR for dialogue boxes): ', 's');
        if isempty(file_or_dir_name), return; end;
        if strcmpi(file_or_dir_name, 'file'), file_or_dir_name = uigetfile('Select file to add to SVN control'); end;
        if strcmpi(file_or_dir_name, 'dir'), file_or_dir_name = uigetdir('Select directory to add to SVN control'); end;
    end
    
%% command

    command_str = sprintf('add "%s"', file_or_dir_name);        
    [svn_output] = svn_command(command_str);
    disp(svn_output);
    
end