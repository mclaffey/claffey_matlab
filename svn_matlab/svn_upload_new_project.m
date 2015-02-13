function svn_upload_new_project(project_name)
% Upload a non-SVN local directory to an online repository
%
% 10/13/09 moved project list to svn_project_urls
% 07/20/09 double quotes around directory
% 06/05/09 original version

%% get the project url

    if ~exist('project_name', 'var')
        project_url = svn_project_urls();
        if isempty(project_url), fprintf('Cancelled.\n'); return; end;
    else
        project_url = svn_project_urls(project_name);
    end

%% execute svn    
    
    commit_message = 'initial import';
    svn_output = svn_command('import %s -m "%s"', project_url, commit_message);
    disp(svn_output);
    
    fprintf('The local copy is not a working copy - suggest checking out from svn now\n');
    
end