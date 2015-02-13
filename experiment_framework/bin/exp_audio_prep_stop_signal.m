function exp_audio_prep_stop_signal(edata)
% If using PsychPortAudio, load the buffer    

    % don't do this for the pc
    if ispc, return; end;

    % stop any previous played sound (a kind of reset command)
    PsychPortAudio('Stop', edata.audio.port);
    
    % fill buffer
    PsychPortAudio('FillBuffer', edata.audio.port, edata.audio.stop_wav);
    
    % now waiting on a PsychPortAudio('Start') command...
    
end