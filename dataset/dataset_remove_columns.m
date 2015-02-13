function [b] = dataset_remove_columns(a, col_list)
    
    b = a;
    for x = 1:length(col_list)
        try %#ok<TRYNC>
            b.(col_list{x}) = [];
        end
    end
    
end