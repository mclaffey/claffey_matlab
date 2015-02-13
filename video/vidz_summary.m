% this must be a script for html publishing

%% Source

    fprintf('Name: %s\n', vid.file.name);
    fprintf('Subfolder: %s\n', vid.file.subfolder_name);
    fprintf('File: %s\n', vid.file.original);

%% Metadata

    if isfield(vid, 'metadata'), display(vid.metadata); end;
    
%% Parameters

    display(vid.params);
    
%% Timing

    display(vid.timing);
    
%% Region Summary

    vidz_summary_region(vid);
    
%% Region Details

    vidz_excel_pastable(vid);
    
%% Heat Map

    f = figure;
    imagesc(vid.object.heat_map);
    colormap(jet);
    drawnow;
    
%% Object Tracking

    close(f);
    
    f = vidz_display_object_props(vid);
    drawnow;
    
%% Distance Traveled

    close(f);
    
    f = vidz_display_distance(vid);
    drawnow;
    
%% Regions on callibration image

    close(f);
    
    f = vidz_display_region_all(vid);
    colormap(bone);
    drawnow;
    
%% First data image

    close(f);

    f = figure;
    imagesc(vid.data.image);
    colormap(bone);
    drawnow;
        
%% Excluded pixels

    if any(vid.data.excluded_pixels(:))

        close(f);

        f = figure;
        imagesc(sum(double(vid.data.excluded_pixels),3));
        drawnow;
        
    else
        
        fprintf('No excluded pixels');
        
    end
    
%%
    close(f);
