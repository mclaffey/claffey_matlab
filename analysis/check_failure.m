function [check_failed_boolean] = check_failure(criteria, description_string)
    fprintf('\nCRITERIA ');
    if criteria
        fprintf('passed: %s\n\n', description_string);
        check_failed_boolean = false;
    else
        fprintf('*FAILED*: %s\n\n', description_string);
        check_failed_boolean = true;
    end
end