function clipboard_excel(a)
% Copies a matrix to clipboard so that it can be pasted into excel
%
%   clipboard_excel(a)

% Copyright Mike Claffey 2011 (mclaffey [] ucsd.edu)
%
% 02/11/11 original version


%% reject unimplemented variables types

    if ~isnumeric(a)
        error('input must be a numeric array');
    end
    
    if ndims(a) > 2
        error('numeric arrays with more than 2 dimensions are not implemented');
    end
    
%%

    clipboard_str = '';
    
    for i = 1:size(a,1)
        for j = 1:size(a, 2)
            
            % add element to clipboard string
            clipboard_str = [clipboard_str, sprintf('%f', a(i,j))]; %#ok<AGROW>
            
            % if not at end of row, add tab character between elements
            if j < size(a, 2)
                clipboard_str = [clipboard_str, sprintf('\t')]; %#ok<AGROW>
            end

        end
        
        % add line feed
        clipboard_str = [clipboard_str, sprintf('\n')]; %#ok<AGROW>
    end
    
%% copy to clipboard

    clipboard('copy', clipboard_str);
    
    fprintf('Variable has been copied to clipboard and can be pasted in excel.\n');

end