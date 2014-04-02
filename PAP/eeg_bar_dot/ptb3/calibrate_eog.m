window = screen_param.window;
Screen('HideCursorHelper', window);
Screen('Preference', 'TextRenderer', 1);
Screen('TextSize',window, 21);
% Instruct to starting point using trial_type

DrawFormattedText(window, 'Fix the stimulus on the screen','Center', CROSS.yposition, screen_param.color.white);
Screen('Flip', window);
pause(2);
Screen('Flip', window);
ListenChar(2);

pause(1);
for j = 1:protocol_param.Ndots    
    % Show Cross
    err = show_stimuli(CROSS,window,screen_param);
    Screen('Flip', window);
    pause(protocol_param.eog_calib_time);
    
    % Show Dot
    DOT.xposition = protocol_param.calibpos(j);   
    DOT.yposition = CROSS.yposition;
    err = show_stimuli(DOT,window,screen_param);
    Screen('Flip', window);
    pause(protocol_param.eog_calib_time); 
    lptwrite(address,0);
end
Screen('Flip', window);
pause(1);

%status = stop_vicon(acquisition_flag, TTL_obj);
ListenChar(0);