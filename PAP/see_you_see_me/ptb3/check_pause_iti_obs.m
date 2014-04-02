iti=round((iti_time+rand(1))*100)/100;
can_pause=1;
start_time=GetSecs;
while is_paused == 0

    [nx, ny, textbounds] = DrawFormattedText(mainwnd, txt_start_iti, 'center', 'center', white, 55 , [], [], 1.5);
    Screen('Flip',mainwnd);        

    [keyIsDown,secs, keyCode] = KbCheck;
    if (keyIsDown && can_pause == 1)
        if keyCode(q_key)
            do_quit=1;
            break;
        end            
        if keyCode(p_key)
            is_paused=1;
            WaitSecs(0.04);
            if send_out_trigger
                put_trigger_linux(address, pause_trigger_value, trigger_duration, portnum);
            end  
            
            fwrite(fp, ['enter pause @ : ' num2str(GetSecs-experiment_start_time) char([13 10])]);

            for w=1:num_scr 
                [nx, ny, textbounds] = DrawFormattedText(subjects_screens{w},txt_pause,'center','center',white, 55 ,[],[],1.5);
                Screen('Flip', subjects_screens{w});
            end   
            [nx, ny, textbounds] = DrawFormattedText(mainwnd, txt_pause, 'center', 'center', white, 55 ,[],[],1.5);
            Screen('Flip', mainwnd);               

            break
        end
    end 
    elapsed=GetSecs-start_time;
    if elapsed > iti
        break;
    end            
end  
can_pause=0;
