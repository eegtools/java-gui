if question_appearance(1, curr_stimulus_num)
    
    webcamscreens = switch_capturing_webcam_screens(0, webcamscreens);
    if send_out_trigger
       put_trigger_linux(address, question_trigger_value,  trigger_duration, portnum);
       put_trigger_linux(address, pause_trigger_value,  trigger_duration, portnum);
    end  
    [nx, ny, textbounds] = DrawFormattedText(mainwnd, txt_question, 'center', 800, white, 55 , [], [], 1.5);
    Screen('Flip',mainwnd);
    
    showImageNseconds(question_image, subjects_screens{executing_subject}, question_time, 0, black);  % SHOW QUESTION IMAGE for question time seconds
    webcamscreens = switch_capturing_webcam_screens(executing_subject, webcamscreens);
    showCountDownEx(subjects_screens, 3, txt_pause_resume, txt_letsgo ,white, 55, black); 

    if send_out_trigger
        put_trigger_linux(address,resume_trigger_value,  trigger_duration, portnum);
    end        
end