function [size_e] = size(e)
% Returns the number of points in the data of an emg object
    size_e = [1, length(e.data)];
end