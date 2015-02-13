function [f] = image_detailed(image_data)
% Display statistics on a single image
%
%   [f] = image_detailed(img)

%% open figure

    f = figure;
    
%% raw image

    subplot(2,2,1);    
    image(image_data);
    %colormap(bone)
    
%% scaled image

    subplot(2,2,2);    
    imagesc(image_data);
    %colormap(bone)
    
%% histogram of values

    subplot(2,2,3);
    hist(image_data(:));
    
    
end