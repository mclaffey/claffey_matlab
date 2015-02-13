function vidz_summary_region(vid)
% Display a table of region metrics
%
%   vidz_summary_region(vid)

%% Header

    command_window_line
    fprintf('   Region summary \t\t time \t\t distance (m) \t overlap \n');

%% Iterate through each region        

    region_list = fieldnames(vid.regions);
    
    for region_index = 1:length(region_list);
        
        % get name and data
        region_name = region_list{region_index};
        region_data = vid.regions.(region_name);

        % format name to be proper length in table
        desired_length = 20;
        name_length = length(region_name);
        padded_length = desired_length - name_length;
        padded_name = [repmat(' ', 1, padded_length), region_name];

        % display metrics
        fprintf('\t %s \t %d%% \t\t %0.2f \t\t %d%%\n', ...
            padded_name, ...
            round(region_data.contains_object.mean * 100), ...
            region_data.distance_to_object.mean, ...
            round(region_data.percent_of_object.mean * 100));
        
    end

end