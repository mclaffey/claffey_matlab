function [is_ok, optional_message, e] = verify_basic_metrics_ok(e)
% True if all metrics are accurate (corrects metrics of e)

    is_ok = true;
    optional_message = ''; % names of sections with bad metrics

%% insert function text below (do not modify above)

    % check main metrics
    old_metrics = e.tags.metrics;
    [junk, new_metrics] = compute_metrics(e);
    if ~isequalwithequalnans(old_metrics, new_metrics)
        optional_message = 'main';
        e.tags.metrics = new_metrics;
        is_ok = false;
    end

    % check section metrics
    section_names = fieldnames(e.sections);
    for x = 1:length(section_names)
        
        old_metrics = e.sections.(section_names{x}).tags.metrics;
        [junk, new_metrics] = compute_metrics(get_section_with_data(e, section_names{x}));
        if ~isequalwithequalnans(old_metrics, new_metrics)
            optional_message = [optional_message, ' ', section_names{x}]; %#ok<AGROW>
            e.sections.(section_names{x}).tags.metrics = new_metrics;
            is_ok = false;
        end
    end

    if ~is_ok, optional_message = ['sections with incorrect metrics: ', optional_message]; end;
end