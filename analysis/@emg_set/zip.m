function [e] = zip(e)
% Compress individual emg objects within a set using dzip

% 12/12/08 original version

    assert(~is_compresssed(e.data{1,1}), 'Data appears to already be compressed');
    
    for i = 1:size(e,1)
        for j = 1:size(e,2)
            e.data{i,j} = zip(e.data{i,j});
        end
    end
end
    
    
    
    
    
    
    
    
    
    