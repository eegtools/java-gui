% ===================================================================
% SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

black = [0 0 0];
fullsize=0;

W=1027; H=500; rec = [0,0,W,H]; 
...rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

try
    AssertOpenGL;
    
    devices = Screen('VideoCaptureDevices');
    device_id_1=20000;
    device_id_2=20001;
    fps=30;
    dimension=[0 0 640 480];
    

    Screen('Flip',window);

    %videoPtr = Screen('OpenVideoCapture', windowPtr [, deviceIndex] [,roirectangle] [, pixeldepth] [, numbuffers] [, allowfallback] [, targetmoviename] [, recordingflags] [, captureEngineType]);
    grabber1 = Screen('OpenVideoCapture', window, device_id_1, dimension); ..., 0);
    ...grabber2 = Screen('OpenVideoCapture', window, 0, [340 0 660 240], 1, [], []);

    Screen('StartVideoCapture', grabber1, fps, 1);
    
    t=GetSecs;
    while (GetSecs - t) < 600 
        if KbCheck
            break;
        end;
        
        [tex pts nrdropped]=Screen('GetCapturedImage', window, grabber1, 1);
        if (tex>0)
            % Perform first-time setup of transformations, if needed:
            if fullsize
                texrect = Screen('Rect', tex);
                winrect = Screen('Rect', window);
                sf = min([RectWidth(winrect) / RectWidth(texrect) , RectHeight(winrect) / RectHeight(texrect)]);
                dstRect = CenterRect(ScaleRect(texrect, sf, sf) , winrect);
            end
            
            Screen('DrawTexture', window, tex, [], dstRect);
            Screen('Flip', window);
            Screen('Close', tex);
        end
    end
    Screen('StopVideoCapture', grabber1);    
    Screen('CloseVideoCapture', grabber1);    

catch
    Screen('StopVideoCapture', grabber1);    
    Screen('CloseVideoCapture', grabber1);    
    Screen('CloseAll');
end
