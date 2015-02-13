function [is_ok, optional_message, e] = verify_basic_sections_ok(e)
% True if none of the sections contain overhead data (removes data from e)

    is_ok = true;
    optional_message = ''; % names of sections with data

%% insert function text below (do not modify above)

    section_names = fieldnames(e.sections);
    for x = 1:length(section_names)
        % check to make sure there is no data being stored in the section
        if ~isempty(e.sections.(section_names{x}).data)
            optional_message = [optional_message, ' ', section_names{x}]; %#ok<AGROW>
            e.sections.(section_names{x}).data = [];
            is_ok = false;
        end
    end

    if ~is_ok, optional_message = ['sections with data: ', optional_message]; end;
end