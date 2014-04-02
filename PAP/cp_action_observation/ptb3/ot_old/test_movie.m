black = [0 0 0];
PsychGPUControl('FullScreenWindowDisablesCompositor', 1);
rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
% rec = [0,0,1280,800]; W=1280; H=800;


Screen('Preference', 'SkipSyncTests', 1);
 
[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;


showMovie('/data/projects/cp_action_observation/eprime/video/ctrl01_c.wmv', rect);