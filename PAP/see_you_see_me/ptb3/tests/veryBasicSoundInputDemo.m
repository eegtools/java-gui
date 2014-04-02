function record_sound(wavfilename, device_id, maxsecs)

% Open the audio device : device_id
% with mode 2 (== Only audio capture),
% a required latencyclass of zero 0 == no low-latency mode
% a frequency of 22050 Hz and 2 sound channels for stereo capture.
% This returns a handle to the audio device:
freq = 22050;
pahandle = PsychPortAudio('Open', device_id, 2, 0, freq, 2);

% Preallocate an internal audio recording  buffer with a capacity of maxsecs seconds:
PsychPortAudio('GetAudioData', pahandle, maxsecs);

% Start audio capture immediately and wait for the capture to start.
% We set the number of 'repetitions' to zero,
% i.e. record until recording is manually stopped.
PsychPortAudio('Start', pahandle, 0, 0, 1);
recordedaudio = [];


% We retrieve status once to get access to SampleRate:
s = PsychPortAudio('GetStatus', pahandle);

% Stay in a little loop until keypress:
while ~KbCheck && ((length(recordedaudio) / s.SampleRate) < maxsecs)
    % Wait a second...
    WaitSecs(1);
    
    % Query current capture status and print it to the Matlab window:
    s = PsychPortAudio('GetStatus', pahandle);
    
    % Print it:
    fprintf('\n\nAudio capture started, press any key for about 1 second to quit.\n');
    fprintf('This is some status output of PsychPortAudio:\n');
    disp(s);
    
    % Retrieve pending audio data from the drivers internal ringbuffer:
    audiodata = PsychPortAudio('GetAudioData', pahandle);
    nrsamples = size(audiodata, 2);
    
    % Plot it, just for the fun of it:
    plot(1:nrsamples, audiodata(1,:), 'r', 1:nrsamples, audiodata(2,:), 'b');
    drawnow;
    
    % And attach it to our full sound vector:
    recordedaudio = [recordedaudio audiodata]; %#ok<AGROW>
end

% Stop capture:
PsychPortAudio('Stop', pahandle);

% Perform a last fetch operation to get all remaining data from the capture engine:
audiodata = PsychPortAudio('GetAudioData', pahandle);

% Attach it to our full sound vector:
recordedaudio = [recordedaudio audiodata];

% Close the audio device:
PsychPortAudio('Close', pahandle);

% Shall we store recorded sound to wavfile?
if ~isempty(wavfilename)
    wavwrite(transpose(recordedaudio), 44100, 16, wavfilename)
end

% Done.
fprintf('Demo finished, bye!\n');

