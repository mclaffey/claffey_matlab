function e = zip(e)
% Compresses data using dzip    
    
% 12/12/08 original version
    
    assert(~is_compressed(e), 'Data is already compressed');

    e.data = dzip(e.data);
    
end