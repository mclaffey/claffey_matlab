function [vid] = vidz_analyze_data(vid)

    % find the pixels that are outside the background callibration
    [vid] = vidz_analyze_out_of_bg_minmax(vid);
    
    % find an object (the largest continous region in each frame)
    [vid] = vidz_analyze_find_nonbg_object(vid);
    
    % compile metrics about the selected object
    [vid] = vidz_analyze_object_props(vid);    
    
    % detect freezing
    [vid] = vidz_analyze_freezing(vid);

end