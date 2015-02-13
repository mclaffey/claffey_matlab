function [is_ok, optional_message, e] = verify_mep_big_enough(e)
% True if an mep section is found with amplitude > 0.1 (no modifications to e)

    is_ok = true;
    optional_message = ''; % 

%% insert function text below (do not modify above)

    if ~isfield(e.sections, 'mep')
        is_ok = false;
        optional_message = 'no mep section';
    else
        mep_size = e.sections.mep.tags.metrics.peak2peak;
        if mep_size > .1
            optional_message = sprintf('mep amp is greater than .1 mV (%1.3f mV)', mep_size);
        else
            is_ok = false;
            optional_message = sprintf('mep amp is less than .1 mV (%1.3f mV)', mep_size);
        end
    end

end