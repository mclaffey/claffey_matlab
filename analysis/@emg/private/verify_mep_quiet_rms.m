function [is_ok, optional_message, e] = verify_mep_quiet_rms(e)
% True if the 100 ms before tms has rms < .005 (creates mep.tags.pre_tms.rms)
%
% The 100 ms is actually set to end 20 ms before tms, to avoid including the artifact
%
% The verify creates a tag on the mep section called pre_tms_rms with the actual rms value

    is_ok = true;
    optional_message = ''; % 

%% insert function text below (do not modify above)

    if ~isfield(e.sections, 'tms')
        is_ok = false;
        optional_message = 'no tms section';
    else
        warning off 'EMG:crop:cropping_outside_signal'
        pre_tms = crop(e, e.sections.tms.time.start-.12, e.sections.tms.time.start-.02);
        warning on 'EMG:crop:cropping_outside_signal'

        pre_tms_rms = pre_tms.tags.metrics.rms;
        if pre_tms_rms < .005
            optional_message = sprintf('rms before tms is less than 0.005 mV (%1.3f mV)', pre_tms_rms);
        else
            is_ok = false;
            optional_message = sprintf('rms before tms is greater than 0.005 mV (%1.3f mV)', pre_tms_rms);
        end
        if isfield(e.sections, 'mep')
            e.sections.mep.tags.pre_tms_rms = pre_tms_rms;
        end
    end

end