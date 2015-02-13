function exp_admin_save_subject_analysis(edata, trial_data) %#ok<INUSD>
% Save subject data to a subject analysis file
%
% Data is saved to a separate analysis file instead of the original behav file
%   to prevent losing the original experiment data if the analysis script or user
%   accidentally deletes data
%
% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 01/21/11 documentation type
% 07/27/09 documentation added
    
    save(edata.files.analysis(edata.subject_id), 'edata', 'trial_data');
    fprintf('Analysis file for subject %d has been saved\n', edata.subject_id);
    
end
