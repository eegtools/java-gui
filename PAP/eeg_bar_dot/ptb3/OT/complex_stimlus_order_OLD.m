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
    str_exp = {'BAR' 'BARD' 'DOT' 'DOTD'};
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
    [secs, keyCode, deltaSecs] = KbPressWait;
    ch = KbName(keyCode);
    % Change in lowercase
    ch = lower(ch);
    if ch == 'q'
        break
    end
   
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
%             switch protocol_param.sequence.condition(idx)
%                 case 1 % AIP:LEFT
                    % dot in random position
                    if round(idx/2) == idx/2 
                      DOT.xposition = protocol_param.randomdotl(idx);
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
                        DOT.xposition = protocol_param.randomdotr(idx);
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

                    
%                 case 2 % AIP:RIGHT
%                     % dot in random position
%                     
% %                       DOT.xposition = protocol_param.randomdotr(idx);
% %                       DOT.yposition = CROSS.yposition+protocol_param.deltabar;
% %                             if DEBUG
% %                                 exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
% %                                 exp_cond = str_cond{protocol_param.sequence.condition(idx)};
% %                                 exp_mode = 'RandomR';
% %                                 DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
% %                                 DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
% %                                 DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);
% %                             end
% %             
% %                     err = show_stimuli(DOT,window,screen_param);
% 
% 
%             end        
            
            case 4 % DOTD 
%             switch protocol_param.sequence.condition(idx)
%                 case 1 % AIP:LEFT
                    % dot in random position
                    if round(idx/2)== idx/2
                      DOTD.dot.xposition = protocol_param.randomdotl(idx);
                      DOTD.dot.yposition = CROSS.yposition+protocol_param.deltabar;
                      DOTD.dis.xposition = protocol_param.randomdotr(idx);
                      DOTD.dis.yposition = CROSS.yposition+protocol_param.deltabar;
                            if DEBUG
                                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                                exp_mode = 'RandomL';
                                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);
                            end
            
                    err = show_stimuli(DOTD,window,screen_param);
                    
%                 case 2 % AIP:RIGHT
%                     % dot in random position
                    else
                      DOTD.dot.xposition = protocol_param.randomdotr(idx);
                      DOTD.dot.yposition = CROSS.yposition+protocol_param.deltabar;
                      DOTD.dis.xposition = protocol_param.randomdotl(idx);
                      DOTD.dis.yposition = CROSS.yposition+protocol_param.deltabar;
                            if DEBUG
                                exp_type = str_exp{protocol_param.sequence.exp_type(idx)};
                                exp_cond = str_cond{protocol_param.sequence.condition(idx)};
                                exp_mode = 'RandomR';
                                DrawFormattedText(window, exp_type,'Center', 50, screen_param.color.white);
                                DrawFormattedText(window, exp_cond,'Center', 70, screen_param.color.white);
                                DrawFormattedText(window, exp_mode,'Center', 90, screen_param.color.white);
                            end
            
                    err = show_stimuli(DOTD,window,screen_param);


                     end        
    end
    Screen('Flip', window);
    lptwrite(address,stimulus_type);
    if DEBUG
        %wait untill pressing a key to start trial
    [secs, keyCode, deltaSecs] = KbPressWait;
    end
    
    pause(protocol_param.poststimulus_recording); %stimulus duration
    %err = show_stimuli(CROSS,window,screen_param);
    %Screen('Flip', window);
    %pause(protocol_param.isi);
    % Wait necessary time
    % STOP RECORDING NI and RETRIEVE DATA FROM ITS BUFFER 
    acceldata(j).data = cdaq_read_data;
    acceldata(j).cond = stimulus_type;
end
ListenChar(0);
catch err
    Screen('CloseAll');
    sca
    err.message
    err.stack
end