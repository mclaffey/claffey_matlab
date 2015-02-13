function [svn_output] = svn_download(project_name)
% Download a project/experiment from a svn server
%
% [svn_output] = svn_download
%
%   Displays a menu for selecting projects
%
% [svn_output] = svn_download(project_name)

% Copyright 2009-2010 Mike Claffey (mclaffey[]ucsd.edu)
%
% 12/20/10 properly handle if user clicks CANCEL in menu
% 08/03/10 renamed projects file to svn_project_urls
% 07/20/09 wrap destination_dir in double quotes
% 05/08/09 got rid of credentials, svn_command handles this
% 04/28/09 original version
    
    destination_dir = pwd;
    if exist('project_name', 'var')
        project_url = svn_project_urls(project_name);
    else
        project_url = svn_project_urls;
        % if the user cancelled, exit
        if isempty(project_url), exit; end;
    end


    [svn_output] = svn_command([' checkout ' project_url ' "' destination_dir '"']);
    
end