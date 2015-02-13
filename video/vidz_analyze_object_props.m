function [vid] = vidz_analyze_object_props(vid)
% Compiles and reviews metrics from vid.object.props

%% heat map

    vid.object.heat_map = sum(vid.object.video, 3);
    
%% centroid

    % centroid data is in pixel coordinates
    centroid_data = [vid.object.props.Centroid];
    centroid_data = reshape(centroid_data, [2, vid.data.frames])';
    % the x and y position variables are percent of width and height,
    % respectively
    vid.object.x = centroid_data(:,1) / vid.data.dims(2);
    vid.object.y = centroid_data(:,2) / vid.data.dims(1);
    
%% movement

    % the distance variables are adjusted for physical dimensions, if
    % physical dimensions have been provided
    x_distance = diff(vid.object.x) * vid.params.physical_dims(1) ;
    y_distance = diff(vid.object.y) * vid.params.physical_dims(2) ;
    combined_distance = sqrt([(x_distance .^ 2) + (y_distance .^ 2)]);
    vid.object.movement = vidz_helper_get_metric_struct(vid, [NaN; combined_distance]);

    % movement is by frame, speed is per second
    speed = combined_distance / vid.params.data_extract_fps;
    vid.object.speed = vidz_helper_get_metric_struct(vid, [NaN; speed]);    
    
%% area and solidity

    vid.object.pixel_count = [vid.object.props.Area]';
    
    pixel_volume = vid.params.pixel_edge_length ^ 2;
    vid.object.area = vid.object.pixel_count * pixel_volume;
    
    vid.object.solidity = [vid.object.props.Solidity]';    
    
%%    

end