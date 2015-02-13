function [b] = dataset_dataset2struct(a)
    
    col_names = get(a, 'VarNames');
    
    b = struct;
    for x = 1:length(col_names)
        b.(col_names{x}) = a{1, x};        
    end    
    
end