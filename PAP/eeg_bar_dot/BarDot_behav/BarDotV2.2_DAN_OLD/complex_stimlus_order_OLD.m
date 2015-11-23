window = screen_param.window;
%  Execute max trial
try 
for j = 1:protocol_param.maxtrial
    if rem(j,str2double(setup_data{3})) == 0
        % DO eye calibration and the continue with stimulus
        single_trial_calib;        
    end
    idx = protocol_param.shuffle(j);
    % Disable output on stdout
    ListenChar(2);
    % Instruct to starting point
    str_exp = {'BAR' 'BARD' 'DOT'};
    str_cond = {'LEFT' 'RIGHT'};
    
    Screen('HideCursorHelper', window);
    Screen('Preference', 'TextRenderer', 1);
    Screen('TextSize',window, 21);
    DrawFormattedText(window, [str_cond{protocol_param.sequence.condition(idx)}],CROSS.xposition, CROSS.yposition, screen_param.color.white);
    Screen('Flip', window);
    
    %wait untill pressing a key to start trial
    [secs, keyCode, deltaSecs] = KbPressWait;
    ch = KbName(keyCode);
    % Change in lowercase
    ch = lower(ch);
    if ch == 'q'
        break
    end
    % START RECORDING VICON
    status = start_vicon(acquisition_flag, TTL_obj);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%
    % SHOW CROSS %
    %%%%%%%%%%%%%%
    
    err = show_stimuli(CROSS,window,screen_param);
    Screen('Flip', window);
    pause(protocol_param.isi);
    % Show Blank
    Screen('Flip', window);    
    % Show stymulus_type according to trial_type
    switch protocol_param.sequence.exp_type(idx)
        case 1 % BAR
            BAR.xstart = 0;
            BAR.xstop = screen_param.W;
            BAR.yposition = CROSS.yposition+protocol_param.deltabar;
            err = show_stimuli(BAR,window,screen_param);
            % In DEBUG MODE I display information about stimulus
            if DEBUG
                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                exp_mode = 'None';
                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);                
            end
            
        case 2 % BARD
            BARD.bar.xstart = 0;
            BARD.bar.xstop = screen_param.W;
            BARD.bar.yposition = CROSS.yposition+protocol_param.deltabar;
            %err = show_stimuli(BARD.bar,window,screen_param);
            % In DEBUG MODE I display information about stimulus
            if DEBUG
                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                exp_mode = 'None';
                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);                
            end
            
            switch protocol_param.sequence.condition(idx)
                case 1 % AIP:LEFT
                    % dot in random position in the right area
                      BARD.dot.xposition = protocol_param.randombardl(idx);
                      BARD.dot.yposition = CROSS.yposition+protocol_param.deltabar;
            
                    %err = show_stimuli(BARD.dot,window,screen_param);
                    
                case 2 % AIP:RIGHT
                    % dot in random position in the left area
                      BARD.dot.xposition = protocol_param.randombardr(idx);
                      BARD.dot.yposition = CROSS.yposition+protocol_param.deltabar;            
                    %err = show_stimuli(BARD.dot,window,screen_param);
            end
             err = show_stimuli(BARD,window,screen_param);
            

            
        case 3 % DOT 
            switch protocol_param.sequence.condition(idx)
                case 1 % AIP:LEFT
                    % dot in random position
                      DOT.xposition = protocol_param.randomdot(idx);
                      DOT.yposition = CROSS.yposition+protocol_param.deltabar;
                            if DEBUG
                                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                                exp_mode = 'Random';
                                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);
                            end
            
                    err = show_stimuli(DOT,window,screen_param);
                    
                case 2 % AIP:RIGHT
                    % dot in random position
                      DOT.xposition = protocol_param.randomdot(idx);
                      DOT.yposition = CROSS.yposition+protocol_param.deltabar;
                            if DEBUG
                                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                                exp_mode = 'Random';
                                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);
                            end
            
                    err = show_stimuli(DOT,window,screen_param);


            end        
    end
    Screen('Flip', window);
    if DEBUG
        %wait untill pressing a key to start trial
    [secs, keyCode, deltaSecs] = KbPressWait;
    end
    pause(2.5); %stimulus duration
    err = show_stimuli(CROSS,window,screen_param);
    Screen('Flip', window);
    pause(protocol_param.isi);
    % Wait necessary time
    % STOP RECORDING VICON 
    status = stop_vicon(acquisition_flag, TTL_obj);
end
ListenChar(0);
catch err
    Screen('CloseAll');
    sca
    err.message
    err.stack
end