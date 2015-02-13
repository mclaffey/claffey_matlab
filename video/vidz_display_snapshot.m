function [f] = vidz_display_snapshot(vid)
% Opena new figure and display callibration snapshot
%
%   [f] = vidz_display_snapshot(vid)

%% display image

    f = figure;
    imagesc(vid.callibration.image);
    colormap(bone)
    axis image
    drawnow;

end