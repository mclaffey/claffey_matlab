function [edata] = exp_initialize_edata
% Initialize the edata structure

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 11/09/09 changed default value of block type to normal
% 08/19/09 created generic version
    
%% experiment abbreviation

    edata.experiment_abbreviation = 'your_experiment_abbreviation';

%% default subject id

    edata.subject_id = 0;
    
%% run modes

    edata.run_mode.debug = false;
    edata.run_mode.practice = false;
    edata.run_mode.simulate = false;
    edata.run_mode.stop_asap = false;
    edata.run_mode.use_tms = false;
    edata.run_mode.use_fmri = false;
    
%% file locations

    edata.files = exp_files(edata);
    
%% experiment-specific parameters
    
    % example: 
    % edata.parameters.trials_per_block = 30;

%% timing    
    
    % example
    % edata.timing.cue_duration = 1;    

%% column definition
        
    % the column cell array determines the order of the columns in trial_data and
    % the columns that need to be added that are not created by data_create_trials()
    %
    % columns will be resorted to matched the order listed below. this is solely for
    % programmer convenience.
    %
    % the second column specifies the default value for any columns that need to be
    % added. if the column is already present (i.e. created by data_create_trials(),
    % this value is not used.
    %
    % column_definition is used by exp_data_format_trials to change the column
    % order. To protect against omissions, an error is thrown the data contains a column
    % that is not listed in column_definition.
    
    edata.columns.definitions = { ...
        'subject',          NaN,        'number',   'id number of the subject'      ; ...
        'block',            NaN,        'number',   'block number'                  ; ...
        'block_type',       'normal',   'text',     'indicates whether practice or real data'; ...
        'trial_num',        NaN,        'number',   'number of the trial'           ; ...
        'start_time',       NaN,        'number',   'computer time of start of trial (calculated in advance for fmri version)'; ...
        'complete',         0,          'number'    '1 if the trial has been completed, otherwise 0'; ...
        'outcome',          'incomplete','text',    'description of the outcome of the trial' ; ...
        'correct',          NaN,        'number'    '1 if the trial was correctly performed, otherwise 0'; ...
        };    
    
    edata.columns.command_window_feedback = ...
        {'block', 'trial_num', 'outcome'};        
    
end