function [len_e] = length(e)
% Returns the number of trials in an emg_set    
    len_e = size(e.data,1);
end