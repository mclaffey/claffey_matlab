function [is_ok, optional_message, e] = verify_mep__found(e)
% True if an mep section is found (no modifications to e)

    is_ok = true;
    optional_message = ''; % 

%% insert function text below (do not modify above)

    if ~isfield(e.sections, 'mep')
        is_ok = false;
        optional_message = 'no mep section'; % 
    end

end