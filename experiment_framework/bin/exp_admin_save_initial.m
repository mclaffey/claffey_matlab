function [edata] = exp_admin_save_initial(edata)
    
%% create the data directory, if needed

    if ~exist(edata.files.data_dir, 'dir')
        try
            mkdir(edata.files.data_dir);
        catch
            error('Could not create data directory: %s', edata.files.data_dir);
        end
    end
    
%% create the subject directory, if needed

    if ~exist(edata.files.subject_dir(edata.subject_id), 'dir')
        try
            mkdir(edata.files.subject_dir(edata.subject_id));
        catch
            error('Could not create subject directory: %s', edata.files.subject_dir);
        end
    end

%% try to save the subject behavioral file

    % no error catching - let the user see the actual error if there's a problem
    save(edata.files.behav(edata.subject_id), 'edata');
    
end