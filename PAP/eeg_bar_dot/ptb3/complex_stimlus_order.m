window = screen_param.window;
%  Execute max trial
try 
put_trigger_lptwrite(address, protocol_param.eeg_triggers.experiment_start, protocol_param.posttrigger_time);
for j = 1:protocol_param.maxtrial
    
    % is even?
    isEven=0;
    if round(j/2) == j/2
        isEven=1;
    end
    
    if rem(j,str2double(setup_data{3})) == 0
        % DO eye calibration and the continue with stimulus
        put_trigger_lptwrite(address, protocol_param.eeg_triggers.calibrate_start, protocol_param.posttrigger_time);
        single_trial_calib;      
        put_trigger_lptwrite(address, protocol_param.eeg_triggers.calibrate_end, protocol_param.posttrigger_time);
    end
    idx = protocol_param.shuffle(j);
    % Disable output on stdout
    ListenChar(2);
    % Instruct to starting point
    str_exp = {'BAR' 'DOT'};
    str_cond = {'LEFT' 'RIGHT'};
    
    Screen('HideCursorHelper', window);
    Screen('Preference', 'TextRenderer', 1);
    Screen('TextSize',window, 21);
    
    if protocol_param.sequence.condition(idx)== 1
        DrawFormattedText(window, [str_cond{protocol_param.sequence.condition(idx)}],protocol_param.xleft, CROSS.yposition, screen_param.color.white);
    else
        DrawFormattedText(window, [str_cond{protocol_param.sequence.condition(idx)}],protocol_param.xright, CROSS.yposition, screen_param.color.white);
    end
    %DrawFormattedText(window, [str_cond{protocol_param.sequence.condition(idx)}],CROSS.xposition, CROSS.yposition, screen_param.color.white);
    %modified, need to be checked
    
    Screen('Flip', window);
    
    %wait untill pressing a key to start trial
    put_trigger_lptwrite(address, protocol_param.eeg_triggers.pause_start, protocol_param.posttrigger_time);
    [secs, keyCode, deltaSecs] = KbPressWait;
    ch = KbName(keyCode);
    % Change in lowercase
    ch = lower(ch);
    if ch == 'q'
        break
    end
    put_trigger_lptwrite(address, protocol_param.eeg_triggers.pause_end, protocol_param.posttrigger_time);
    WaitSecs(protocol_param.post_resume_time); ... this 1sec interval will represent the baseline for EEG
    %%%%%%%%%%%%%%
    % SHOW CROSS %
    %%%%%%%%%%%%%%
    
    err = show_stimuli(CROSS,window,screen_param);
    Screen('Flip', window);
    
    pause(protocol_param.isi1);
    
    % START RECORDING NI
    status = cdaq_start_task;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pause(protocol_param.isi2);
    
    % Show Blank
    Screen('Flip', window);    
    stimulus_type=protocol_param.sequence.exp_type(idx);
    % Show stymulus_type according to trial_type
    switch stimulus_type
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

            
        case 2 % DOT 
                    if isEven 
                      DOT.xposition = protocol_param.xleft;
                      DOT.yposition = CROSS.yposition+protocol_param.deltabar;
                            if DEBUG
                                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                                exp_mode = 'RandomL';
                                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);
                            end
            
                      err = show_stimuli(DOT,window,screen_param);
                    else
                        DOT.xposition = protocol_param.xright;
                        DOT.yposition = CROSS.yposition+protocol_param.deltabar;
                            if DEBUG
                                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                                exp_mode = 'RandomR';
                                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);
                            end
            
                    err = show_stimuli(DOT,window,screen_param);
                    end
                     
    end
    Screen('Flip', window);
    
    if isEven
        eeg_code=16 + 4*stimulus_type;
    else
        eeg_code=16 + 4*stimulus_type + 2;
    end
    put_trigger_lptwrite(address, eeg_code, protocol_param.posttrigger_time);
   
    if DEBUG
        %wait untill pressing a key to start trial
    [secs, keyCode, deltaSecs] = KbPressWait;
    end
    
    pause(protocol_param.poststimulus_recording); %stimulus duration
    %err = show_stimuli(CROSS,window,screen_param);  %Screen('Flip', window); %pause(protocol_param.isi);  % Wait necessary time
    
    % STOP RECORDING NI and RETRIEVE DATA FROM ITS BUFFER 
    write_accel_data(j, eeg_code, output_accel_data_path);
end
put_trigger_lptwrite(address, protocol_param.eeg_triggers.experiment_end, protocol_param.posttrigger_time);

ListenChar(0);
catch err
    Screen('CloseAll');
    sca
    err.message
    err.stack
end