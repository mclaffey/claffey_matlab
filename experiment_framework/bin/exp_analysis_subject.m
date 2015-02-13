function [edata, trial_data] = exp_analysis_subject(edata, trial_data)
% Perform analysis on the currently loaded subject
%
%   [edata, trial_data] = exp_analysis_subject(edata, trial_data)
%
%   It is recommended that the output of the analysis is done in
%   exp_analysis_report, and that all calculations are performed in this
%   function and not the exp_analysis_report
%
%   All parts of this function can be modified or removed to fit the
%   experiment being programmed.

% Copyright 2009-2011 Mike Claffey (mclaffey [] ucsd.edu)
%
% 01/01/11 cleaned up original version
    
    fprintf('Beginning analysis of subject %d...\n', edata.subject_id);
    
    fprintf('Only analysis implemented is block stats')
    edata = stop1_block_stats(edata, trial_data);

    fprintf('\n');
    fprintf('Completed analysis of subject %d.\n', edata.subject_id);    
    
end