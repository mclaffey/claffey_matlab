function [b] = cell2str(a, padding, for_sprintf)
% Convert a cell of strs to a block of text

% Copyright 2009 Mike Claffey mclaffey[]ucsd.edu
%
% 04/01/09

    if ~exist('padding', 'var'), padding=4; end;
    if ~exist('for_sprintf', 'var'), for_sprintf = true; end;
    original_dims = size(a);
    a(cellfun(@isempty, a)) = {' '};
    a = reshape(a, original_dims );
    b = [];
    for x = 1:size(a,2)
        b = horzcat(b, repmat(' ',size(a,1),padding), char(a(:,x)));
    end

    if for_sprintf
        b = horzcat(b, repmat('\n',size(a,1),1));
        b = b';b=b(:)';
    end
end