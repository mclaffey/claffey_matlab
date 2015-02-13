function [varargout] = svn_login(varargin)
% Prompt user and cache svn login credentials
%
% svn_login
%
%   When called from the command line without any assignment, automatically
%   reprompts for username and password
%
% [username, password] = svn_login
%
%   To get the current username and password (or default if user has not yet
%   specified), call with two outputs and no input arguments
%
% [username, password] = svn_login(REPROMPT)
%
%   To force svn_login to reprompt the user, pass a single true argument
%
% ... = svn_login(NEW_USERNAME, NEW_PASSWORD)
%
%   To change the username and password without prompting the user, pass two strings
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/03/10 adapted to claffeyguest
% 05/09/09 allow change of username and password without prompting
% 05/05/09 original version

    persistent username password
    
    % if called without any arguments
    if nargin == 0
        % if called without any outputs, probably from the command line,
        % prompt the user
        if nargout == 0
            reprompt = true;
        % if called with outputs, return the current or default values
        else
            reprompt = false;
        end;
        
    % if called with one input argument, this is the REPROMPT form
    elseif nargin == 1
        reprompt = logical(varargin{1});
        
    % if called with two input arguments, this is the new username/password form
    elseif nargin == 2
        assert(ischar(varargin{1}) && ischar(varargin{2}), 'Username and password arguments must be stings');
        username = varargin{1};
        password = varargin{2};
        reprompt = false;
       
    else
        error('Wrong number of input arguments');
    end

%% start with claffey_guest default    
    
    if isempty(username)
        username = 'claffeyguest';
        password = 'claffeyguest';
    end   
    
%% if requested, prompt user for login credentials
    
    if reprompt
        [new_username, new_password] = logindlg('SVN Login', 'Enter xp-dev login information (leave blank if you have none)');
        if ~isempty(new_username)
            username = new_username;
            password = new_password;
        end
    end
    
%% return the arguments    
    
    if nargout == 2
        varargout = {username, password};
    end
    
end

    