function [edata, trial_data] = exp_trial_save_td(edata, trial_data, td)

%% populate common fields

    td_var_names = get(td, 'VarNames');

    % duration
    if ismember('duration', td_var_names)
        td.duration = nz(GetSecs - td.start_time, 0);
    end
    
    % complete
    if ismember('complete', td_var_names)
        td.complete = 1;
    end
    
%% turn off warnings

    old_warnings = warning('off', 'stats:categorical:subsasgn:NewLevelsAdded');
    
%% try saving the data

    try
        trial_data(edata.current_trial, :) = td;
    catch
        
%% handle problems with the save

        % it is usually because the td variable was modified to have different columns
        % than the trial_data, so provide some help for debugging
        
        compare_results = dataset_compare(td, trial_data);
        if ~isempty(compare_results.missing_in_a)
            fprintf('The following columns are in trial_data but missing in td:\n');
            disp(compare_results.missing_in_a);
        end
        if ~isempty(compare_results.missing_in_b)
            fprintf('The following columns are in td but missing in trial_data:\n');
            disp(compare_results.missing_in_b);
        end
        if ~isempty(compare_results.class_differences)
            fprintf('Columns in td (a) variable have difference classes than trial_data (b):\n');
            disp(compare_results.class_differences);
        end
        error('Could not insert td back into trial_data, see notes above for help debugging');
    end
    warning(old_warnings);

%% in debug mode, assign td to the workspace
    if edata.run_mode.debug
        assignin('base', 'td', td);
    end

end