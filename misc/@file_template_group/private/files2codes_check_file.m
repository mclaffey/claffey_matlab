function [code] = files2codes_check_file(file_name, code_template)

    % determine length of code string
    code_length = length('#CODE#');
    
    % find beginning of code
    code_start = findstr(code_template, '#CODE#');
    
    % get characters that come after code
    post_code_str = code_template(code_start+code_length:end);
    
    % chop off the string if there's another pattern (code, date, etc)
    next_pattern_start = findstr(post_code_str, '#');
    if isempty(next_pattern_start)
        noncode_str = post_code_str;
    else
        noncode_str = post_code_str(1:next_pattern_start(1)-1);
    end
    
    % find end of code
    if ~isempty(noncode_str)
        code_end = findstr(file_name, noncode_str)-1;
    else
        code_end = length(file_name);
    end
    
    % get code
    code = file_name(code_start:code_end);
    
    % convert string to cell
    code = {code};

end