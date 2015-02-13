function [vid] = vidz_files_set_subfolder(vid, subfolder_name)
% specifies a subfolder to use within the working directory
%
% useful if multiple analyses are done on the same video (e.g. training and testing)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 08/03/10 adapted from soc1

%%
    
    vid.file.subfolder_name = subfolder_name;

%%    if no subfolder is specified, use the main working folder

    if isempty(subfolder_name)
        vid.file.analysis_folder = vid.file.folder;
    else
        vid.file.analysis_folder = fullfile(vid.file.folder, subfolder_name);
    end

%% 

    % image of original
    vid.file.image = fullfile(vid.file.analysis_folder, 'image.png');

    % directory of images for bg callibration
    vid.file.callibration_dir = fullfile(vid.file.analysis_folder, 'callibration');
    [mkdir_state, mkdir_message, mkdir_message_id] = mkdir(vid.file.callibration_dir);

    % directory of images for data
    vid.file.data_dir = fullfile(vid.file.analysis_folder, 'data');
    [mkdir_state, mkdir_message, mkdir_message_id] = mkdir(vid.file.data_dir);

    % analysis video
    vid.file.analysis_video = fullfile(vid.file.analysis_folder, 'analysis.avi');
    vid.file.analysis_video_uncompressed = fullfile(vid.file.analysis_folder, 'analysis_uncompressed.avi');
    vid.file.analysis_dir = fullfile(vid.file.analysis_folder, 'analysis');
    [mkdir_state, mkdir_message, mkdir_message_id] = mkdir(vid.file.analysis_dir);
    
    % matlab data file
    vid.file.matlab = fullfile(vid.file.analysis_folder, 'vid_matlab.mat');
    
    % html report
    report_folder = fullfile(vid.file.analysis_folder, 'report');
    [mkdir_state, mkdir_message, mkdir_message_id] = mkdir(report_folder);
    vid.file.report = fullfile(report_folder, 'report.html');

end