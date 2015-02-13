function svn_import(file_or_dir_name)
% Import a local file to svn repository

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/05/09 original version
    
%% determine path to add

    if exist('file_or_dir_name', 'var')

        % determine if we are importing a whole directory (vs. a file)
        if exist(file_or_dir_name, 'dir')
            importing_directory = true;
            file_path = file_or_dir_name;
        else
            importing_directory = false;
            [file_path, file_name, file_ext] = fileparts(file_or_dir_name);
            file_name = [file_name '.' file_ext];
        end

    else
        
        file_or_dir_name = input('Type path to add (type FILE or DIR for dialogue boxes): ', 's');
        if isempty(file_or_dir_name), return; end;
        if strcmpi(file_or_dir_name, 'file')
            [file_name, file_path] = uigetfile('Select file to add to SVN control');
            file_or_dir_name = [file_path file_name];
        end
        if strcmpi(file_or_dir_name, 'dir'), file_or_dir_name = uigetdir('Select directory to add to SVN control'); end;

        % determine if we are importing a whole directory (vs. a file)
        importing_directory = exist(file_or_dir_name, 'dir');

    end
    

%% commit message

    commit_message = input('Enter commit message: ', 's');
    if isempty(commit_message)
        fprintf('Commit cancelled\n');
        return
    end
    
%% command

    svn = svn_parameters;

    if importing_directory
        error('no yet implemented - but should be a quick fix')
    else
        destination_url = [svn.dir_url filesep file_name];
        command_str = sprintf('import ''%s'' %s -m ''%s''', file_or_dir_name, destination_url, commit_message);
    end
    
    [svn_output] = svn_command(command_str);
    disp(svn_output);
    
end