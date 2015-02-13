function [vid] = vidz_analyze_exclude_pixels(vid, select_frame)
% Mark pixels as bad so they are never considered to be object
%
%   [vid] = vidz_analyze_exclude_pixels(vid, [select_frame])

%% update candidate pixels

    [vid] = vidz_analyze_candidate_pixels(vid);
    
%% determine selection frame if none was specified

    % if none was specified, let user review movie
    if ~exist('select_frame', 'var') || isempty(select_frame)
        reviewed_vid = review_matrix_video(vid.data.candidate_pixels);
        select_frame = reviewed_vid.current_frame; 
    end

%% identify frames with bad pixels

    frame_data = vid.data.candidate_pixels(:, :, select_frame);

%% click on that region

    f = figure;
    imagesc(frame_data);
    axis image
    
    fprintf('Click on offending region...');
    select_coords = ginput(1);
    fprintf('\n');
    
%% determine the region

    selected_region = bwselect(frame_data, select_coords(1), select_coords(2), 8);
    
    % display region
    imagesc(selected_region);
    
    input('Figure shows excluded region. Press ENTER to continue ', 's');
    
%% specify the frame range where those are bad pixels

%% cancel out pixels from candidate_pixels

    new_excluded_pixels = repmat(selected_region, [1 1 vid.data.frames]); 
    vid.data.excluded_pixels = vid.data.excluded_pixels | new_excluded_pixels;
    
%%
    close(f);
%%

end
    