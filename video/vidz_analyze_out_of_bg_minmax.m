function [vid] = vidz_analyze_out_of_bg_minmax(vid)
% Identify all values in the data video that are outside the callibration min/max
%
%   [vid_out_of_minmax] = vidz_analyze_out_of_bg_minmax(vid)

    min_vid = repmat(vid.callibration.range.min, [1 1 vid.data.frames]);
    max_vid = repmat(vid.callibration.range.max, [1 1 vid.data.frames]);    

    vid.data.out_of_minmax = (vid.data.video < min_vid) | (vid.data.video > max_vid);
    
end