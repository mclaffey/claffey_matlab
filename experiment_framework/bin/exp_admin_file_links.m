function [files] = exp_admin_file_links(edata)
% List files in the local directory with edit links

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/27/09 modified to take edata as input
    
    local_exp_dir = fullfile(edata.files.base_dir, 'bin');
    
    files = dir([local_exp_dir '*.m']);
    files = {files.name}';
    files = strtok(files, '.');
    files = dataset({ files, 'name' });
    
    files.framework = strncmpi(files.name, 'exp_', 4);
    [files.prefix, remainder] = strtok(files.name, '_');
    [files.group, files.short_name] = strtok(remainder, '_');
    
    % fix up specific files
    files = dataset_nominalize_fields(files, {'name', 'group', 'prefix', 'short_name'});
    
    files.group(files.name=='exp_trial') = 'trial';
    files.group(files.name=='exp_run') = 'trial';
    files.group(files.name=='exp_reset') = 'trial';
    files.group(files.name=='exp_stop') = 'trial';
    files.group(files.name=='exp_initialize') = 'initialize';
    
%% show links to standard files

    command_window_line
    fprintf('Running: ');
    fprintf('%s ', ...
        link_text('edit', [local_exp_dir 'exp_run.m'], 'run'), ...
        link_text('edit', [local_exp_dir 'exp_trial.m'], 'trial'), ...
        link_text('edit', [local_exp_dir 'exp_trial_get_response.m'], 'get'), ...
        link_text('edit', [local_exp_dir 'exp_trial_check_response.m'], 'check'), ...
        link_text('edit', [local_exp_dir 'exp_trial_feedback.m'], 'feedback'));
    fprintf('\n');
    fprintf('Initializing: ');
    fprintf('%s ', ...
        link_text('edit', [local_exp_dir 'exp_initialize.m'], 'initialize'), ...
        link_text('edit', [local_exp_dir 'exp_data_generate.m'], 'trial_data'), ...
        link_text('edit', [local_exp_dir 'exp_initialize_edata.m'], 'edata'), ...
        link_text('edit', [local_exp_dir 'exp_initialize_audio.m'], 'audio'), ...
        link_text('edit', [local_exp_dir 'exp_initialize_display.m'], 'display'), ...
        link_text('edit', [local_exp_dir 'exp_initialize_inputs.m'], 'inputs'));
    fprintf('\n');

%% show links to custom files

    custom_files = files(files.framework==false, :);
    custom_groups = unique(custom_files.group);
    for group_num = 1:length(custom_groups)
        fprintf('%s: ', char(custom_groups(group_num)));
        group_files = custom_files(custom_files.group==custom_groups(group_num), :);
        for x = 1:size(group_files,1)
            short_name = char(group_files.short_name(x));
            if strcmpi(short_name(1),'_'), short_name = short_name(2:end); end;
            if strcmpi(short_name, '<undefined>'), short_name = char(group_files.group(x)); end;
            fprintf('%s ', link_text('edit', [local_exp_dir char(group_files.name(x))], short_name))
        end
        fprintf('\n');
    end
    
end