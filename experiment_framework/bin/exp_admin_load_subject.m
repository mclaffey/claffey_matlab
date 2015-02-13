function [edata, trial_data] = exp_admin_load_subject(edata)
% Load subject data
%

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 07/27/09 added automatic update of file locations
    
    ef = exp_files(edata);
    trial_data = [];

%% get the subject id    
    
    fprintf('Available subjects:\n\t%s\n', mat2str(ef.behav.ids'));
    subject_id = input('Load what id: ');
    if isempty(subject_id), return; end
    
%% try loading files

    if ef.analysis(subject_id).exists
        response = input('Load ANALYSIS or original BEHAV file? (ENTER for ANALYSIS, "b" for BEHAV) ', 's');
        if isempty(response)
            subject_data = ef.analysis(subject_id).load;
        else                
            subject_data = ef.behav(subject_id).load;
        end;
    else
        subject_data = ef.behav(subject_id).load;
    end
    edata = subject_data.edata;
    edata.files = ef;
    trial_data = subject_data.trial_data;
    exp_admin_save_vars(edata, trial_data);
    exp_admin_status;
    fprintf('Click to <a href="matlab:[edata, trial_data] = exp_analysis_subject(edata, trial_data);">analyze</a>\n');

end