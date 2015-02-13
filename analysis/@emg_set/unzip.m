function [e] = unzip(e)
% Uncompress individual emg objects within a set using dunzip

% 12/12/08 original version

    assert(is_compresssed(e.data{1,1}), 'Data does not appear to be compressed');
    
    for i = 1:size(e,1)
        for j = 1:size(e,2)
            e.data{i,j} = unzip(e.data{i,j});
        end
    end
end
    
    
    
    
    
    
    
    
    
    