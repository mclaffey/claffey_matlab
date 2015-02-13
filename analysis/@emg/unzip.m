function e = unzip(e)
% Uncompresses data using dunzip    
    
% 12/12/08 original version
    
    assert(is_compressed(e), 'Data is not compressed');

    e.data = dunzip(e.data);
    
end