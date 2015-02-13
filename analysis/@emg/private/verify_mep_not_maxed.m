function [is_ok, optional_message, e] = verify_mep_not_maxed(e)
% True if there are no data points equal to +/- 1 in the mep (no modifications to e)

    is_ok = true;
    optional_message = '';

%% insert function text below (do not modify above)

    % check to see if the data hits the sampler max (assumed to be 1.0)
    if isempty(e.data)
        is_ok = false;
        optional_message = 'has no data';
    elseif ~isfield(e.sections, 'mep')
        is_ok = false;
        optional_message = 'no mep section';
    else
        abs_data = abs(e.sections.mep.data);
        max_points = sum(abs_data == 1);
        if max_points
            is_ok = false;
            optional_message = sprintf('has %d data points at maximum of 1.0', max_points);
        end
    end

end