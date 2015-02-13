function [vid] = vidz_query_crop_boundaries(vid)
% Export an image from full video and query for selecting clip boundaries

%% create a snopshot of the video

    snapshot = vidz_vidproc_create_snapshot(vid, vid.timing.callibration_start, vid.file.image);
    
    vid.original.image = rgb2gray(snapshot);
    vid.original.dims = size(snapshot);


%% query for clip boundaries

    f = figure;
    imagesc(vid.original.image);
    colormap(bone);
    fprintf('Drag rectangle over area to analyze...\n');
    vid.original.clip_rec = round(getrect(f));
    close(f);

%% save crop dimensions

    vid.original.crop = vid.original.clip_rec;
    
%   this field is no longer used for ffmpeg, but is used for other vidz
%   functions
  clip_coords = rec2coords(vid.original.clip_rec);
    vid.original.clip_trbl = [...
        clip_coords.top, ...                          % top
        vid.original.dims(2)-clip_coords.right, ...   % right
        vid.original.dims(1)-clip_coords.bottom, ...  % bottom
        clip_coords.left];                            % left
            
end