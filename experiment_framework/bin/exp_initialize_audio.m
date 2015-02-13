function [edata] = exp_initialize_audio(edata)
% Initialize audio for beeps and/or playing wav files

% Copyright 2008-2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 01/20/11 use same initialize routine for pc and mac
%           I can't recall why I didn't use PsychPortAudio for PCs in the
%           past and this change may introduce problems for old experiments
%           running on PCs
% 12/15/10 converted references to stop signal to generic beep
% xx/xx/08 original version

%% example 1: create a beep from scratch using a PsychToolbox function   

    beep_duration = 0.1;
    beep_volume = 0.2;
    edata.audio.beep.freq = 20000;
    edata.audio.beep.wav = MakeBeep(edata.audio.beep.freq, beep_duration);
    % change volume
    edata.audio.beep.wav = edata.audio.beep.wav .* beep_volume;    
    % make it 2-channel (stereo)
    edata.audio.beep.wav = repmat(edata.audio.beep.wav, 2, 1);
    
    % an older version labeled the variable as 'stop_' because it was used
    % for playing a stop signal. keep these for compatibility    
    
    edata.audio.stop_freq = edata.audio.beep.freq;
    edata.audio.stop_wav = edata.audio.beep.wav;
    
%% example 2: load a sound form a file

%   an alternative to example 1 (constructing beep from parameters) is to
%   load from a wave file, as in the example below

%    edata = exp_audio_load_wav(edata, 'beep', fullfile(edata.file.base_dir, 'config', 'chord.wav'));

%% Initialize audio

    if edata.run_mode.debug
        InitializePsychSound;
        edata.audio.port = ...
            PsychPortAudio('Open', [], [], 0, edata.audio.beep.freq, 2);
    else
        % if not in debug mode, run using evalc()
        %   evalc() captures the many lines of feedback these commands create.
        %   however, if there is an error, you'll want to see these
        %   (so use debug mode)
        edata.audio.messages.init = evalc('InitializePsychSound');
        [edata.audio.messages.port, edata.audio.port] = ...
            evalc('PsychPortAudio(''Open'', [], [], 0, edata.audio.beep.freq, 2)');
    end
        
%% test sound

    exp_audio_prep_beep(edata);
    exp_audio_play_beep(edata);
        
end