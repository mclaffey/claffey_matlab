function [svn] = svn_parameters(svn_dir)
% Return information on the svn repository in the current directory (if any)

% Copyright 2009-2010 Mike Claffey (mclaffey[]ucsd.edu)
%
% 08/18/10 minor language cleanup
% 07/30/09 changed repository urls to stop using SSL
% 05/14/09 use GetSubversionPath_better function
% 05/09/09 original version

%% If no directory was specified, use the current directory

    if ~exist('svn_dir', 'var') || isempty(svn_dir), svn_dir = pwd; end

%% gather svn parameters

    svn.path = [GetSubversionPath_better 'svn'];
    [svn.username, svn.password] = svn_login();
    svn.credentials = sprintf('--username %s --password %s', svn.username, svn.password);    
    
%% repository info for current directory

    svn_command = sprintf('%s info ''%s'' %s', svn.path, svn_dir, svn.credentials);
    [result, info_text] = system(svn_command);
    if result == 0
        svn.dir_is_svn = true;
        info_text = str_block2cell(info_text);
        svn.dir_url = info_text{2}(6:end);
    else
        svn.dir_is_svn = false;
        svn.dir_url = '';
    end
    
end