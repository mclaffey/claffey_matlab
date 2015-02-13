function [varargout] = svn_status(svn_file_or_dir, check_vs_online_repository)
% Return SVN status of working directory
%
% [svn_status_dataset] = svn_status
%
%   Returns a dataset of status for files in the current working directory and all subdirectories
%
% [svn_status_dataset] = svn_status(file_or_directory_name)
%
%   Runs command on the specified file or directory
%
% [svn_status_dataset] = svn_status(... [, check_vs_online_repository])
%
%   If check_vs_online_repository is true, runs 'status -u', which checks online repository for
%   updates. If omitted or false, status is on local working copy only.
%
%

% Copyright 2009-2010 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/18/10 misc cleaning
% 08/03/09 removed check svn.dir_is_svn to support the use of svn_file_or_dir argument
% 07/29/09 changed to local status only by default, 2nd argument for status versus online repository
% 07/23/09 catch and exit on authorization failure
% 07/20/09 double quotes around svn_file_or_dir
% 05/05/09 modified to use centralized svn_command
% 04/28/09 original version

%% intialize variables

    if ~exist('svn_file_or_dir', 'var'), svn_file_or_dir = ''; end;
    if ~exist('check_vs_online_repository', 'var'), check_vs_online_repository = false; end;

%% gather svn parameters
    
    svn = svn_parameters(svn_file_or_dir);
    
%% build the command based on argument options

    command_str = 'status ';    
    if exist('check_vs_online_repository', 'var') && check_vs_online_repository
        command_str = [command_str ' -u'];
    end
    if exist('svn_file_or_dir', 'var') && ~isempty(svn_file_or_dir)
        command_str = sprintf('%s "%s"', command_str, svn_file_or_dir);
    end 
    
%% run the svn status command    

    [svn_status_text] = svn_command(command_str);
    
%% if authorization failed
    if strcmpi(svn_status_text, 'Authorization failed')
        % the svn_command handles this error. exit so as to not try to parse the failure message
        return
    end
    
%% if no changes
    if isempty(svn_status_text)
        fprintf('No differences between local copy and online repository\n');
        return
    end
    
%% convert the command output to a dataset
    svn_status_dataset = svn_status_to_dataset(svn_status_text);
    
%% pack up output arguments, if requested

    if nargout == 0
        varargout = {};
        if isempty(svn_status_dataset)
            fprintf('No locally modified changes out of sync with repository\n');
        else
            % print the results
            command_window_line
            fprintf('SVN Repository: %s\n', svn.dir_url);
            svn_status_display_dataset(svn_status_dataset);
            command_window_line
            fprintf('SVN Repository: %s\n', svn.dir_url); % intentionally printed at beginning and end
            command_window_line
        end
    elseif nargout == 1
        varargout = {svn_status_dataset};
    elseif nargout == 2
        varargout = {svn_status_dataset, svn_status_text};
    else
        error('Can only have zero or one output arguments');
    end
    
end