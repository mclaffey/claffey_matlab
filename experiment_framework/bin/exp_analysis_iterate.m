function [varargout] = exp_analysis_iterate(ef, ids, function_handle)
% Runs a function on subjects specified by an id list
%
% exp_analysis_iterate() loads the data for each subject specified in a
%   list of ids and then runs a specified function on that data, such as
%   analyze_subject. the function output for each subject is saved as an
%   element in a cell array.
%
% the function specified by function_handle does not have to return a
% result. For example, the function might make an update to the data and
% save the file directly. in this way, exp_analysis_iterate can be used to
% make mass updates to subject files.
%
% if the results returned by the function are a dataset, the routine
% will aggregate all those rows as the output variable results_dataset, in
% addition to providing the cell of individual rows. because of this feature,
% exp_analysis_iterate is particularly useful for aggregating data results
% by subject using functions which analyze the subject data structure to
% produce a dataset row of results.
%
% NOTE: the data loaded for each subject and passed to the function are the
% edata and trial_data variable. the iterating function should handle those
% two arguments in that order
%
% [results_dataset, results_cell, results_ok] = exp_analysis_iterate(ef, ids, function_handle)
%
%   ef is the enum_file object of an experiment, typically returned by
%       functions such as fts5_files() or exp_files()
%
%   ids is a matrix of ids for corresponding subjects to be loaded and iterated
%
%   function_handle is either a function handle or string specifying a
%       function to be run on all subjects
%
%   results_cell is a cell array which holds the output the function for
%       each subject
%
%   results_dataset is a dataset that is constructed if the output of each
%       function is one or more dataset rows. if the function does not
%       return datasets, this variable will be empty, but no error will be
%       returned
%
%   results_ok is a boolean vector indicating if the function raw without
%       errors for the given subject
    
% Copyright 2011 Mike Claffey (mclaffey [] ucsd.edu)
%
% 06/08/11 added all documentation, cleaned up code
% 06/08/11 pass edata & trial_data to function (previously it passed the
%          loaded structure containing these two fields, but most functions
%          in the experiment framework take edata & trial_data, so this is
%          a better fit.

%% check input arguments

    % if ids is empty, get all ids
    if isempty(ids), ids = ef.ids; end;    
    
    % if the function handle is a string, convert it to a true function
    % handle
    if ischar(function_handle), function_handle = str2func(function_handle); end;
    
%% prepare variables

    id_count = length(ids);
    
    % create a cell array to save results of each function
    results_cell = cell(id_count, 1);
    
    % create a vector to indicate whether the function ran successfully for
    % the corresponding subject
    results_ok = nan(id_count, 1);
    
    % if the cell array of results can be converted to a dataset, it will
    % be saved here
    results_dataset = [];
    
    % check whether the function returns a variable
    function_returns_variable = nargout(function_handle) ~= 0;
    
%% iterate over each subject
    
    for subject_index = 1:id_count
        
        % get subject id and file name
        subject_id = ids(subject_index);
        file_name = ef(subject_id).find;
        
        % indicate whether a file was found for the subject
        if isempty(file_name)
            command_window_line
            fprintf('No file found for subject %d\n', subject_id);
            results_ok(subject_index) = false;
            continue
        else
            command_window_line
            fprintf('Processing subject %d\n', subject_id);
        end
        
        % try-catch loop in case there is a problem loading data
        try
            % load the subject data
            loaded_data = [];
            
            % turn off an undiagnosed but hopefully harmless warning
            % this was used for gum1 and could probably be removed in the future
            old_warn_status = warning('off', 'MATLAB:unknownElementsNowStruc');
            
            % load the data
            loaded_data = load(file_name);
            
            % return the warning to its previous state
            warning(old_warn_status);
            
            % divide the loaded data to edata & trial_data
            edata = loaded_data.edata;
            trial_data = loaded_data.trial_data;
        catch
            fprintf('Failed to load data for subject %d: %s\n\n', subject_id, lasterr);
        end
        
        % try-catch loop in case the function produces an error
        try
            
            % assume that loaded data contains edata and trial_data
            
            
            % if the function returns a variable, save the results of
            % feval() to the results cell and then try to append it to the
            % dataset
            if function_returns_variable
                results_cell{subject_index} = feval(function_handle, edata, trial_data);
                attempt_dataset_append(results_cell{subject_index});
                
            % if the function does not return a variable, just run it
            else
                feval(function_handle, edata, trial_data);
            end
            
            % if there was no error yet, mark the subject as successful
            results_ok(subject_index) = true;
            
        % this is the catch loop in case the function fails to run for a
        % given subject
        catch
            % report the error and mark the subject as failed
            fprintf('Exp_analysis_iterate() found an error while calling %s:\n  %s\n\n', func2str(function_handle), lasterr);
            results_ok(subject_index) = false;
        end        
    end
        
%% wrap up output

    varargout = {results_dataset, results_cell, results_ok};
    varargout = varargout(1:nargout);
    
%% helper function

    function attempt_dataset_append(candidate_data)
        % look at the data returned by the function. if it is a dataset,
        % append it to results_dataset. if it's not a dataset or there is
        % an error, move on without throwing an error
        
        % continue on if any errors are encountered, particularly since
        % this routine is meant to run for functions that don't return
        % datasets
        try
            
            % check if the data is a dataset
            if isa(candidate_data, 'dataset')
                
                % add a subject column if there isn't one already
                candidate_data = dataset_add_columns(candidate_data, 'subject', subject_id);
                
                % if the dataset is using obs_names, prepend the subject id
                % so that observation names will still be unique across
                % subjects in the aggregated dataset
                obs_names = get(candidate_data, 'ObsNames');
                if ~isempty(obs_names)
                    obs_names = cellfun_easy(@sprintf, '%d_%s', subject_id, obs_names);
                    candidate_data = set(candidate_data, 'ObsNames', obs_names);
                end
                
                % add the candidate data tot he overall dataset
                results_dataset = dataset_append(results_dataset, candidate_data);
            end
        catch
            fprintf('Failed to append resultant dataset to results_dataset\n');
            fprintf('error: %s\n', lasterr);
        end
    end

end

