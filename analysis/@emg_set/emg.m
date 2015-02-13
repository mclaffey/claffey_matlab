function e = emg(e_set)
%EMG Converts an emg_set containing a single trial and channel to an emg object
    if size(e_set, 1) > 1 || size(e_set, 2) > 1
        error('emg_set must have only one channel and trial to convert to emg object')
    else
        e = e_set.data{1,1};
    end
end
