%in questo file si trova l'esperimento per presentare PL displays. Alcune
%features: � commentata la procedura per una attention task, quella per cui
%una o due animazioni in tutto il blocco cambiano colore, da bianco a
%verde, per poco tempo, e dopo compare la domanda "qual'era l'ultima
%animazione che ha cambiato colore?" In questa versione, ci dovrebbero
%essere 4 tipo di stimoli: un walker centrato, uno scramble centrato, un
%walker che trasla, uno scramble che trasla... forse, gli stimoli che
%traslano si alterneranno tra l'andare da sx a dx e viceversa.

clear all 
close all
%cd('C:\Documents and Settings\alejo\My Documents\MATLAB\pozzo_experiment_computer_stimuli')
try
    


random_questions=0;    
N_stimuli=48;
N_type_stim=4; %the number of different types of stimuli
stimulus_time=1; %time of presentation for each stimulus in seconds
intro_time=2;    %time of the red fixation cross  at the beginning of the experimental block
isi_time=2; %inter stimulus time in seconds
green_time=0.25; %time in seconds of the color changing of odd stimuli
tot_frames=268; %total number of frames of each animation
ListenChar(2);
load stimuli_pozzo_11_03_10
delta_y_trans_walker=0;


% test_markers=[10 11 12 13];
% normal_markers=setdiff(1:13,test_markers);

flipSpdback = 0;
flipSpdwindow = 0; 
black = [0 0 0];
red = [200 50 50];
white = [255 255 255];
green=[10 255 10];
dot_size = 4;

rec = Screen('Rect',0);
[W, H]=Screen('WindowSize', 0);
[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
% Screen('CloseAll');
monitor_freq = 1/monitorFlipInterval;
% crea oggetto porta parallela usamndo le impostazioni di default
dio = digitalio('parallel','LPT1');

% aggiunge una lian dati in output di 4 bit
line=addline(dio,0:3,'out');

deltay_twalker=-10;
deltay_cwalker=-10;
translation_y_cwalker=repmat([0 ; deltay_cwalker],1,13);
mean_init_y=mean(trans_walker(2,:,1),2);
translation_y_twalker=repmat([0 ; round(H/2-mean_init_y+deltay_twalker)],1,13);
mean_init_y=mean(trans_scramble(2,:,1),2);
translation_y_tscramble=repmat([0 ; round(H/2-mean_init_y)],1,13);



%----CROCE----
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];
%-------------------------------------------

stimulus_frames=ceil(monitor_freq*stimulus_time);%number of frames corresponding to
                                                  %stimulus_time seconds
                                                  
intro_frames=round(monitor_freq*intro_time); %analogous to stimulus_frames
isi_frames=round(monitor_freq*isi_time);
green_frames=round(monitor_freq*green_time);
possible_start=stimulus_frames-green_frames;
                                                  

odd_stimuli=[];
questions=[];
% odd_stimuli=[2 7];
% questions=[3 11 ];

% [odd_stimuli questions]=attention_task(N_stimuli);
% clear odd_stimuli questions
% odd_stimuli=[5 8 13 17];%[1 2 3 4];
%  questions=[];
% odd_stimuli=[1 2 3 4];
% cycle_gait_time=1.2167;
% cycle_gait_frames=round(cycle_gait_time*monitor_freq);
% shift_gait=floor(cycle_gait_frames/9); %each time the animation will be presented, 
%                                       %the starting positions of the dots will 
%                                       %be shifted of a certain amount (this
%                                       % is a counterbalancing procedure
%                                       % used by Hirai, et al., Neuroscience
%                                       % Letters 344 (2003) 41-44.
% 
%  





% odd_stimuli=[4 18 23 40];
% questions=[13 26 45];

% 
% odd_stimuli=[13 22 44];
% questions=[25 50];

% odd_stimuli=[10 12 26 50];
% questions=[15 30 52];

odd_stimuli=[3 20  42];
questions=[10 47];

% odd_stimuli=[15 30 41];
% questions=[17 44];

% odd_stimuli=[7 26 37];
% questions=[15 43];

% odd_stimuli=[2 10 40];
% questions=[3 20 45];
% 
% odd_stimuli=[7 20 34];
% questions=[22 40];
% 
% odd_stimuli=[3 15 41];
% questions=[20  46];

odd_stimuli=[10 25];
questions=[28];

% odd_stimuli=[1 3 5 7 9 11 13 15];
% questions=odd_stimuli+1; %[1 6 11 16];

A=[1 2 3 4];%1:N_type_stim;
B=repmat(A,1,N_stimuli/N_type_stim);
permutation=randperm(N_stimuli);
Presentation=B(permutation);




cycle_gait_time=1.2167;
cycle_gait_frames=round(cycle_gait_time*monitor_freq);
shift_gait=floor(cycle_gait_frames/10); %each time the animation will be presented, 
%                                       %the starting positions of the dots will 
%                                       %be shifted of a certain amount (this
%                                       % is a counterbalancing procedure
%                                       % used by Hirai, et al., Neuroscience
%                                       % Letters 344 (2003) 41-44.
%shift_gait is the number of frames in which the shifting consists




stimulusnb=0;
cwalkernb=0;%so far, the walker was presented 0 times
cscramblenb=0;%idem for the scramble
twalkernb=0;
tscramblenb=0;

 

HideCursor;
tic
for j=1
    for i=1:intro_frames 
          Screen('DrawLines', window, cross_center, 3, red);
          Screen('Flip', window);
    end
end

wrong_answer=0;
% while wrong_answer==0



 for iter = Presentation
     putvalue(dio,0);
        stimulusnb=stimulusnb+1;
        isi_frames=round(isi_time*monitor_freq+2*rand(1)*monitor_freq);
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
                if  ismember(stimulusnb,odd_stimuli)
%                     initialframe=ceil(rand(1)*(stimulus_frames-green_frames-1));
                    last_odd_stimulus='1';
                    
                    start_green=floor(rand(1)*possible_start);
                    putvalue(dio,5)
                    for i=1:stimulus_frames                         
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-start_green>=0 && i-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(center_walker(:,:,i))+translation_y_cwalker - dot_size ; squeeze(center_walker(:,:,i)) + translation_y_cwalker + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(center_walker(:,:,i))+translation_y_cwalker - dot_size ; squeeze(center_walker(:,:,i)) + translation_y_cwalker + dot_size]));  
                        end
                            
                        Screen('Flip', window);           
                    end
                    
                else
                    putvalue(dio,1)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*walkershift(walkernb):stimulus_frames+shift_gait*walkershift(walkernb)
                        Screen('DrawLines', window, cross_center, 3, red);
