function [is_ok, optional_message, e] = verify_basic_is_valid(e)
% True if .tags.valid is true (no modifications to e)

    is_ok = true;
    optional_message = ''; % 

%% insert function text below (do not modify above)

    if ~e.tags.valid
        is_ok = false;
        optional_message = 'flagged as invalid';
    end

end