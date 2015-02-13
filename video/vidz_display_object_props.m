function [f] = vidz_display_object_props(vid)
% Display graphs for diagnostic of tracking success

    f = figure;

    % centroid location
    subplot(3,1,1)
    plot(vid.object.x, vid.object.y)
    title('location')
    xlim([0 1])
    ylim([0 1])
    
    % object area
    subplot(3,1,2)
    % plot in cm squared, not m squared
    plot(vid.object.area * 100 * 100)
    % plot typical mouse area (10 cm * 3 cm)
    plot_line(30, 'h', 'r')
    title('area')
    xlim([1 vid.data.frames])
    ylabel('cm^2')
    
    % solidity
    subplot(3,1,3)
    plot(vid.object.solidity)
    xlim([1 vid.data.frames])
    ylim([0 1])
    title('solidity')

end