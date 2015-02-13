function [is_ok, optional_message, e] = verify_basic_has_data(e)
% True if data is a non-empty array (no modifications to e)

    is_ok = true;
    optional_message = '';

%% insert function text below (do not modify above)

    % check to make sure there is no data being stored in the section
    if isempty(e.data)
        is_ok = false;
        optional_message = 'has no data';
    end

end