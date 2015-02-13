function [edata, trial_data] = exp_initialize_tms(edata, trial_data)
% Ask if tms should be used and initialize daq
%
%   [edata, trial_data] = exp_initialize_tms(edata, trial_data)

% 11/05/09 minor changes

    edata.run_mode.use_tms = input_yesno('Do you want to use TMS?', 'yes');
    
    % initialize the tms_recharge_duration field in the timing structure
    edata.timing.tms_recharge_duration = 0;

    if edata.run_mode.use_tms

        send_to_tms_daq('initialize')
                        
        % set the recharge time
        edata.timing.tms_recharge_duration = input('What is the tms recharge time in seconds (ENTER for 5): ');
        if isempty(edata.timing.tms_recharge_duration), edata.timing.tms_recharge_duration = 5; end;
        
    end
    
end




