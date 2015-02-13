function [vid] = vidz_analyze_find_nonbg_object(vid)
% Select the target object based on background data
%
%   [vid] = vidz_analyze_find_nonbg_object(vid)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 09/02/10 added candidate_pixels based on bad_pixels
% 09/01/10 fixed bug if no object was detected

    % feedback
    vidz_feedback(vid, 'Analyzing for object location...00\n');
    
%% determine candidate pixels

    [vid] = vidz_analyze_candidate_pixels(vid);

%% find all objects

    % i might want to consider using bwlabeln in the future

    all_objects_video = zeros(size(vid.data.candidate_pixels));
    object_props = cell(vid.data.frames, 1);

    for frame_num = 1:vid.data.frames
        vidz_feedback(vid, sprintf('\b\b\b%02d\n', floor(frame_num / vid.data.frames * 100)));
        object_image = bwlabel(vid.data.candidate_pixels(:,:,frame_num));
        all_objects_video(:,:,frame_num) = object_image;
        object_props{frame_num} = regionprops(object_image, {'area', 'centroid', 'solidity'});
    end

%% perform first pass by selecting the largest object

    selected_object_indices = nan(frame_num, 1);
    
    for frame_num = 1:vid.data.frames
        this_object_props = object_props{frame_num};
        
        % as long as 1 object was found, get its index. otherwise leave
        % selected_object_indices(frame_num) as NaN
        if ~isempty(this_object_props)
            [junk_sorted_areas, descending_area_indices] = sort([this_object_props.Area], 'descend');
            largest_object = descending_area_indices(1);
            selected_object_indices(frame_num) = largest_object;
        end
    end
    
%% build a movie of the selected object

    selected_object_video = nan(size(all_objects_video));

    for frame_num = 1:vid.data.frames
        
        selected_object_index = selected_object_indices(frame_num);
        all_object_image = all_objects_video(:,:,frame_num);
        % if object was found
        if ~isnan(selected_object_index)
            selected_object_image = double(all_object_image == selected_object_index);
        % if no object was found
        else
            selected_object_image = all_object_image; % all zeros
        end
        selected_object_video(:,:,frame_num) = selected_object_image;
    end

    vid.object.video = selected_object_video;

    
%% compile properties of selected object

    nan_props = struct;
    nan_props.Area = NaN;
    nan_props.Centroid = [NaN NaN];
    nan_props.Solidity = NaN;

    for frame_num = 1:vid.data.frames
        frame_object_props = object_props{frame_num};
        selected_object_index = selected_object_indices(frame_num);
        % if object was found
        if ~isnan(selected_object_index)
            selected_object_props = frame_object_props(selected_object_index);
        % if no object was found
        else
            selected_object_props = nan_props;
        end
        if frame_num == 1              
            vid.object.props = selected_object_props;
        else
            vid.object.props(frame_num) = selected_object_props;
        end            
    end

%%    
    
    vidz_feedback(vid, '\b\b\b\bDONE\n');

    
    
%%
end