function [new_code] = query_for_new_code(ftg)
% Query the user for a new subject code
%
%   [ftg] = query_for_code(ftg)

    new_code = '';
    existing_codes = return_codes(ftg);

    % keep looping until an acceptable response is entered
    while true
        
        % display menu/prompt
        fprintf('Prompting for new subject code.\n');
        fprintf('  Press ENTER without a response to see existing codes\n');
        fprintf('  Type ''exit'' to cancel\n');
        response = input('  Your response: ', 's');
           
%% list responses
        if isempty(response)
            fprintf('Existing codes:\n');
            for x = 1:length(existing_codes);
                fprintf('\t%s\n', existing_codes{x});
            end
            continue
        end
        
%% exit

        if strcmpi(response, 'exit')
            return
        end
        
%% user entered existing code

        if ismember(response, existing_codes)
            fprintf('That code already exists\n');
            continue
        end
        
%% if none of the above were true, accept response as new code

        new_code = response;
        return
%%        
    end
end