%                         Screen('FillOval', window, green, round([squeeze(center_walker(:,:,phase_fr))+0 - dot_size ; squeeze(center_walker(:,:,phase_fr)) + 0 + dot_size]));
                        %
                        Screen('FillOval', window, white, round([squeeze(center_walker(:,:,i))+translation_y_cwalker - dot_size ; squeeze(center_walker(:,:,i)) + translation_y_cwalker + dot_size]));
                        %Screen('FillOval', window, white, round([squeeze(W-walker(1,:,i)) - dot_size ; squeeze(walker(2,:,i)) - dot_size ; squeeze(W-walker(1,:,i)) + dot_size ; squeeze(walker(2,:,i)) + dot_size]));
                        Screen('Flip', window);
%                         Screen('Flip', window,[],1);
                    end
                    

                end
                case 3
                cscramblenb=cscramblenb+1;
                phase_fr=1+mod(cscramblenb-1,10)*shift_gait; 
                mean_init_x=mean(center_scramble(1,:,phase_fr),2);
                translation_x=repmat([round(W/2-mean_init_x) ; 0],1,13);
                if  ismember(stimulusnb,odd_stimuli)
                    
                    last_odd_stimulus='3';
                    start_green=floor(rand(1)*possible_start);
                    putvalue(dio,7)
                    for i=1:stimulus_frames 
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-start_green>=0 && i-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(center_scramble(:,:,i))+0 - dot_size ; squeeze(center_scramble(:,:,i))+0 + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(center_scramble(:,:,i))+0 - dot_size ; squeeze(center_scramble(:,:,i))+0 + dot_size]));  
                        end                            
                        Screen('Flip', window);           
                    end
                else        
                    putvalue(dio,3)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
%                         Screen('FillOval', window, green, round([squeeze(center_scramble(:,:,phase_fr))+0 - dot_size ; squeeze(center_scramble(:,:,phase_fr))+0 + dot_size]));
                        Screen('FillOval', window, white, round([squeeze(center_scramble(:,:,i))+0 - dot_size ; squeeze(center_scramble(:,:,i))+0 + dot_size]));
                        Screen('Flip', window);

                    end
                   
                    end
                
            case 2
                twalkernb=twalkernb+1;
                phase_fr=1+mod(twalkernb-1,10)*shift_gait; 
                mean_init_x=mean(trans_walker(1,:,phase_fr),2);
                translation_x=repmat([round(W/2-mean_init_x) ; 0],1,13);
                
                if  ismember(stimulusnb,odd_stimuli)
                    
                    last_odd_stimulus='2';
                    start_green=floor(rand(1)*possible_start);
                    putvalue(dio,6)
                    for i=phase_fr:stimulus_frames+phase_fr 
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-start_green>=0 && i-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(trans_walker(:,:,i))+translation_x+translation_y_twalker- dot_size ; squeeze(trans_walker(:,:,i))+translation_x + translation_y_twalker+ dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(trans_walker(:,:,i))+translation_x+translation_y_twalker - dot_size ; squeeze(trans_walker(:,:,i))+translation_x + translation_y_twalker+ dot_size]));  
                        end                            
                        Screen('Flip', window);           
                    end
                else             
                
                putvalue(dio,2)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
