InitializePsychSound(1);


try
    % Try with the 'freq'uency we wanted:
     pahandle = PsychPortAudio('Open', [], [], 2, [], 2);
catch err
    % Failed. Retry with default frequency as suggested by device:
    disp('Could not open sound device');
    psychlasterror('reset');

end
% pahandle = PsychPortAudio('Open', [], [], 2, [], 2, [], 0.01);

black = [0 0 0];
PsychGPUControl('FullScreenWindowDisablesCompositor', 1);
%rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
rec = [0,0,1280,800]; W=1280; H=800;

Screen('Preference', 'SkipSyncTests', 0);
 
[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

test_showMovieSendDoubleTrigger_getVolume('/data/projects/cp_action_observation/video/aois02.mp4', window, '', 1, 45, 2, pahandle);

 PsychPortAudio('Close', pahandle);
sca;