function exp_analysis_publish(edata, trial_data)
% Publishes the subject report to HTML
%
%   exp_analysis_publish(edata, trial_data)

% Copyright 2009-2011 Mike Claffey (mclaffey [] ucsd.edu)
%
% 01/01/11 cleaned up original version
    
    report_file = which('exp_analysis_subject_report');
    publish_clean(report_file, edata.files.html(edata.subject_id), 'html', false);
    close all
    
end
