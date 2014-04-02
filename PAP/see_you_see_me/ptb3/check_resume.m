while is_paused == 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(r_key)
            is_paused=0;
            
            [nx, ny, textbounds] = DrawFormattedText(mainwnd, txt_resuming, 'center', 800, white, 55 , [], [], 1.5);
            Screen('Flip',mainwnd);              
            
            showCountDownEx(subjects_screens, 3,txt_pause_resume, txt_letsgo , white, 55, black);
            if send_out_trigger
                put_trigger_linux(address,resume_trigger_value,  trigger_duration, portnum);
            end
            webcamscreens = switch_capturing_webcam_screens(observing_subject, webcamscreens);
            fwrite(fp, ['exit pause @ : ' num2str(GetSecs-experiment_start_time) char([13 10])]);
            WaitSecs(3);
        end
    end 
end
