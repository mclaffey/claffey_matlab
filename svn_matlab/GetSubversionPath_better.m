function [svn] = GetSubversionPath_better()
% A more robust method of getting svn path than PTB's GetSubversionPath
%
% Copyright 2009-2010 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/25/13 added better location for PCs
% 06/08/11 made /opt/local/bin the preferred path to use MacPorts installation
% 12/31/10 fixed error in line with: strfind(lower(computer), 'mac'))
% 08/18/10 cleaned up, fixed an error if psychtoolbox was not installed
% 05/14/09 original version

%% TEMPORARY FIX, REMOVE THIS BEFORE COMMITTING

%     commented out on may 24, 2012
%     svn = '/opt/local/bin/';
%     return

%%



    svn = '';

%% if the psychtoolbox function exists and works, use that

    if exist('GetSubversionPath', 'file')
        svn = GetSubversionPath;
        if ~isempty(svn)
            return
        end
    end
    
%% for a mac, try some things

    if ~isempty(strfind(lower(computer), 'mac')) || ~isempty(strfind(lower(computer), 'apple'))
        % check for /opt/local/bin, which would be a macports location
        if exist('/opt/local/bin/svn','file')
            svn='/opt/local/bin/';
            return
        elseif exist('/usr/local/bin/svn','file')
            svn='/usr/local/bin/';
            return
        else
            [status, result] = system('which svn');
            if status==0
                svn = [fileparts(result) filesep];
                return;
            end
        end
    end
    
%% otherwise (assuming PC), try some things

    % use the where command in case svn is in the path
    [status, message] = system('where svn');
    if status == 0
        % remove the newline character and 'svn.exe' from path
        svn = ['"' message(1:length(message)-8) '"'];
        return;
    end

    % try some default locations
    if exist('c:\Program Files\Subversion\bin\svn.exe', 'file')
        svn = '"c:\Program Files\Subversion\bin\"';
        return
    end
    
    % try some default locations
    if exist('c:\Program Files\svn\bin\svn.exe', 'file')
        svn = '"c:\Program Files"\svn\bin\"';
        return
    end
    
    % try some default locations
    if exist('c:\Program Files\Subversion\bin\svn.exe', 'file')
        svn = 'c:\"Program Files"\Subversion\bin\';
        return
    end
    
    
    
end

