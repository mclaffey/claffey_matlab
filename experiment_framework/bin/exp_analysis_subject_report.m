% exp_analysis_subject_report
%
% This script should output/display relevant analysis on a single subject
%
% While other files in the framework are functions, this file is a script
% because this allows it to be published to html, which is performed by the
% exp_analysis_publish() function.
%
% All parts of this file can be modified/removed to fit the current
% experiemtn
%
% Copyright 2009-2011 Mike Claffey (mclaffey [] ucsd.edu)
%
% 01/01/11 cleaned up original version


%% Block Stats

    command_window_line
    fprintf('Block Stats\n');
    
    disp(edata.block_stats);
    