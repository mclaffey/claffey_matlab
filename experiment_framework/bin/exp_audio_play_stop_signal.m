function exp_audio_play_stop_signal(edata)
% Play the stop signal    

%% pc version

    % This takes approximately 7 ms to play, see comment below
    if ispc
        sound(edata.audio.stop_wav, edata.audio.stop_freq);
        return
    end

%% mac version

    % This takes approximately 25 ms to play the sound, which introduces 
    % a possibility of missing a button push during this time back in the trial loop
    
    try
        PsychPortAudio('Start', edata.audio.port, 1, 0, 1);
    catch
        beep
        warning('exp_audio_play_stop_signal:mac_failed_to_play', ...
            'PsychPortAudio failed to play the stop signal')
    end
    
end
    