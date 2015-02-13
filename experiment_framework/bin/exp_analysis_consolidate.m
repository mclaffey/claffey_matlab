function [consolidated_subject_dataset] = exp_analysis_consolidate(edata)
% Aggregate result rows across subjects

    consolidated_subject_dataset  = [];

%% perform analysis on behav file for each subject id

    ef = edata.files.behav;
    ids = ef.ids;
    exp_analysis_iterate(ef, ids, 'exp_analysis_subject');
    
%% gather analyzed data    

    ef = edata.files.analysis;
    ids = ef.ids;
    consolidated_subject_dataset = exp_analysis_iterate(ef.analysis, ids, mfilename);

end
