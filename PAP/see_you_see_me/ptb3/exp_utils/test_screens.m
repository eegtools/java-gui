% ===================================================================
% SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);
Screen('Preference', 'TextRenderer', 2)
black = [0 0 0];
white = [255 255 255];
fullsize=0;

W=1027; H=500; rec = [0,0,W,H]; 
...rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);

try
    AssertOpenGL;
    screens = Screen('Screens');
    num_screen=length(screens);
    
    
    for sc=0:(num_screen-1)
        [windows{sc+1}, rect] = Screen('OpenWindow', sc, black, rec);
        [oldFontName,oldFontNumber]=Screen('TextFont', windows{sc+1}, '-schumacher-clean-bold-r-normal--0-0-75-75-c-0-iso646.1991-irv');
        [nx, ny, textbounds] = DrawFormattedText(windows{sc+1},num2str(sc),'center','center',white, 55 ,[],[],1.5);
        Screen('Flip', windows{sc+1});
    end
    
    monitorFlipInterval = Screen('GetFlipInterval', windows{1});
    monitor_freq = 1/monitorFlipInterval;
     
catch
    Screen('CloseAll');
end
