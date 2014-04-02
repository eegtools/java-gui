if question_appearance(1, curr_stimulus_num)
    
    
    if send_out_trigger
       put_trigger_linux(address, question_trigger_value,  trigger_duration, portnum);
       put_trigger_linux(address, pause_trigger_value,  trigger_duration, portnum);
    end  
    [nx, ny, textbounds] = DrawFormattedText(mainwnd, txt_question, 'center', 'center', white, 55 , [], [], 1.5);
    Screen('Flip',mainwnd);
    
    showImageNseconds(question_image, subjects_screens{1}, question_time, 0, black);  % SHOW QUESTION IMAGE for question time seconds
    
    showCountDownEx(subjects_screens, 3, txt_pause_resume, txt_letsgo ,white, 55, black); 

    if send_out_trigger
        put_trigger_linux(address,resume_trigger_value,  trigger_duration, portnum);
    end        
end