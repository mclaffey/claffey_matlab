function [svn_output] = svn_command(varargin)
% Issue a command through svn and capture output
%
% [svn_output] = svn_command(command_str)
%
%   snv_command can take multiple arguments in the format passed to sprintf()
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/23/09 authorization failure now has a message with link to svn_login instead of error
% 05/05/09 original version
    
    % pass input arguments to sprintf for formatting, if necessary
    if nargin == 1
        command_str = varargin{1};
    else
        command_str = sprintf(varargin{:});
    end

    % call svn_parameters, mainly to get the local path the svn file
    svn = svn_parameters();
    
    % display full commmand
    fprintf('Running: svn %s --username %s\n', command_str, svn.username);
    
    % determine specific svn command
    specific_svn_command = strtok(command_str, ' ');
    
    % append credentials to command (not for the add command)
    if ~strcmpi(specific_svn_command, 'add')
        command_str = [command_str ' ' svn.credentials];
    end
    
    % issue command and capture output
    [result, svn_output] = system([svn.path ' ' command_str]);
    
    % handle errors
    if result ~= 0
        if strfind(svn_output, '403 Forbidden')
            fprintf('Command failed because username %s does not have access. Run %s and try again\n', ...
                svn.username, ...
                link_text('matlab', 'svn_login'));
            svn_output = 'Authorization failed';
        else
            error('The following was returned by svn:\n%s', svn_output)
        end
    end

end