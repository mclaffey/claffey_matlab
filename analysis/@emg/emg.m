function e = emg(varargin)
% Constructor for the emg class
%
% e = emg()
%
%   This form creates an empty emg object
%
% e = emg('demo')
%
%   Creates an emg object with dummy data and a marked TMS pulse
%
% e = emg(DATA, SAMPLING_RATE)
%
%   DATA is a scalar array of the emg data, and SAMPLING_RATE is a scalar number of the sampling
%   rate at which the data was obtained, in hertz.
%
% e = emg(DATA, SAMPLING_RATE, START_TIME)
%
%   Same as above, except START_TIME can be used to specify a non-zero time when the sample was
%   recorded

% Copyright Mike Claffey mclaffey@ucsd.edu

% 09/11/08 original version


    e.time = sampling_time();
    e.data = [];
    e.tags.valid = 1;
    e.tags.units = '(unknown units)';
    e.sections = struct();
    e = class(e, 'emg');

    switch nargin
        case 0
            %% do nothing
            
        case 1
            if strcmpi(varargin{1}, 'demo')
                trial = 2;
                try
                    edata = load('s1_ced_data.mat');
                catch
                    error('The tms/sample_data files could not be found')
                end
                edata = edata.ced_data.sweep_data(:,2,trial);
                e.data = edata;
                e.time = sampling_time(2000, e.data);
                e.tags.units = 'mV';
                behav = load('s1_behavioral_data.mat');
                e = make_section(e, 'tms', behav.pulse_data{trial, 'pulse_time'});
            else
                e.data = varargin{1};
                e.time = sampling_time(varargin{1}, e.data);
            end
            
        case 2
            e.data = varargin{1};
            time_arg = varargin{2};
            e.time = sampling_time(time_arg, e.data);
            
        case 3
            e.data = varargin{1};
            time_arg = varargin{2};
            e.time = sampling_time(time_arg, e.data);
            e.time.start = varargin{3};
    end

    % for convention, data should be a horizontal vector
    if size(e.data,1) > 1, e.data = e.data'; end;
    
    e = compute_metrics(e);
end