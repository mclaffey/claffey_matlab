function [e] = emg_set(varargin)
% Constructor for the emg_set class
%
% e = emg_set()
%
%   Create an empty emg_set
%
% e = emg_set('demo')
%
%   Create a sample emg_set from demo data
%
% e = emg_set(ced_data_structure)
%
%   Create an emg_set from the structure returned by ced_import
%
    
% Copyright 2008 Mike Claffey mclaffey@ucsd.edu
% 
% 10/13/09 added documentation on ced import
% 10/28/08 minor bug for channel names
% 10/01/08 added emg_set(trial_count, channel_count/names)
% 09/01/08 original version

    e.data = {};
    e.channel_names = {};
    e = class(e, 'emg_set');

    
    switch nargin
        case 0
            %% do nothing
            
        case 1
            % emg_set('demo') - create a sample emg_set with 2 channels and 10 trials
            if strcmpi(varargin{1}, 'demo')
                edata = load('s1_ced_data.mat');
                behav = load('s1_behavioral_data.mat');
                sampling_rate = 2000;
                e.channel_names = {'left', 'right'};
                
                for trial = 1:edata.ced_data.number_of_frames
                    for chan = 1:edata.ced_data.number_of_channels
                        emg_obj = emg(edata.ced_data.sweep_data(:,chan+1,trial), sampling_rate);
                        emg_obj.tags.units = 'mV';
                        emg_obj.tags.ced_frame = trial;
                        emg_obj.sections.tms = behav.pulse_data{trial, 'pulse_time'};
                        marker_data = [...
                            cellstr(char(edata.ced_data.marker_data.label(edata.ced_data.marker_data.frame==trial))), ...
                            mat2cell_same_size(edata.ced_data.marker_data.time(edata.ced_data.marker_data.frame==trial))];
                        emg_obj.tags.markers = marker_data;
                        e.data{trial, chan} = emg_obj;
                    end
                end
                
                e.data{2,2}.tags.valid = 0;
                e.data{2,2}.sections.tms.tags.valid = 0;
                e.data{4,1}.sections.tms = [];
            
            % emg_set(ced_data) - create an emg_set from a ced_data structure
            elseif isstruct(varargin{1}) && isfield(varargin{1}, 'sweep_data')
                ced_data = varargin{1};
                
                sampling_rate = ced_data.sampling_frequency;
                e.channel_names = ced_data.channel_names;
                if ischar(e.channel_names), e.channel_names = {e.channel_names}; end;
                
                for trial = 1:ced_data.number_of_frames
                    for chan = 1:ced_data.number_of_channels
                        signal_data = ced_data.sweep_data(:,chan+1,trial);
                        if all(isnan(signal_data))
                            warning('emg_set:emg_set:missing_ced_frame', 'There is no data for frame %d, channel %d', trial, chan)
                            emg_obj = emg();
                        else
                            emg_obj = emg(signal_data, sampling_rate);
                            emg_obj.tags.units = ced_data.channel_units;
                            emg_obj.tags.ced_frame = trial;
                        end
                        if ~isempty(ced_data.marker_data)
                            marker_data = [...
                                cellstr(char(ced_data.marker_data.label(ced_data.marker_data.frame==trial))), ...
                                mat2cell_same_size(ced_data.marker_data.time(ced_data.marker_data.frame==trial))];
                            emg_obj.tags.markers = marker_data;
                        end

                        e.data{trial, chan} = emg_obj;
                    end
                end
            else
                error('not yet implemented')
            end
        case 2
            if isnumeric(varargin{1}) && length(varargin{1}) == 1
                trial_count = varargin{1};
                
                if isnumeric(varargin{2}) && length(varargin{2}) == 1
                    % emg_set(100,3) - empty emg_set with 100 trials and 3 channels
                    channel_count = varargin{2};
                elseif iscell(varargin{2})
                    % emg_set(100, {'left', 'right'} - same as above but assigns channel names
                    e.channel_names = varargin{2};
                    channel_count = length(e.channel_names);
                else
                    error('When passing two arguments, second argument must be a number or cell')
                end
                
                e.data = repmat({emg()}, trial_count, channel_count);
            else
                error ('When passing two arguments, first argument must be a number')
            end
    end
   
end