%                         Screen('FillOval', window, green, round([squeeze(trans_walker(:,:,phase_fr))+translation_x+translation_y_twalker - dot_size ; squeeze(trans_walker(:,:,phase_fr))+translation_x + translation_y_twalker+ dot_size]));
                        
                        Screen('FillOval', window, white, round([squeeze(trans_walker(:,:,i))+translation_x+translation_y_twalker - dot_size ; squeeze(trans_walker(:,:,i))+translation_x + translation_y_twalker+ dot_size]));
                        Screen('Flip', window);
%                         Screen('Flip', window,[],1); 

                    end
                end
                case 4
                tscramblenb=tscramblenb+1;
                phase_fr=1+mod(tscramblenb-1,10)*shift_gait; 
                
                mean_init_x=mean(trans_scramble(1,:,phase_fr),2);
                translation_x=repmat([round(W/2-mean_init_x) ; 0],1,13);
                
                if  ismember(stimulusnb,odd_stimuli)
                    
                    last_odd_stimulus='4';
                    start_green=floor(rand(1)*possible_start);
                    
                    putvalue(dio,8)
                    for i=phase_fr:phase_fr+stimulus_frames 
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-start_green>=0 && i-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble - dot_size ; squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble - dot_size ; squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble + dot_size]));  
                        end                            
                        Screen('Flip', window);           
                    end
                else    
                
                putvalue(dio,4)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
%                         Screen('FillOval', window, green, round([squeeze(trans_scramble(:,:,phase_fr))+translation_x+translation_y_tscramble - dot_size ; squeeze(trans_scramble(:,:,phase_fr))+translation_x+translation_y_tscramble+ dot_size]));
                        Screen('FillOval', window, white, round([squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble - dot_size ; squeeze(trans_scramble(:,:,i))+translation_x+translation_y_tscramble+ dot_size]));
                        Screen('Flip', window); 

                    end
                end
        end
        putvalue(dio,0);
        %part devoted to posing the question, if that is the case
        if ismember(stimulusnb,questions)
            if stimulusnb==N_stimuli
                NUMERO=10
            end
            FlushEvents;
%             Screen('DrawLines', window, cross_center, 3, red);
            [nx ny textbounds] = DrawFormattedText(window,char(strcat('Which was the last animation that changed color?',...
              'Press 1, 2, 3 or 4 to give your answer.'  )) ,'center','center',white, 45 ,[],[],1.5);

%             Screen('DrawText', window, '         Which was the last animation that changed color?' , W/2-500 , H/2-100, white);
%             Screen('DrawText', window, '         Press 0, 1, 2, or 3 to give your answer.' , W/2-500 , H/2+100, white);
            Screen('Flip', window);
            ch='l';
            while ~ismember(ch,['1' '2' '3' '4'])
            [ch , when]=GetChar(0,0);
            end
            FlushEvents;
            
            
            
            if strcmp(last_odd_stimulus,ch) & ismember(stimulusnb,questions)
                
                wrong_answer=0;
                fid=fopen('answers.txt','a+');
                fprintf(fid,'%d \n',1);
                fclose(fid);
%                 Screen('Flip',window);
%                 Screen('DrawLines', window, cross_center, 3, red);
%                 Screen('DrawText', window, '         You gave the right answer! Press any key to continue.' , W/2-500 , H/2-100, white); 
%                 Screen('Flip',window);
%                 WaitSecs(.2);
%                 KbWait; 
            end
            if ~strcmp(last_odd_stimulus,ch) & ismember(stimulusnb,questions)
                wrong_answer=1;
                fid=fopen('answers.txt','a+');
                fprintf(fid,'%d \n',0);
                fclose(fid);
%                 Screen('Flip',window);
%                 Screen('DrawLines', window, cross_center, 3, red);
%                 Screen('DrawText', window, '         You gave a wrong answer. Press any key to finish this block.' , W/2-500 , H/2-100, white);
%                 Screen('Flip',window);
%                 WaitSecs(.2);
%                 KbWait;
            end
        end
        FlushEvents;
          if wrong_answer & ismember(stimulusnb,questions)
%               putvalue(dio,0);
              putvalue(dio,11);
%               putvalue(dio,0);
          end    
          if ~wrong_answer & ismember(stimulusnb,questions)
%               putvalue(dio,0);
              putvalue(dio,10);
%               putvalue(dio,0);
          end
          if ismember(stimulusnb,questions)
          [nx ny textbounds] = DrawFormattedText(window,'Press any key to continue with the experiment.','center','center',white, 45 ,[],[],1.5);
          Screen('Flip',window);
          WaitSecs(.1);
          KbWait;
          end
%         if stimulusnb==N_stimuli
%             wrong_answer=1;
% %             break
%         end
        
 end
% end
ListenChar(0); 

ShowCursor;
toc
Screen('Flip', window);
Screen('CloseAll');
sca;
catch
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('CloseAll');
    ListenChar(0);
    fra = lasterror(psychlasterror);
    fra
    
end
