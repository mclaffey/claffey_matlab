function [file_list] = exp_files(edata)
% Generate relevant file paths for this experiment

% 10/12/09 added error for running the experiment_framework version

    file_list.exp_abbr = edata.experiment_abbreviation;
    
%% determine base directory for experiment

    % get the directory for this file, which should be in a /bin directory
    base_dir = fileparts(mfilename('fullpath')); 
    
    % move up one more directory to the main experiment directory
    base_dir = fileparts(base_dir);
    
%% throw error is using version from experiment framework
    
    % this section can be deleted once copied into a local directory)
    [junk, base_dir_name] = fileparts(base_dir);
    if strcmpi(base_dir_name, 'experiment_framework')
        error(sprintf('You tried to executed exp_files.m in the experiment framework.\nCopy this file to your local experiment bin folder.')); %#ok<SPERR>
    end

%% shared file locations

    file_list.base_dir = base_dir;

    file_list.data_dir = [base_dir filesep 'data'];

%% subject-related file locations
    
    % subjects each have their own folder: data/s# (where # is the subject number)
    file_list.subject_dir = enum_file('data/s%d/', base_dir);
    
    % the experiment data is saved in a behavioral file with:
    %   experiment abbreviation, subject number, 'behav', and the date and time
    file_list.behav = enum_file(sprintf('data/s%%d/%s_s%%d_behav_#DATE#_#TIME#.mat', file_list.exp_abbr), base_dir);
    
    % any analysis is saved to a subject analysis file, to avoid corrupting the original behavioral data
    file_list.analysis = enum_file(sprintf('data/s%%d/%s_s%%d_analysis.mat', file_list.exp_abbr), base_dir);

    % analysis results are saved to an html file
    file_list.html = enum_file(sprintf('data/s%%d/html_report/%s_s%%d.html', file_list.exp_abbr), base_dir);

end