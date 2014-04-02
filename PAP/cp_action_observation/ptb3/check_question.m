if question_appearance(1,curr_stimulus_num)
    if send_out_trigger
       put_trigger(question_trigger_value, dio, trigger_duration);
       put_trigger(pause_trigger_value, dio, trigger_duration);
    end  
    if do_question_pause == 1
        keypressed = showImageNseconds(question_image, window, 0);  % SHOW QUESTION IMAGE and STOP
        %CHILDREN
        correct=0;
        if keypressed(y_key)
            fb_answers{curr_block}=fb_answers{curr_block}+1;
            correct=1;
        end
        if fb_answers{curr_block} == 0
            source = fullfile(fb_roots{curr_block}, feedback_files{curr_block,1});
        else
            source = fullfile(fb_roots{curr_block}, feedback_files{curr_block,fb_answers{curr_block}});
        end
        if correct == 1
            playAudio(success_audio, ao);
        end
        showImageNseconds(source, window, question_time);

        if curr_block == 3
            source = fullfile(fb_roots{curr_block}, feedback_files{4, fb_answers{curr_block}});
            showMovie(source, window);
        else
        end
        Screen('FillRect', window, black, rect);
        Screen('Flip', window);            
        showCountDown(window, 3, txt_pause_resume, txt_letsgo ,white, 55); 
    else
        %ADULTS
        showImageNseconds(question_image, window, question_time);  % SHOW QUESTION IMAGE for question time seconds
        Screen('FillRect', window, black, rect);
        Screen('Flip', window);             
        showCountDown(window, 3, txt_pause_resume, txt_letsgo ,white, 55); 
    end
    if send_out_trigger
        put_trigger(resume_trigger_value, dio, trigger_duration);
    end        
end
