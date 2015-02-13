function [f] = vidz_display_distance(vid)
% Display graph of distance travelled, useful for finding tracking jumps
%
%   [f] = vidz_display_distance(vid)

%% display figure

    f = figure;
    % Display in cm
    plot(vid.object.speed.by_frame * 100)
    xlabel('Frame Number');
    ylabel('Distance moved (cm)');
    xlim([1 vid.data.frames]);
    
%% Report distances

    total_distance = nansum(vid.object.movement.by_frame);
    fprintf('Total distance traveled: %3.1f m\n', total_distance);

    [max_speed, frame_of_max] = max(vid.object.speed.by_frame);
    % convert max speed from m to cm
    max_speed = max_speed * 100;
    fprintf('Max speed traveled was %1.2f cm/sec at frame %d\n', max_speed, frame_of_max);
    
%%

end
    
