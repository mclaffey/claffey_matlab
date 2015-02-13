function [vid] = vidz_review(vid)
% Interactive review of analysis results

% 04/11/13 added capability to review freezing

%% initialize variables

    review_mode = '';
    content = [];
    content.current_frame = 1;
    do_review = false;

%% prompt user for mode

    while ~strcmpi(review_mode, 'done')

        review_mode = menu2('Select option', {...
            'Tracking Properties', ...
            'Distance', ...
            'Regions', ...
            'Original Video', ...
            'Out of BG', ...
            'Candidate Pixels', ...
            'Object', ...
            'Freezing', ...
            'Select pixels to exclude', ...
            'Re-analyze', ...
            'Done' ...
            });
        
%% load appropriate content        
        
        switch review_mode
            
            case 'done'
                continue
            
            case 'tracking properties'
                f = vidz_display_object_props(vid);
                input('Press ENTER to continue ','s');
                close(f);
                
            case 'distance'
                f = vidz_display_distance(vid);
                input('Press ENTER to continue ','s');
                close(f);
                
            case 'regions'
                f = vidz_display_region_all(vid);
                input('Press ENTER to continue ','s');
                close(f);
                
            case 'original video'
                content.video = vid.data.video;
                content.measure = vid.object.diff_by_frame;
                do_review = true;
                
            case 'out of bg'
                content.video = vid.data.out_of_minmax;
                do_review = true;
                
            case 'candidate pixels'
                content.video = vid.data.candidate_pixels;
                do_review = true;

            case 'object'
                content.video = vid.object.video;
                content.measure = vid.object.diff_by_frame;
                do_review = true;
                
            case 'freezing'
                content.video = vid.object.video;
                content.is_freezing = vid.object.freezing.is_freezing;
                content.measure = vid.object.diff_by_frame;
                do_review = true;
                
            case 'select pixels to exclude'
                vid = vidz_analyze_exclude_pixels(vid, content.current_frame);
                
            case 're-analyze'
                vid = vidz_analyze_find_nonbg_object(vid);
                vid = vidz_analyze_object_props(vid);
                
        end

%% if applicable, start review process

        if do_review
            content = review_matrix_video(content);
            fprintf('At frame %d\n', content.current_frame);
            do_review = false;
        end
         
%%

    end

%%
end