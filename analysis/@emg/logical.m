function [is_true] = logical(e)
% Returns true if an emg object is not empty

    is_true = ~isempty(e);
end