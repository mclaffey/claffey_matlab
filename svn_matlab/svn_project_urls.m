function [project_url] = svn_project_urls(project_name)
% Return the url of a project using a gui menu
%
%   [project_url] = svn_project_urls()
%
%       Display project list
%
%   [project_url] = svn_project_urls(project_name)
%
%       Convert a project name in the list to a url
%

% Copyright 2009-2010 Mike Claffey (mclaffey[]ucsd.edu)
%
% 05/25/13 added 'video tracking example' to project list
% 08/03/10 generalized file name
%          project list always comes up as a floating (non-docked) window
% 10/13/09 cleaned up to use full path (xp switched back from svn2 to svn)


    projects = { ...
        'Eriksen Flanker',              'http://svn2.xp-dev.com/svn/mclaffey-eriksen/trunk'; ...
        'HandFoot',                     'http://svn2.xp-dev.com/svn/mclaffey-handfoot/trunk'; ...
        'Cued Task Switching',          'http://svn2.xp-dev.com/svn/mclaffey-cuedtaskswitch/trunk'; ...
        'FTS Training',                 'http://svn2.xp-dev.com/svn/mclaffey-ftstraining/trunk'; ...
        'FTS fMRI',                     'http://svn2.xp-dev.com/svn/mclaffey-fts5fmri/trunk'; ...
        'FTS Good sICI',                'http://svn2.xp-dev.com/svn/mclaffey-fts7goodsici/trunk'; ...
        'FTS Kids',                     'http://svn2.xp-dev.com/svn/mclaffey-fts9kids/trunk'; ...
        'Maybe Stop No Stop',           'http://svn2.xp-dev.com/svn/mclaffey-msns/trunk'; ...
        'Slater Hammel One finger TMS', 'http://svn.xp-dev.com/svn/bar2singletms/trunk'; ...
        'Slater Hammel Two finger TMS', 'http://svn2.xp-dev.com/svn/mclaffey-bar1simple/trunk'; ...
        'Handgrip',                     'http://svn2.xp-dev.com/svn/mclaffey-handgrip/trunk'; ...
        'MEP Outcome 1 - Relax',        'http://svn.xp-dev.com/svn/mepoutcome1/trunk'; ...
        'Obj Rec 2 - Aleena',           'http://svn2.xp-dev.com/svn/orec2_aleena/trunk'; ...
        'Gum1 - Gant',                  'http://svn3.xp-dev.com/svn/gum1/trunk'; ...
        'Stroop2 - Gant',               'http://svn3.xp-dev.com/svn/stroop2/trunk'; ...
        'Eyes1 - Thomson',              'http://svn3.xp-dev.com/svn/eyes1/trunk'; ...
        'Video Tracking Examples',      'http://xp-dev.com/svn/video_tracking/trunk'; ...
        };
    
%% convert name to url    
    
    if exist('project_name', 'var') && ~isempty(project_name)
        project_number = find(strcmpi(project_name, projects(:,1)));
        if isempty(project_number)
            error('Couldn''t find project of that name');
        else
            project_url = projects{project_number, 2};
        end
        
% select project from list

    else
        
        % append manual and cancel option to menu
        project_list = vertcat(projects(:,1), {'Manually type...';'Cancel'});
        manual_option_number = length(project_list) - 1;
        cancel_option_number = length(project_list);
        
        % query for menu choice
        old_docking = get(0,'DefaultFigureWindowStyle');
        set(0,'DefaultFigureWindowStyle','normal');
        project_num = menu('Which experiment?', project_list);
        set(0,'DefaultFigureWindowStyle',old_docking);
        
        % cancel option
        if project_num == cancel_option_number
            project_url = '';
            return
        % manual option
        elseif project_num == manual_option_number
            project_url = input('Type the svn url: ', 's');
        % a project
        else
            project_url = projects{project_num, 2};
        end
    end
    
end