function exp_admin_add_paths(calling_file)
% Add/move experiment directories to top of path
%
%   exp_admin_add_paths(calling_file)

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 10/13/09 added additional directories besides bin
    
    % add the experiment_framework/bin file
    experiment_framework_bin_dir = fileparts(mfilename('fullpath'));
    addpath(experiment_framework_bin_dir);
    
    % add the main experiment directory
    [experiment_dir, experiment_abbreviation, extension] = fileparts(calling_file);
    addpath(experiment_dir);
    
    % try adding additional directories
    directory_list = {'bin', 'analysis', 'analysis_subject', 'analysis_group'};
    for x = 1:length(directory_list)
        dir_path = fullfile(experiment_dir, directory_list{x});
        if exist(dir_path, 'dir'), addpath(dir_path); end;
    end

end