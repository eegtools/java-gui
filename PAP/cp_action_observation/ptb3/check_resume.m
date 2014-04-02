while is_paused == 1
    [nx, ny, textbounds] = DrawFormattedText(window,txt_pause,'center','center',white, 55 ,[],[],1.5);
    Screen('Flip',window);
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(r_key)
            is_paused=0;
            showCountDown(window, 3,txt_pause_resume, txt_letsgo , white, 55);
            if send_out_trigger
                put_trigger(resume_trigger_value, dio, trigger_duration);
                WaitSecs(1);
            end
        end
    end 
end
