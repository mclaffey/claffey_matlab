function exp_audio_prep_beep(edata)
% If using PsychPortAudio, load the buffer    

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 12/15/10 adapted from exp_audio_prep_stop_signal

    % stop any previous played sound (a kind of reset command)
    PsychPortAudio('Stop', edata.audio.port);
    
    % fill buffer
    PsychPortAudio('FillBuffer', edata.audio.port, edata.audio.beep.wav);
    
    % now waiting on a PsychPortAudio('Start') command...
    
end