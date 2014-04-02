% © EOG VICON ©
% Protocol for Visuo - Hand coordination in non-constrained targeting
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
%
% This function is used to record the mean position [in pixel] of hand
% pointing in left and right starting condition. This data are used in
% parameters structure.

function pointing_data_normalized = record_left_right_baseline(setup_data,screen_param,DEBUG)
left_right = 0;

if DEBUG == 1
    % Set to default data sono i dati dell'acquisizione di MaJa
    pointing_data_normalized.leftmean = [502 500];
    pointing_data_normalized.rightmean = [904 500];
    pointing_data_normalized.ypos = 702;
    U = (pointing_data_normalized.rightmean-pointing_data_normalized.leftmean)/2;
        pointing_data_normalized.U = U(1);
else
    try
        % Create Black Screen
        [window, rect] = Screen('OpenWindow', 0, screen_param.color.black , screen_param.rect);
        monitorFlipInterval = Screen('GetFlipInterval', window); 
        % Show bar and move with cursor to identify Y position for subject
        flag_bar_calib = 1;
        ypos = 500;
        delta  = 1;
        counter = 0;
        while flag_bar_calib
            % Draw bar            
            mtx_coord =[0, screen_param.W ; ypos, ypos];
            dim = 8; % Line Dimension
            Screen('Preference', 'TextRenderer', 1);
            Screen('TextSize',window, 18);
            DrawFormattedText(window, 'Use UP-DOWN arrow keys to move bar, ENTER to finish' , 'center',100, screen_param.color.white);
            Screen('DrawLines', window, mtx_coord,dim,screen_param.color.gray);
            Screen('Flip', window);
            FlushEvents;
            [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
            if keyIsDown  
                counter = counter + 1;
                delta = ceil(counter/20);
                ch = KbName(keyCode);
                % Change in lowercase
                ch = lower(ch);
                switch ch
                    case 'up'
                        ypos = ypos - delta;
                    case 'down'
                        ypos = ypos + delta;
                    case 'return'
                        flag_bar_calib = 0;
                end
            else
                delta = 1;
                counter = 0;
            end
        end
        
        N_of_trial = str2num(setup_data{5});
        str_condition = {'Left','Right'};
        
        for trial = 1:N_of_trial
            for condition = 1:2 % Right Left COndition
                % Display TASK
                % Wait for user action to start acquisition
                Screen('HideCursorHelper', window);
                Screen('Preference', 'TextRenderer', 1);
                Screen('TextSize',window, 21);
                DrawFormattedText(window, ['Trial : ' num2str(trial) ' ' str_condition{condition} ],'Center', 400, screen_param.color.white);
                Screen('Flip', window);
                FlushEvents;
                [secs, keyCode, deltaSecs] = KbPressWait;
                Screen('Flip', window);
                % Draw bar
                mtx_coord =[0, screen_param.W ; ypos, ypos];
                dim = 8; % Line Dimension
                Screen('DrawLines', window, mtx_coord,dim,screen_param.color.gray);
                if (trial>1) && (condition == 1)
                    DrawFormattedText(window, ['Distance [px] = ' num2str(D)],'Center', 50, screen_param.color.white);
                end
                Screen('Flip', window);
                
                % Wait for keyboard event and show cursor
                
                [secs, keyCode, deltaSecs] = KbPressWait;
                % Show cursor
                ShowCursor('Arrow');
                % Retrive position of clicking
                % Cycle until buttons is clicked
                clicked = 0;
                while not(clicked)
                    [x,y,buttons] = GetMouse;
                    if sum(buttons) > 0
                        clicked = 1;
                        pointing_data_normalized.(str_condition{condition})(trial,1) = x;
                        pointing_data_normalized.(str_condition{condition})(trial,2) = y;
                    end
                end % Waiting click
            end % Condition LEFT RIGHT
            
            % We can compute difference between two point
            leftmean = mean(pointing_data_normalized.Left);
            rightmean = mean(pointing_data_normalized.Right);
            D = rightmean(1) - leftmean(1);
        end % Number of Trials
        
        
        % Genero la struttura specificando anche l'unità U dalla quale
        % verranno calcolate le distanza tra i due DOT
        pointing_data_normalized.leftmean = mean(pointing_data_normalized.Left);
        pointing_data_normalized.rightmean = mean(pointing_data_normalized.Right);
        pointing_data_normalized.ypos = ypos ;
        U = (pointing_data_normalized.rightmean-pointing_data_normalized.leftmean)/2;
        pointing_data_normalized.U = U(1);
        
        
        Screen('HideCursorHelper', window);
        Screen('Preference', 'TextRenderer', 1);
        Screen('TextSize',window, 21);
        DrawFormattedText(window, 'Thank you!!','Center', 'Center', screen_param.color.white);
        
        DrawFormattedText(window, '|', pointing_data_normalized.leftmean(1), ypos, screen_param.color.white);
        DrawFormattedText(window, '|', pointing_data_normalized.rightmean(1), ypos, screen_param.color.white);
        DrawFormattedText(window, '-', pointing_data_normalized.leftmean(1)+D/2, ypos, screen_param.color.white);
        DrawFormattedText(window, '|', pointing_data_normalized.leftmean(1)+D/2, ypos, screen_param.color.white);
        % Draw all points
        for jj = 1:N_of_trial
            DrawFormattedText(window, '.', pointing_data_normalized.Left(jj,1), ypos, screen_param.color.white);
            DrawFormattedText(window, '.', pointing_data_normalized.Right(jj,1), ypos, screen_param.color.white);
                      
        end
        DrawFormattedText(window, ['Distance [px] = ' num2str(D)],'Center', 50, screen_param.color.white);

        Screen('Flip', window);
        FlushEvents;
        pause;
        sca
    catch err
        Screen('CloseAll');
        sca
        err.message
        err.stack.line
        pause
    end
end
