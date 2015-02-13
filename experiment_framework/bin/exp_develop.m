function exp_develop
% Provides options to copy files from framework to local directory
%
%   exp_develop()  % no arguments, no outputs
%
% Copyright Mike Claffey 2009-2011 (mclaffey[]ucsd.edu)
%
% 01/20/11 distinguish files that already have a local copy
% 08/01/09 original version
    
    % get the path of the experiment framework
    exp_framework_dir = fileparts(mfilename('fullpath'));
    % find all files in the framework that start with exp
    exp_framework_files = dir(sprintf('%s%sexp*.m', exp_framework_dir, filesep));
    
%% display a list of files in the experiment framework with links to copy locally

    for x = 1:length(exp_framework_files)
        file_name = exp_framework_files(x).name;
        file_name_with_ef_path = fullfile(exp_framework_dir, file_name);
        file_name_with_local_path = fullfile(pwd, file_name);
        
        view_original_command = sprintf('edit %s;', file_name_with_ef_path);
        view_local_command = sprintf('edit %s;', file_name_with_local_path);
        copy_command = sprintf('copyfile ''%s'' ''%s'';fprintf(''File copied.\\n'');edit %s;', ...
            file_name_with_ef_path, pwd, file_name_with_local_path);
        
        % determine if local copy already exists
        local_exists_bln = exist(file_name_with_local_path, 'file');
        
        if local_exists_bln
            fprintf('local  %s (%s %s)\n', ...
                file_name, ...
                link_text('matlab', view_original_command, 'view original'), ...
                link_text('matlab', view_local_command, 'view local'));
        else
            fprintf('       %s (%s %s)\n', ...
                file_name, ...
                link_text('matlab', view_original_command, 'view original'), ...
                link_text('matlab', copy_command, 'copy to local'));
        end            
        
    end
    
end