rec = [0,0,1280,768]; W=1280; H=768;

[window, rect] = Screen('OpenWindow', 0, black, rec);

is_paused=0;

while 1
    
    if is_paused == 1
       
        [nx ny textbounds] = DrawFormattedText(window,'PAUSED','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
        if keyIsDown
            if KbName(keyCode) == 'p'
                is_paused=~is_paused;
                WaitSecs(0.2);
            end
        end
    else

        [nx ny textbounds] = DrawFormattedText(window,'GO','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
        if keyIsDown
            if KbName(keyCode) == 'p'
                is_paused=~is_paused;
                WaitSecs(0.2);
            end
        end        
        
    end
end