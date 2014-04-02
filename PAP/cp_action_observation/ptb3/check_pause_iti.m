iti=round((iti_time+rand(1))*100)/100;
can_pause=1;
start_time=GetSecs;
while is_paused == 0
    [keyIsDown,secs, keyCode] = KbCheck;
    if (keyIsDown && can_pause == 1)
        if keyCode(q_key)
            do_quit=1;
            break;
        end          
        if keyCode(p_key)
            is_paused=1;
            WaitSecs(0.5);
            if send_out_trigger
                put_trigger(pause_trigger_value, dio, trigger_duration);
            end                
            break
        end
    end 
    elapsed=GetSecs-start_time;
    if elapsed > iti
        break;
    end            

end  
can_pause=0;