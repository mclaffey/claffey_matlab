function vidz_excel_pastable(vid)
% Display inforamtion in the command line that can be posted into Excel

%% initialize variables

    heading = {};
    data = {};
    region_names = fieldnames(vid.regions);
    bin_count = length(vid.regions.(region_names{1}).contains_object.by_bin);
    
%% list video information

    add_metric('video', vid.file.name);
    add_metric('subfolder', vid.file.subfolder_name);
    
%% list metadata

    if isfield(vid, 'metadata')
        metadata_fields = fieldnames(vid.metadata);
        for x = 1:length(metadata_fields)
            metadata_field = metadata_fields{x};
            metadata_value = any2str(vid.metadata.(metadata_field));
            % abbreviate to no more than 50 chars
            if length(metadata_value) > 50
                metadata_value = metadata_value(1:50);
            end
            add_metric(metadata_field, metadata_value);
        end
    end
    
%% average x and y position

    add_metric('avg_x', sprintf('%4.3f', nanmean(vid.object.x)));
    add_metric('avg_y', sprintf('%4.3f', nanmean(vid.object.y)));
    
%% movement

    add_metric('movement', sprintf('%4.3f', mean(vid.object.movement.mean)));
    for bin_index = 1:bin_count
        bin_name = sprintf('movement_bin%d', bin_index);
        bin_value = sprintf('%4.3f', vid.object.movement.by_bin(bin_index));
        add_metric(bin_name, bin_value);
    end
    
%% metrics for each region

    region_names = fieldnames(vid.regions);
    for region_index = 1:length(region_names)
        region_name = region_names{region_index};
        region_data = vid.regions.(region_name);
        
        add_metric([region_name '_time'],       sprintf('%4.3f', region_data.contains_object.mean));
        add_metric([region_name '_distance'],   sprintf('%4.3f', region_data.distance_to_object.mean));
        add_metric([region_name '_overlap'],    sprintf('%4.3f', region_data.percent_of_object.mean));
        
        % time
        for bin_index = 1:bin_count
            bin_name = sprintf('%s_time_bin%d', region_name, bin_index);
            bin_value = sprintf('%4.3f', region_data.contains_object.by_bin(bin_index));
            add_metric(bin_name, bin_value);
        end
        
        % distance
        for bin_index = 1:length(region_data.contains_object.by_bin)
            bin_name = sprintf('%s_distance_bin%d', region_name, bin_index);
            bin_value = sprintf('%4.3f', region_data.distance_to_object.by_bin(bin_index));
            add_metric(bin_name, bin_value);
        end
        
        % overlap
        for bin_index = 1:length(region_data.contains_object.by_bin)
            bin_name = sprintf('%s_overlap_bin%d', region_name, bin_index);
            bin_value = sprintf('%4.3f', region_data.percent_of_object.by_bin(bin_index));
            add_metric(bin_name, bin_value);
        end
    end
    
%% compile string to display

    display_string = '';

    % heading
    for x = 1:length(heading)
        display_string = [display_string, sprintf('%s\t', heading{x})]; %#ok<AGROW>
    end
    display_string = [display_string, sprintf('\n')]; %#ok<AGROW>
    
    % data
    for x = 1:length(data)
        display_string = [display_string, sprintf('%s\t', data{x})]; %#ok<AGROW>
    end
    display_string = [display_string, sprintf('\n')]; %#ok<AGROW>
    
%% copy to clipboard

    clipboard('copy', display_string)
    
%% display on command line

    command_window_line
    fprintf(display_string);
    command_window_line
    fprintf('Data has been copied to clipboard\n');    
    
%% helper function

    function add_metric(header_value, data_value)
        heading{end+1} = header_value;
        data{end+1} = data_value;
    end




end
