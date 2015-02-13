function [b] = filename(a)
    [path, name, ext] = fileparts(a);
    b = [name ext];
end
    