%this is the introduction to the experiment, written from scratch

clear all 
%close all
%cd('C:\Documents and Settings\alejo\My Documents\MATLAB\pozzo_experiment_computer_stimuli')

try
    ListenChar(2);
    load stimuli_pozzo_11_03_10
    delta_y_scramble2=-50;
    flipSpdback = 0;
    flipSpdwindow = 0;
    black = [0 0 0];
    red = [200 50 50];
    white = [255 255 255];
    green=[10 255 10];
    dot_size = 4;
    stimulus_time=1;    %time of presentation for each stimulus in seconds
    intro_time=2;       %time of the red fixation cross at the beginning of the experimental block
    isi_time=3;         %inter stimulus time in seconds
    green_time=0.25; %time in seconds of the color changing of odd stimuli
    
    N_type_stim=4;
    N_stimuli=12;
    A=1:N_type_stim;
    B=repmat(A,1,N_stimuli/N_type_stim);
    permutation=randperm(N_stimuli);
    Presentation=B(permutation);
    
    %rec = Screen('Rect',0);     [W, H]=Screen('WindowSize', 0);
    W=1200; H=900; rec = [0,0,W,H]; 
    
    [window, rect] = Screen('OpenWindow', 0, black, rec);
    monitorFlipInterval = Screen('GetFlipInterval', window);
    Screen('TextSize', window ,30);
    monitor_freq = 1/monitorFlipInterval;
    stimulus_frames=ceil(monitor_freq*stimulus_time); %number of frames corresponding to stimulus_time seconds
    intro_frames=round(monitor_freq*intro_time);
    isi_frames=round(monitor_freq*isi_time);
    green_frames=round(monitor_freq*green_time);
    possible_start=stimulus_frames-green_frames;
    cycle_gait_time=1.2167;
    cycle_gait_frames=round(cycle_gait_time*monitor_freq);
    shift_gait=floor(cycle_gait_frames/10);
                                                     
    %----CROCE----------------------------------------------------
    cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];
    %-------------------------------------------------------------
    deltay_walkers=-10;
    mean_init_x=mean(trans_walker(1,:,1),2);
    translation_x_twalker=repmat([round(W/2-mean_init_x) ; 0],1,13);
    mean_init_y=mean(trans_walker(2,:,1),2);
    translation_y_twalker=repmat([0 ; round(H/2-mean_init_y+deltay_walkers)],1,13);
    mean_init_x=mean(trans_scramble(1,:,1),2);
    translation_x_tscramble=repmat([round(W/2-mean_init_x) ; 0],1,13);
    mean_init_y=mean(trans_scramble(2,:,1),2);
    translation_y_tscramble=repmat([0 ; round(H/2-mean_init_y)],1,13);
    translation_y_cwalker=repmat([0 ; deltay_walkers],1,13);
    HideCursor;
    cont_training='1';
    
    y_key = KbName('y');    ... y
    n_key = KbName('n');    ... n 
    
    
    while 1
        [nx ny textbounds] = DrawFormattedText(window,char(strcat('Grazie per partecipare al nostro esperimento!', ...
           ' Premi un tasto per vedere i 4 tipi di video che vedrai durante la sessione sperimentale')) ,'center','center',white, 45 ,[],[],1.5);
        Screen('Flip',window);
        WaitSecs(.2);
        KbWait;

        for i=1:intro_frames
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('Flip', window);
        end
        [nx ny textbounds] = DrawFormattedText(window,' Video #1' ,'center','center',white,60,[],[],1.5);

        Screen('Flip',window);
        WaitSecs(2);
        for i=1:intro_frames
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('Flip', window);
        end
        %FAI VEDERE IL WALKER CENTRATO
        for i=1:stimulus_frames
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('FillOval', window, white, round([squeeze(center_walker(:,:,i))+translation_y_cwalker- dot_size ; squeeze(center_walker(:,:,i)) + translation_y_cwalker + dot_size]));
            Screen('Flip', window);
        end

        [nx ny textbounds] = DrawFormattedText(window,'Video #2' ,'center','center',white,60,[],[],1.5);
        Screen('Flip',window);
        WaitSecs(2);
        for i=1:intro_frames
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('Flip', window);
        end
        %FAI VEDERE IL WALKER CHE TRASLA
        for i=1:stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb)
            Screen('DrawLines', window, cross_center, 3, red);
            %                         Screen('FillOval', window, green, round([squeeze(trans_walker(:,:,phase_fr))+translation_x+translation_y_twalker - dot_size ; squeeze(trans_walker(:,:,phase_fr))+translation_x + translation_y_twalker+ dot_size]));

            Screen('FillOval', window, white, round([squeeze(trans_walker(:,:,i))+translation_x_twalker+translation_y_twalker - dot_size ; squeeze(trans_walker(:,:,i))+translation_x_twalker + translation_y_twalker+ dot_size]));
            Screen('Flip', window);

        end
        [nx ny textbounds] = DrawFormattedText(window,'Video #3' ,'center','center',white,60,[],[],1.5);
        Screen('Flip',window);
        WaitSecs(2);
        for i=1:intro_frames
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('Flip', window);
        end
        %FAI VEDERE LO SCRAMBLE CENTRATO
        for i=1:stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb)
            Screen('DrawLines', window, cross_center, 3, red);
            %                         Screen('FillOval', window, green, round([squeeze(center_scramble(:,:,phase_fr))+0 - dot_size ; squeeze(center_scramble(:,:,phase_fr))+0 + dot_size]));
            Screen('FillOval', window, white, round([squeeze(center_scramble(:,:,i))+0 - dot_size ; squeeze(center_scramble(:,:,i))+0 + dot_size]));
            Screen('Flip', window);

        end
        [nx ny textbounds] = DrawFormattedText(window,'Video #4' ,'center','center',white,60,[],[],1.5);
        Screen('Flip',window);
        WaitSecs(2);
        for i=1:intro_frames
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('Flip', window);
        end
        %FAI VEDERE LO SCRAMBLE CHE TRASLA
        for i=1:stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb)
            Screen('DrawLines', window, cross_center, 3, red);
            %                         Screen('FillOval', window, green, round([squeeze(trans_scramble(:,:,phase_fr))+translation_x+translation_y_tscramble - dot_size ; squeeze(trans_scramble(:,:,phase_fr))+translation_x+translation_y_tscramble+ dot_size]));
            Screen('FillOval', window, white, round([squeeze(trans_scramble(:,:,i))+translation_x_tscramble+translation_y_tscramble - dot_size ; squeeze(trans_scramble(:,:,i))+translation_x_tscramble+translation_y_tscramble+ dot_size]));
            Screen('Flip', window);

        end

        [nx ny textbounds] = DrawFormattedText(window,'Vuoi vedere di nuovo i video? (y/n)' ,'center','center',white,60,[],[],1.5);
        Screen('Flip',window);
            
        [a, keypressed, c] = KbWait;
        if keypressed(n_key)
            break;          ... esci dal while ed inizia l'esperimento
        else 
            continue;       ... fai un nuovo ciclo di training
        end
    end

    [nx ny textbounds] = DrawFormattedText(window, char(strcat('Durante la sessione sperimentale vedrai una successione di questi quattro tipi di video in ordine casuale. ', ...
    ' MANTIENI LO SGUARDO FISSATO SULLA CROCE AL CENTRO DELLO SCHERMO.' , ...
    ' Sei pronta/o per iniziare l esperimento ? Premi un tasto per iniziare.' )),'center','center',white,45,[],[],1.5);
    Screen('Flip',window);
    WaitSecs(.2);
    KbWait;
    
    %TRAINING SESSION STARTS
    stimulusnb=0;
    cwalkernb=0;        %so far, the walker was presented 0 times
    cscramblenb=0;      %idem for the scramble
    twalkernb=0;
    tscramblenb=0;
    ccontrolnb=0;
    tcontrolnb=0;
    
    while 1
        for iter = Presentation
            stimulusnb=stimulusnb+1;
            for i=1:isi_frames 
                Screen('DrawLines', window, cross_center, 3, red);
                Screen('Flip', window); 
            end
            switch iter
                case 1
                    cwalkernb=cwalkernb+1;
                    phase_fr=1+mod(cwalkernb-1,10)*shift_gait; 
                    mean_init_x=mean(center_walker(1,:,phase_fr),2);
                    translation_x=repmat([round(W/2-mean_init_x) ; 0],1,13);
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*walkershift(walkernb):stimulus_frames+shift_gait*walkershift(walkernb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(center_walker(:,:,i))+ 0 - dot_size ; 
                        squeeze(center_walker(:,:,i)) + 0 + dot_size]));
                        Screen('Flip', window); 
                    end
                case 3
                    cscramblenb=cscramblenb+1;
                    phase_fr=1+mod(cscramblenb-1,10)*shift_gait; 
                    mean_init_x=mean(center_scramble(1,:,phase_fr),2);
                    translation_x=repmat([round(W/2-mean_init_x) ; 0],1,13);
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(center_scramble(:,:,i))+ 0 - dot_size ; 
                        squeeze(center_scramble(:,:,i))+0 + dot_size]));
                        Screen('Flip', window);
                    end

                case 2
                    twalkernb=twalkernb+1;
                    phase_fr=1+mod(twalkernb-1,10)*shift_gait; 
                    mean_init_x=mean(trans_walker(1,:,phase_fr),2);
                    translation_x=repmat([round(W/2-mean_init_x) ; 0],1,13);

                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(trans_walker(:,:,i))+translation_x+translation_y_twalker - dot_size ; 
                        squeeze(trans_walker(:,:,i))+translation_x + translation_y_twalker+ dot_size]));
                        Screen('Flip', window); 
                    end
               case 4
                    tscramblenb=tscramblenb+1;
                    phase_fr=1+mod(tscramblenb-1,10)*shift_gait; 

                    mean_init_x=mean(trans_scramble(1,:,phase_fr),2);
                    translation_x=repmat([round(W/2-mean_init_x) ; 0],1,13);

                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble - dot_size ; 
                        squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble+ dot_size]));
                        Screen('Flip', window); 
                    end
            end
            if stimulusnb==N_stimuli
                wrong_answer=1;
                break
            end

        end
    end

 
    [nx ny textbounds] = DrawFormattedText(window,'Grazie per aver partecipato al nostro esperimento','center','center',white,45,[],[],1.5);
    Screen('Flip',window);
    WaitSecs(5);

    sca
    ListenChar(0);
    
catch err
    Screen('CloseAll');
    err
    err.message
    err.stack(1)
    ListenChar(0);
    
end