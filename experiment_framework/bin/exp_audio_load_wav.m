function [edata] = exp_audio_load_wav(edata, sound_name, file_name)
% Loads a wav file into a field of edata.audio
%
%   [edata] = exp_audio_load_wav(edata, sound_name, file_name)

% Copyright 2010 Mike Claffey (mclaffey [] ucsd.edu)
%
% 12/19/10 initialize version

    % check if file exists
    if ~exist(file_name, 'file')
        error('wav file does not exist: %s', file_name);
    end

    % load the file
    [wav_data, wav_freq] = wavread(file_name);
    
    non_single_dimensions = sum(size(wav_data)>1);
    
    % if wav data is a vector, make it a row vector and double the rows so
    % that it plays in stereo
    if non_single_dimensions == 1
        wav_data = assert_vector(wav_data, 2);
        wav_data = [wav_data;wav_data];
        
    % if wav_data is a two-column matrix, flip it to a two-row matrix
    elseif non_single_dimensions == 2 && size(wav_data,2) == 2 && size(wav_data,1) > 2
        wav_data = wav_data';
    else
        error('wav_data can not have more than 2 dimensions');
    end
    
    % save to edata
    edata.audio.(sound_name).wav = wav_data;
    edata.audio.(sound_name).freq = wav_freq;
    edata.audio.(sound_name).duration = max(size(wav_data)) / wav_freq;

end