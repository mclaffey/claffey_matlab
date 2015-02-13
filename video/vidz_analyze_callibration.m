function [vid] = vidz_analyze_callibration(vid)
    
%% import the callibration images

    cal_files = dir(fullfile(vid.file.callibration_dir, '*.png'));
    for x = 1:length(cal_files)
        cal_file = fullfile(vid.file.callibration_dir, cal_files(x).name);
        cal_img = rgb2gray(imread(cal_file));
        if x == 1
            cal_vid = nan([size(cal_img), length(cal_files)]);
        end

        cal_vid(:,:,x) = cal_img;
    end

%% save basic parameters    
    
    vid.callibration.image = mean(cal_vid,3);
    vid.callibration.dims = size(vid.callibration.image);
    vid.callibration.video = cal_vid;

%% analyze intensity values

    vid.callibration.range.min = min(cal_vid,[],3)-45;
    vid.callibration.range.max = max(cal_vid,[],3)+45;
    
end

