function [vid] = vidz_files(video_file, subfolder_name, analysis_directory)
% Return a structure of vile locations for video analysis
%
% [vid] = vidz_files(video_file, subfolder_name, analysis_directory)

%   video_file - a file or directory to identify the source video
%   subfolder_name - used if multiple analyses are performed on a single video
%   analysis_directory - directory to contain the analysis files if
%       different than the directory containing the original video file

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 05/24/13 removed unused analysis_dir directory
% 08/03/10 adapted from soc1_files
    
%% data struture
%
%   vid.file.name               the file name without extension
%   vid.file.path               the directory containing the video file
%   vid.file.folder             a newly created working directory with the
%                                   same name as the movie to contain temp files
%   vid.file.original           the full name and path of the file
%   vid.file.metadata           a matlab variable file within the working
%                                   directory containing any user specified metadata
%
% the following fields are set by vidz_files_set_subfolder()
%   if a subfolder was specified they will reference the subfolder,
%   otherwise they reference the main working directory
%
%   vid.file.image              the filename for a snapshot image of the video 
%   vid.file.callibration_dir   a directory containing exported images
%                                   for the callibration process
%   vid.file.data_dir           a directory containing exported images
%                                   for analysis (these have likely been
%                                   cropped in time and area from the full
%                                   original file)
%   vid.file.analysis_video     the filename of a video created from the
%                                   images in data_dir
%   vid.file.analysis_video_uncompressed (a temp version of the above)
%   vid.file.matlab             the filename for a matlab variable
%                                   containing the saved video structure
%   vid.file.report             an html file with reported results


%% query for video file

    % if no arguments were specified, query for file with gui
    if ~exist('video_file', 'var')
        [original_video_file_name, video_path] = uigetfile('*.*');
        
    % if the first argument was a directory, query starting in that directory
    elseif isdir(video_file)
        [original_video_file_name, video_path] = uigetfile(fullfile(video_file, '*.*'));
        
    % if the first argument was a valid file, use that file
    else
        [video_path, original_video_file_name, org_video_extension] = fileparts(video_file);
        original_video_file_name = [original_video_file_name, org_video_extension];
    end
    
    % if no subfolder was specified, use a blank value
    if ~exist('subfolder_name', 'var')
        subfolder_name = '';
    end

%% build file paths

    % name of file without extenstion
    vid.file.name = change_extension(original_video_file_name, '');

    % path to original
    vid.file.path = video_path;
    
    % folder where all extracted/temporary files will live
    if ~exist('analysis_directory', 'var') || isempty(analysis_directory)
        vid.file.folder = fullfile(vid.file.path, vid.file.name);
    else
        if ~exist(analysis_directory, 'dir')
            error('analysis_directory must already exist: %s', analysis_directory)
        end
        vid.file.folder = fullfile(analysis_directory, vid.file.name);
    end        
    [mkdir_state, mkdir_message, mkdir_message_id] = mkdir(vid.file.folder);

    % original with full path
    vid.file.original = fullfile(video_path, original_video_file_name);
        
%% specify paths in the analysis subfolder

    vid = vidz_files_set_subfolder(vid, subfolder_name);
    
%% try loading existing data

    vid = vidz_load(vid, true);
    
%%    

end