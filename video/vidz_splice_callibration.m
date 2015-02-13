function [vid] = vidz_splice_callibration(vid, splice_time, splice_rec)
% Replaces a crop rectange in the callibration with one from another time point
%
%   [vid] = vidz_splice_callibration(vid)

% Copyright 2010 Mike Claffey (mclaffey[] ucsd.edu)
%
% 12/23/10 original version


%% ask user to specify a second time point

    if ~exist('splice_time', 'var') || isempty(splice_time)
        splice_time = query_seconds('Enter time for image to splice into rectangle');
    end

%% prompt the user to crop the offending area

    f = [];
    
    if ~exist('splice_rec', 'var') || isempty(splice_rec)
        f = figure;
        imagesc(vid.callibration.image);
        colormap(bone);
        fprintf('Drag rectangle over area to exclude...\n');
        splice_rec = round(getrect(f));
        close(f);
    end
    
    row_indices = splice_rec(2):splice_rec(2)+splice_rec(4);
    row_indices(row_indices < 1 | row_indices > size(vid.callibration.image,1)) = [];
    col_indices = splice_rec(1):splice_rec(1)+splice_rec(3);
    col_indices(col_indices < 1 | col_indices > size(vid.callibration.image,2)) = [];

%% save current version of callibration

    original_callibration = vid.callibration;
    original_callibration_start = vid.timing.callibration_start;
    
%% process that second time point

    vid.timing.callibration_start = splice_time;
    vid = vidz_vidproc_callibration(vid);
    vid = vidz_analyze_callibration(vid);
    splice_callibration = vid.callibration;

%% resume the original callibration

    vid.callibration = original_callibration;
    vid.timing.callibration_start = original_callibration_start;
    
%% overlay rectange from second time point into original

    % this is just the image for verification purposes, not the data used
    % for the callibration itself
    vid.callibration.image = splice_matrices(vid.callibration.image, splice_callibration.image);
    
    % this is the actual data
    vid.callibration.range.min = splice_matrices(vid.callibration.range.min, splice_callibration.range.min);
    vid.callibration.range.max = splice_matrices(vid.callibration.range.max, splice_callibration.range.max);

%% save splice data

    splices.time = splice_time;
    splices.rec = splice_rec;

    if isfield(vid.callibration, 'splices')
        vid.callibration.splices(end+1) = splices;
    else
        vid.callibration.splices = splices;
    end
    
%% show new callibration image

    if isempty(f)
        f = figure;
    end
    subplot(3,1,1);
    imagesc(vid.callibration.image);
    subplot(3,1,2);
    imagesc(vid.callibration.range.min);
    subplot(3,1,3);
    imagesc(vid.callibration.range.max);
    colormap(bone);
    
%% helper function    
    
    function [a] = splice_matrices(a, b)
        a(row_indices, col_indices) = b(row_indices, col_indices);
    end
    
%%
end
    