black = [0 0 0];
PsychGPUControl('FullScreenWindowDisablesCompositor', 1);
rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
% rec = [0,0,1280,800]; W=1280; H=800;


Screen('Preference', 'SkipSyncTests', 1);
 
[window, rect] = Screen('OpenWindow', 0, black, rec);
...monitorFlipInterval = Screen('GetFlipInterval', window);
...monitor_freq = 1/monitorFlipInterval;


while 1
    ...showMovie('test_rotated.avi', window, 'input_rect', [100 100 1024 768],'output_rect', [0 150 1024 918 ], 'rotation', 0);
    ...showMovie('test_rotated.avi', window, 'input_rect', [0 0 1024 768],'output_rect', [0 0 1024 768 ], 'rotation', 0);
    showMovie('test_rotated.avi', window, 'input_rect', [],'output_rect', [0 150 1024 918], 'rotation', 90);
    if KbCheck
        break;
    end;
end

sca