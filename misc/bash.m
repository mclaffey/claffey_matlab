function bash
% Bash command line

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 03/07/09 original version
    
    svn_prefix = false;

    input_str = '';
    while ~strcmpi(input_str, 'quit')
        if svn_prefix
            input_str = input('svn ', 's');
            if strcmpi(input_str, 'bash'),
                svn_prefix = false;
            else
                [status, result] = system(sprintf('%ssvn %s', GetSubversionPath, input_str));
                fprintf('%s\n', result);
            end
        else
            input_str = input('bash$ ', 's');
            if strcmpi(input_str, 'svn'),
                svn_prefix = true;
            else
                [status, result] = system(input_str);
                fprintf('%s\n', result);
            end
        end
        
    end
end
    
    
    
    