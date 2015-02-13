function exp_audio_play_beep(edata)
% Play a beep

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 12/31/10 previously i had PC's using the sound command. this introduced
%          problems and I'm not sure why I was doing this in the first place
% 12/15/10 adapted from exp_audio_play_stop_signal

    try
        PsychPortAudio('Start', edata.audio.port, 1, 0, 1);
    catch
        beep
        warning('exp_audio_play_beep_signal:mac_failed_to_play', ...
            'PsychPortAudio failed to play the beep signal')
    end
    
end
    