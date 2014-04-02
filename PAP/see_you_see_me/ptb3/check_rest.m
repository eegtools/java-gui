if rest_appearence(1, curr_stimulus_num) == 1
    switch_capturing_webcam_screens(0, webcamscreens);
    if send_out_trigger
        put_trigger_linux(address,pause_trigger_value,  trigger_duration, portnum);
    end   

    for w=1:num_scr         
        [nx, ny, textbounds] = DrawFormattedText(subjects_screens{w},txt_big_pause,'center','center',white, 55 ,[],[],1.5);
        Screen('Flip',subjects_screens{w});
    end
    KbWait;
    webcamscreens = switch_capturing_webcam_screens(executing_subject, webcamscreens);
    % show a 3 seconds countdown panel
    showCountDownEx(subjects_screens, 3,txt_pause_resume, txt_letsgo ,white, 55, black); 
    if send_out_trigger
        put_trigger_linux(address,resume_trigger_value,  trigger_duration, portnum);
    end       
end