function [is_ok, optional_message, e] = verify_mep_long_enough(e)
% True if an mep section is found with duration > 0.015 (no modifications to e)

    is_ok = true;
    optional_message = ''; % 

%% insert function text below (do not modify above)

    if ~isfield(e.sections, 'mep')
        is_ok = false;
        optional_message = 'no mep section';
    else
        mep_duration = round(e.sections.mep.time.duration * 1000);
        if mep_duration > .015
            optional_message = sprintf('mep duration is greater than 15 ms (%d ms)', mep_duration);
        else
            is_ok = false;
            optional_message = sprintf('mep duration is less than 15 ms (%d ms)', mep_duration);
        end
    end

end