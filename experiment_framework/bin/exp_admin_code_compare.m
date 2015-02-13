%% get local files
local_bin = pwd;
local_files = dir('*.m')
local_file_count = length(local_files);
%% get experiment framework directory for comparison
exp_framework_dir = uigetdir()

%% run diff on every local file
local_only_list = {};
no_diff_list = {};
yes_diff_list = {};
diff_details = {};

for x = 1:local_file_count
    file_name = local_files(x).name;
    local_file = fullfile(local_bin, file_name);
    ef_file = fullfile(exp_framework_dir, file_name);
    
    if ~exist(ef_file, 'file')
        local_only_list{end+1,1} = file_name;
    else
        diff_command = sprintf('diff "%s" "%s"', local_file, ef_file);
        [res, diff_result] = system(diff_command);
        if isempty(diff_result)
            no_diff_list{end+1, 1} = file_name;
        else
            yes_diff_list{end+1, 1} = file_name;
            diff_details{end+1,1} = diff_result;
        end
    end
            
end    

%%
clc
command

for x = 1:local_file_count
    command_window_line
    fprintf('File = %s\n\n', local_files(x).name);
    disp(diff_output{x})
end