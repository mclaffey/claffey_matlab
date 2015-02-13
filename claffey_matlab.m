function claffey_matlab(command)
% A script for maintaining the library of claffey_matlab files
%
% 

% Copyright 2008-2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 12/31/10 added double quotes to svn info command
% 12/21/10 fixed error with this line: strfind(lower(computer), 'mac'))
%          removed install function
% 10/20/10 improved svn locating on mac platform
% 09/01/10 fixed update to always use guest login credentials
% 08/18/10 cleaned up login and svn localization in get_svn_data()
% 08/03/10 adapted to claffey_matlab
%          use claffey_guest account

% NOTE: there is no problem with using the claffey_matlab update
% command for updates that change the claffey_matlab.m file itself.
% Originally I thought there might be a problem with claffey_matlab.m
% calling an svn command that would overwrite itself, but this runs just
% fine. 

%% specify static url and login

    claffey_matlab_url = 'http://svn2.xp-dev.com/svn/claffey_matlab/trunk/';
    claffey_matlab_login = ' --username claffeyguest --password claffeyguest';

%% determine claffey_matlab directory based on path of this file

    [claffey_matlab_dir, this_file_name] = fileparts(mfilename('fullpath'));
        
%% determine command        
    
    if ~exist('command', 'var')
        menu_choices = { ...
            'Check My Status', ...
            'Get Lastest Update', ...
            'Update Matlab Path', ...
            'Download Sample Data', ...
            'Cancel' };
        
        % change the window style to normal (not docked)
        old_window_style = get(0,'DefaultFigureWindowStyle');
        set(0,'DefaultFigureWindowStyle', 'normal')

        % display menu
        command = menu('Which option?', menu_choices);

        % return the window style
        set(0,'DefaultFigureWindowStyle', old_window_style)

        if isempty(command), return; else command = menu_choices{command}; end;
    end
    command = lower(command);
    

    % execute commands
    switch command
        
%% Install from scratch
            
        case {'check my status', 'status'}
            
            % get svn info
            svn = get_svn_data;
            if ~svn.in_effect
                error('claffey_matlab has not been installed using svn, so status is not available')
            end
            
            % confirm path
            claffey_confirm_path('svn_status');
            
            % run the status command
            svn_status(claffey_matlab_dir);

        case {'get lastest update', 'update'}
            
            % get svn info
            svn = get_svn_data;
            if ~svn.in_effect
                error('claffey_matlab has not been installed using svn, so update is not available')
            end
            
            % run the update
            svn_command = [svn.path 'svn update "' claffey_matlab_dir '" ' claffey_matlab_login];
            [status, result] = system(svn_command);
            if status ~=0
                error('SVN error: %s', result')
            else
                fprintf('SVN Update successful. Results:\n%s', result);
            end
            
        case {'update matlab path', 'path'}
            if exist('genpath_no_svn', 'file')
                new_path = genpath_no_svn(claffey_matlab_dir);
            elseif exist([claffey_matlab_dir '/svn_matlab/genpath_no_svn.m'], 'file')
                old_dir = pwd;
                cd([claffey_matlab_dir '/svn_matlab']);
                new_path = genpath_no_svn(claffey_matlab_dir);
                cd(old_dir);
            else
                error('claffey_matlab does not appear to be installed')
            end
            addpath(new_path);
            savepath;
            fprintf('Path updated to include all claffey_matlab subdirectories\n');
            
        case {'download sample data', 'data'}
            
            if ~input_yesno('Download sample data to current directory?'), return; end;

            svn = get_svn_data;
            
            % remove /trunk from url
            sample_data_url = fileparts(fileparts(svn.url));
            
            % add sample_Data directory
            sample_data_url = fullfile(sample_data_url, 'sample_data');
            
            % run the update
            svn_command = [svn.path 'svn checkout ' sample_data_url ' . ' svn.login];
            [status, result] = system(svn_command);
            
            if status ~=0
                error('SVN error: %s', result')
            else
                fprintf('SVN Update successful. Results:\n%s', result);
            end
            
            % add to path
            try
                new_path = genpath_no_svn(pwd);
                addpath(new_path);
                savepath;
            catch
                warning('Failed to add sample data diretories to path\n'); %#ok<WNTAG>
            end

            
        case 'cancel'
            % do nothing
            
    end

    
    
    
%% Helper function to gather necessary data for svn commands

    function [svn] = get_svn_data
        svn = struct();
        
        % path
        svn.path = '';
        svn.bin_found = false;
        
        % First try finding svn using claffey_matlab's GetSubversion_better
        if exist('GetSubversionPath_better', 'file')
            try %#ok<TRYNC>
                svn.path = GetSubversionPath_better();
                if ~isempty(svn.path), svn.bin_found = true; end;
            end
        end
        
        % If no luck, try to find svn using PsychToolbox's function
        if ~svn.bin_found && exist('GetSubversionPath', 'file')
            svn.path = GetSubversionPath;
            if ~isempty(svn.path), svn.bin_found = true; end;
        end
         
        % Otherwise, look in default directories
        if ~svn.bin_found
            % if it's a mac
            if any(strfind(lower(computer), 'mac')) | any(strfind(lower(computer), 'apple')) %#ok<OR2>
                [status, result] = system('which svn');
                if status==0
                    svn.path=result;
                    svn.bin_found = true;
                elseif exist('/usr/local/bin/svn','file')
                    svn.path='/usr/local/bin/';
                    svn.bin_found = true;
                elseif exist('/usr/bin/svn', 'file')
                    svn.path = '/usr/bin/svn';
                    svn.bin_found = true;
                end
            else
                if exist('c:\Program Files\Subversion\bin\svn.exe', 'file')
                    svn.path = 'c:\"Program Files"\Subversion\bin\';
                    svn.bin_found = true;
                end
            end 
        end
        
        % If svn still isn't found, throw error
        if ~svn.bin_found
            error('Could not find the svn bin file (the svn application) in any of the typical locations. Make sure svn is installed');
        end
        
        % other parameters
        svn.url = claffey_matlab_url;
        svn.login = claffey_matlab_login;

        
        % check whether svn is in effect for the claffey_matlab directory
        svn.in_effect = false;
        svn.info = '';
        if svn.bin_found
            svn_command = [svn.path 'svn info "' claffey_matlab_dir '"'];
            status = [];
            try %#ok<TRYNC>
                [status, info_result] = system(svn_command);
                svn.info = info_result;
            end
            if ~isempty(status) && status == 0, svn.in_effect = true; end;
        end
        
        % report problems if svn is missing and cancel install
        if exist('throw_error', 'var') && throw_error
            svn.is_ok = false;
            if isempty(svn.path)
                fprintf('This routine uses a separate program called Subversion (svn) to install.\n');
                fprintf('You do not appear to have svn installed.\n')
                fprintf('Instructions for getting svn are <a href="http://subversion.tigris.org/getting.html">here</a>\n');
                fprintf('Subversion is required by Psychtoolbox, so you could follow <a href="http://psychtoolbox.org/wikka.php?wakka=PsychtoolboxDownload">their instructions<a/> as well.\n')
                fprintf('Installation cancelled.');
            end
        end
    end

    % confirm that file is in path
    function claffey_confirm_path(file_name)
        if ~exist(file_name, 'file')
            error('claffey_matlab file %s is not in path. Either your version of claffey_matlab\nis incomplete or you need to run the Update Matlab Path command', file_name);
        end
    end
 

    
end