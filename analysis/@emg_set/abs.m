function [e] = abs(e)
% Rectify all emg objects in an emg_set

    for trial = 1:size(e,1)
        for chan = 1:size(e,2)
            e.data{trial,chan} = abs(e.data{trial,chan});
        end
    end

end

