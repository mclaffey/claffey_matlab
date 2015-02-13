function [preview_data] = prev(a, row)
    
    if ~exist('row', 'var'), row = 1; end;
    
    preview_data = get(a, 'VarNames')';
    
%     for x = 1:size(a,2)
%         preview_data{x,2} = a{row, x};
%     end
    
end