function [f] = vidz_display_frame(vid, frame_num)
% Display statistics on a single video frame
%
%   [f] = vidz_display_frame(vid, frame_num)

%% open figure

    f = figure;
    
%% raw image

    image_data = vid.data.video(:,:,frame_num);

    subplot(3,2,1);    
    imagesc(image_data);
    title('raw image')
    colormap(bone)
    
%% histogram of values

    subplot(3,2,2);
    hist(image_data(:));
    title('histogram of raw image')
    
%% mean background

    subplot(3,2,3);    
    mean_bg = (vid.callibration.range.min + vid.callibration.range.max) ./ 2;
    imagesc(mean_bg);
    colormap(bone)
    title('mean bg callibration')

%% less than min    

    subplot(3,2,4);    
    imagesc(vid.data.out_of_minmax(frame_num));
    title('out of bg')
    
%% less than background

    subplot(3,2,5);    
    imagesc(image_data < vid.callibration.range.min);
    colormap(bone)
    title('calced < bg')

%% less than min    

    subplot(3,2,6);    
    imagesc(image_data > vid.callibration.range.max);
    title('calced > bg')
    
end