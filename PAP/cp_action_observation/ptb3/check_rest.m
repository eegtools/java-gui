if rest_appearence(1, curr_stimulus_num) == 1
    if send_out_trigger
        put_trigger(pause_trigger_value, dio, trigger_duration);
    end   

    if do_question_pause == 0
        % ADULTS
        [nx, ny, textbounds] = DrawFormattedText(window,txt_big_pause,'center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        KbWait;
    else
        % CHILDREN
        playAudio(success_audio, ao);
        showImageNseconds(prepause_photos{curr_block}, window, question_time);
        showMovie(pause_videos{curr_block}, window);
        [nx, ny, textbounds] = DrawFormattedText(window,txt_big_pause_resume,'center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        KbWait;
    end
    % show a 3 seconds countdown panel
    showCountDown(window, 3,txt_pause_resume, txt_letsgo ,white, 55); 
    if send_out_trigger
        put_trigger(resume_trigger_value, dio, trigger_duration);
    end       
    curr_block=curr_block+1;
end