function [varargout] = how_are_you
% Identify any potential problems in the matlab installation
%
%   "problems" are in relation to the configuration which was used to
%   develop and test the claffey_matlab library and related projects

% Copyright 2009-2010 (mclaffey[]ucsd.edu)
%
% 08/03/10 adapated to claffey_matlab
%          added error catching to row58 part
% 11/05/09 cleadned up error message regarding psychportaudio
% 09/30/09 added check for PsychJava (ensures that ListenChar works)
% 09/27/09 improved check on PsychToolbox including check for libportaudio.0.0.19.dylib
% 09/20/09 check for stats toolbox
%          use renamed version of dataset_error_row58_check
% 05/01/09 original version

    everythings_okay = true;

%% matlab version
    
    % matlab version
    matlab_version = ver('MATLAB');
    matlab_version = matlab_version.Version;
    if ~strcmpi(matlab_version, '7.4')
        everythings_okay = false;
        fprintf('Matlab is version %s, instead of 7.4\n', matlab_version');
    end
       

    % license
    if ~strcmpi(license, 'STUDENT')
        fprintf('The license is %s. claffey_matlab was developed with the STUDENT license, \n\t but this is not necessarily a problem\n', license);
    end

%% dataset (stats toolbox)

	v = ver('stats');
    if isempty(v)
        everythings_okay = false;
        fprintf('Missing the Statistics Toolbox. Many claffey_matlab functions will not work\n.');
    elseif str2double(v.Version) < 6
        fprintf('Statistics Toolbox is older than version 6. This has not been tested and may not be compatible with claffey_matlab.\n.');
    end

%% psychtoolbox

    % check for psych toolbox in general
    ptb_version_file = which('PsychtoolboxVersion');
    if isempty(ptb_version_file)
        fprintf('Couldn''t find Psychtoolbox (www.psychtoolbox.org)\n');
        everythings_okay = false;
        
    else

        % check psychtoolbox version
        [v, vs] = PsychtoolboxVersion;
        if vs.major == 3 && vs.minor == 0 && vs.point == 8
            % okay
        else
            everythings_okay = false;
            fprintf('PsychToolbox is not version 3.0.8 (see below)\n')
            disp(v);
        end
        
        % check psych port audio
        if ~exist('/usr/local/lib/libportaudio.0.0.19.dylib', 'file')
            fprintf('You might have a problem with audio for PsychToolbox\n');
            fprintf('Try running InitializePsychSound. If it produces an error, ');
            fprintf('follow the instructions in the error regarding libportaudio.0.0.19.dylib\n');
        end
        
        % check ListenChar java
        try
            [junk] = evalc('ListenChar(0)');
            listenchar_error=false;
        catch
            listenchar_error=true;
        end 
        if listenchar_error
            fprintf('You have a java error with PsychToolbox.\n');
            fprintf('   For info, enter ''help PsychJavaTrouble''; point 3 applies to you\n');
            fprintf('   Run AddPsychJavaPath to fix this\n');
            everythings_okay = false;
        end
        
%        /Applications/MATLAB_SV74/toolbox/local/classpath.txt
        
    end

%% svn
        
    svn = GetSubversionPath_better;
    if isempty(svn)
        everythings_okay = false;
        fprintf('Doesn''t look like SVN is installed\n')
    end

%% claffey matlab

    claffey_matlab_path = which('claffey_matlab.m');
    if isempty(claffey_matlab_path)
        everythings_okay = false;
        fprintf('claffey_matlab is not installed or not in the path\n')
    elseif isempty(svn)
        everythings_okay = false;
        fprintf('Found claffey_matlab, but doesn''t appear to be using the svn version\n')
    else
        claffey_matlab_path = fileparts(claffey_matlab_path);
        [result, svn_output] = system(sprintf('%s/svnversion %s', svn, claffey_matlab_path));        
        if strfind(svn_output, 'M')
            everythings_okay = false;
            fprintf('Using a modified version of claffey_matlab (different than online repository)\n')
        end
    end

%% dataset row58 error

    if isempty(claffey_matlab_path)
        fprintf('claffey_matlab isn''t installed, so I can''t check the dataset row 58 error\n');
    else
        try
            [junk, row58_error_exists] = evalc('dataset_error_row58_check(true)');
            if row58_error_exists
                fprintf('The row 58 error needs to be fixed (%s)\n', link_text('matlab', 'dataset_error_row58_check();', 'click here'));
                everythings_okay = false;
            end
        catch
            fprintf('Normally I check for a built-in error in matlab''s dataset (row58 error) but I can not find dataset_error_row58_check.m\n   This doesn''t necessarily mean the dataset row58 error exists, just that I can''t check for it\n');
        end
    end

%% result

    if everythings_okay
        fprintf('Everything looks good.\n');
    end

    switch nargout
        case 0
            varargout = {};
        case 1
            varargout = {everythings_okay};
        otherwise
            error('Wrong number of outputs')
    end

end