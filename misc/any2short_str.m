function [short_str] = any2short_str(a)
% Convert any variable type to a string of less than 50 characters

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 09/07/09 original version

    maximum_string_length = 70;
    
%% handle empty variables    
    
    if isempty(a)
        switch class(a)
            case 'double'
                short_str = '[]';
            case 'cell'
                short_str = '{}';
            otherwise
                short_str = sprintf('empty %s', class(a));
        end
        return
    end

%% handle specific cases    
    
    switch class(a)
        case 'dataset'
            short_str = sprintf('dataset %dx%d: ', size(a));
            col_names = get(a, 'VarNames');
            for x = 1:size(a,2);
                col_name = col_names{x};
                if length(col_name) > 5, col_name = col_name(1:5); end;
                short_str = [short_str, sprintf('%s,', col_name)]; %#ok<AGROW>
            end
            
%% pass everything else to any2str            
            
        otherwise
            short_str = any2str(a);
    end
    
%% trim to maximum length    
    
    if length(short_str) > maximum_string_length
        short_str = short_str(1:maximum_string_length);
    end;

end