function [metric_struct] = vidz_helper_get_metric_struct(vid, data_by_frame)
% Given a value per frame, return a structure with mean, by bin and by frame values
%
%   [metric_struct] = vidz_helper_get_metric_struct(vid, data_by_frame)

%% Create structure

    metric_struct = struct;
    metric_struct.mean = nanmean(data_by_frame);
    metric_struct.by_bin = get_bin_means(data_by_frame);
    metric_struct.by_frame = data_by_frame;
        
%% helper function for calculating bin means

    function [bin_means] = get_bin_means(data_by_frame)
        
        % initialize variables
        frames_per_bin = vid.params.analysis_bin_size_in_secs * vid.params.data_extract_fps;
        frame_count = length(data_by_frame);
        bin_count = ceil(frame_count / frames_per_bin);
        padding_needed = (bin_count * frames_per_bin) - frame_count;
        
        % padded data
        padded_data = vertcat(data_by_frame, repmat(NaN, padding_needed, 1));
        
        % reshape data to have one column per bin
        reshaped_data = reshape(padded_data, frames_per_bin, bin_count);
        
        % calculate column/bin means
        bin_means = nanmean(reshaped_data, 1);
        
        % the result of mean() is a row vector, transpose to column
        bin_means = bin_means';
        
    end
%%

end