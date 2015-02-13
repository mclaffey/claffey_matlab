function dataset_csv_clipboard(data)
% Save a dataset to the clipboard so that it can be pasted into Excel

% Copyright Mike Claffey 2011 (mclaffey [] ucsd.edu)
%
% 02/03/11 original version

%% compile string to display

    display_string = '';

    % heading
    var_names = get(data, 'VarNames');
    var_count = length(var_names);
    for x = 1:var_count
        display_string = [display_string, sprintf('%s\t', var_names{x})]; %#ok<AGROW>
    end
    display_string = [display_string, sprintf('\n')]; %#ok<AGROW>
    
    % data
    for row_num = 1:size(data,1)
        for x = 1:var_count
            display_string = [display_string, sprintf('%s\t', any2str(data{row_num, x}))]; %#ok<AGROW>
        end
        display_string = [display_string, sprintf('\n')]; %#ok<AGROW>
    end
    
%% copy to clipboard

    clipboard('copy', display_string)
    
%% display on command line

    command_window_line
    fprintf(display_string);
    command_window_line
    fprintf('Data has been copied to clipboard\n'); 
    
%%  

end