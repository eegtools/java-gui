%in questo file si trova l'esperimento per presentare PL displays. Alcune
%features: è commentata la procedura per una attention task, quella per cui
%una o due animazioni in tutto il blocco cambiano colore, da bianco a
%verde, per poco tempo, e dopo compare la domanda "qual'era l'ultima
%animazione che ha cambiato colore?" In questa versione, il moto può
%avvenire da sinistra a destra, o da destra a sinistra

clear all 
close all
cd('C:\Documents and Settings\BMILab\My Documents\MATLAB\Alejo\pozzo_experiment')
try
    
randomframes=ones(4,268);
for i=1:4
Indexes2=[1];
   while size(Indexes2,2)<268
       addendum=ceil(abs(267*rand(1)));       
       Indexes2=cat(2,Indexes2,addendum);
   end
   Indexes2=sort(Indexes2);
   if size(Indexes2,2)>268
       Indexes2=Indexes2(1:268);
   end
   randomframes(i,:)=Indexes2;
end
    
%create an instance of the io32 object
% ioObj = io32;
%
%initialize the inpout32.dll system driver
% status = io32(ioObj);
% address = hex2dec('378');

random_questions=0;    
N_stimuli=8;
N_type_stim=4; %the number of different types of stimuli
stimulus_time=1; %time of presentation for each stimulus in seconds
intro_time=2;    %time of the red fixation cross  at the beginning of the experimental block
isi_time=3; %inter stimulus time in seconds
green_time=0.25; %time in seconds of the color changing of odd stimuli
tot_frames=268; %total number of frames of each animation
ListenChar(2);
load stimuli_pozzo

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

%--------Video configuration-----------------
flag_record_avi = 0; %flag avi creation
video_freq = 60;
video_quality = 80;
codec ={'Indeo3';'Indeo5';'Cinepak';'MSVC';'RLE';'None'};
used_codec = 2;
% avi_file = [codec{used_codec} '_' stimuli '_' num2str(video_freq) '.avi'];
%avi_file = [str_1 '_ankle_' str_2 '_' str_3 '3sec.avi'];
avi_file= 'first_version.avi';%'LR_ankle_dritto_3sec.avi';
%--------------------------------------------

%----CROCE----
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];
%-------------------------------------------

stimulus_frames=ceil(monitor_freq*stimulus_time);%number of frames corresponding to
                                                  %stimulus_time seconds
                                                  
intro_frames=round(monitor_freq*intro_time); %analogous to stimulus_frames
isi_frames=round(monitor_freq*isi_time);
green_frames=round(monitor_freq*green_time);
possible_start=stimulus_frames-green_frames;
                                                  
%--------------------------------------------------------------------------
%piece of code to decide how many stimuli we are going to present in each
%block, which presentations are going to change color for 0.25 sec., and
%how many and where are the questions regarding the color of the last
%stimulus which changed its color
%--------------------------------------------------------------------------
% if random_questions
% 
% N_odd_stimuli=ceil(rand(1)*2); % the number of "odd stimuli", the ones which
%                               %change color for 0.25 sec., can be at most 2
%                               
%                            
% if N_odd_stimuli==2
%    odd_stimuli=[1 2];
%    while odd_stimuli(size(odd_stimuli,2))<14
%       permutation=randperm(N_stimuli);
%       odd_stimuli=sort(permutation([1 2]));
%    end
% else
%     permutation=randperm(N_stimuli);
% 
%     odd_stimuli=permutation(1);
% end
%     
% N_questions=ceil(rand(1)*N_odd_stimuli);
% 
% aux=1:N_stimuli;
% 
% if N_questions==1
%     Ind=find(aux>=odd_stimuli(1));
%     scope=size(Ind,2);
%     permutation=randperm(scope);
%     Ind=Ind(permutation);
%     questions=Ind(1);
% else
%     segment1=odd_stimuli(1):odd_stimuli(2)-1;
%     segment2=odd_stimuli(2):N_stimuli;
%     scope1=size(segment1,2);
%     scope2=size(segment2,2);
%     permutation1=randperm(scope1);
%     permutation2=randperm(scope2);
%     segment1=segment1(permutation1);
%     segment2=segment2(permutation2);
%     questions=[segment1(1) segment2(2)];
%     
% end
% 
% else
%    odd_stimuli=[4 10];
%    questions=[6 13];
%    N_odd_stimuli=2;
%    N_questions=2;
% end
% 
% odd_stimuli=[];
% questions=[];
%--------------------------------------------------------------------------
%end of this terrible part...
%--------------------------------------------------------------------------

[odd_stimuli questions]=attention_task(N_stimuli);
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
A=1:N_type_stim;
B=repmat(A,1,N_stimuli/N_type_stim);
permutation=randperm(N_stimuli);
Presentation=B(permutation);
% A=0:8;
% permutation=randperm(9);
% walkershift=A(permutation);
% permutation=randperm(9);
% scrambleshift=A(permutation);

% if flag_record_avi
%     % Create black figure
%     rec_fig = figure;
%     set(rec_fig,'Position',rect,...
%         'MenuBar','none',...
%         'Toolbar','none',...
%         'NextPlot','replacechildren',...
%         'Visible','off',...
%         'DoubleBuffer','on');
% 
%     %initializing file
%     mov = avifile(avi_file,...
%         'compression',codec{used_codec},...
%         'fps',video_freq,...
%         'keyframe',20,...
%         'quality',video_quality);
%     test= getframe(rec_fig);
%     test.cdata=[];
%     ANIM = struct(test);
% end





stimulusnb=0;
walkernb=0;%so far, the walker was presented 0 times
scramblenb=0;%idem for the scramble
anklesnb=0;
bouncernb=0;

 
% [window, rect] = Screen('OpenWindow', 0, black, rec);
HideCursor;
tic
for j=1
    for i=1:intro_frames 
          Screen('DrawLines', window, cross_center, 3, red);
          Screen('Flip', window);
%           if flag_record_avi
%                             %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
%                             ANIM = getframe(rec_fig);
%                             mov = addframe(mov,ANIM);
%           end
    end
    
end

wrong_answer=0;
while wrong_answer==0



 for iter = Presentation
     putvalue(dio,0);
        stimulusnb=stimulusnb+1;
        
        for i=1:isi_frames 
                        Screen('DrawLines', window, cross_center, 3, red);
                        %Screen('FillOval', window, white, round([squeeze(walker(:,:,i)) - dot_size ; squeeze(walker(:,:,i)) + dot_size]));
                        Screen('Flip', window); 
%                         if flag_record_avi
%                             %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
%                             ANIM = getframe(rec_fig);
%                             mov = addframe(mov,ANIM);
%                         end
        end
        switch iter
            case 1
                walkernb=walkernb+1;
                %                 initial_frame=floor(rand(1)*(tot_frames-stimulus_frames));
                phase_fr=1+(walkernb-1)*6; 
                mean_init_x=mean(walker(1,:,phase_fr),2);
                translation_x=[round(W/4-mean_init_x) ; 0];
                if  ismember(stimulusnb,odd_stimuli)
%                     initialframe=ceil(rand(1)*(stimulus_frames-green_frames-1));
                    last_odd_stimulus='1';
                    
                    start_green=floor(rand(1)*possible_start);
                    putvalue(dio,5)
                    for i=phase_fr:phase_fr+stimulus_frames                         
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-phase_fr-start_green>=0 && i-phase_fr-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(walker(:,:,i))+repmat(translation_x,1,13) - dot_size ; squeeze(walker(:,:,i)) + repmat(translation_x,1,13) + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(walker(:,:,i))+repmat(translation_x,1,13) - dot_size ; squeeze(walker(:,:,i)) + repmat(translation_x,1,13) + dot_size]));  
                        end
                            
                        Screen('Flip', window);           
                    end
                    
                else
                    putvalue(dio,1)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*walkershift(walkernb):stimulus_frames+shift_gait*walkershift(walkernb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(walker(:,:,i))+repmat(translation_x,1,13) - dot_size ; squeeze(walker(:,:,i)) + repmat(translation_x,1,13) + dot_size]));
%                         Screen('FillOval', window, white, round([squeeze(W-walker(1,:,i)) - dot_size ; squeeze(walker(2,:,i)) - dot_size ; squeeze(W-walker(1,:,i)) + dot_size ; squeeze(walker(2,:,i)) + dot_size]));
                        Screen('Flip', window); 
%                         if flag_record_avi
%                             %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
%                             ANIM = getframe(rec_fig);
%                             mov = addframe(mov,ANIM);
%                         end
                    end
                    

                end
                case 2
                scramblenb=scramblenb+1;
                phase_fr=1+(scramblenb-1)*6; 
                mean_init_x=mean(scramble(1,:,phase_fr),2);
                translation_x=[round(W/4-mean_init_x) ; 0];
                if  ismember(stimulusnb,odd_stimuli)
                    
                    last_odd_stimulus='2';
                    start_green=floor(rand(1)*possible_start);
                    putvalue(dio,6)
                    for i=phase_fr:phase_fr+stimulus_frames 
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-phase_fr-start_green>=0 && i-phase_fr-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(scramble(:,:,i))+repmat(translation_x,1,13) - dot_size ; squeeze(scramble(:,:,i))+repmat(translation_x,1,13) + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(scramble(:,:,i))+repmat(translation_x,1,13) - dot_size ; squeeze(scramble(:,:,i))+repmat(translation_x,1,13) + dot_size]));  
                        end                            
                        Screen('Flip', window);           
                    end
                else        
                    putvalue(dio,2)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(scramble(:,:,i))+repmat(translation_x,1,13) - dot_size ; squeeze(scramble(:,:,i))+repmat(translation_x,1,13) + dot_size]));
%                         Screen('FillOval', window, white, round([squeeze(scramble(:,:,Indexes(i))) - dot_size ; squeeze(scramble(:,:,Indexes(i))) + dot_size]));
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(1),randomframes(1,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(1),randomframes(1,i))) + dot_size]));
%                         
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(2),randomframes(2,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(2),randomframes(2,i))) + dot_size]));
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(3),randomframes(3,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(3),randomframes(3,i))) + dot_size]));
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(4),randomframes(4,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(4),randomframes(4,i))) + dot_size]));
                        Screen('Flip', window);
%                         if flag_record_avi
%                             %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
%                             ANIM = getframe(rec_fig);
%                             mov = addframe(mov,ANIM);
%                         end
                    end
                   
                    end
                
            case 3
                anklesnb=anklesnb+1;
                phase_fr=1+(anklesnb-1)*6; 
                mean_init_x=mean(ankles(1,:,phase_fr),2);
                translation_x=[round(W/4-mean_init_x) ; 0];
                
                if  ismember(stimulusnb,odd_stimuli)
                    
                    last_odd_stimulus='3';
                    start_green=floor(rand(1)*possible_start);
                    putvalue(dio,7)
                    for i=phase_fr:phase_fr+stimulus_frames 
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-phase_fr-start_green>=0 && i-phase_fr-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(ankles(:,:,i))+repmat(translation_x,1,2) - dot_size ; squeeze(ankles(:,:,i)) + repmat(translation_x,1,2)+ dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(ankles(:,:,i))+repmat(translation_x,1,2) - dot_size ; squeeze(ankles(:,:,i)) + repmat(translation_x,1,2)+ dot_size]));  
                        end                            
                        Screen('Flip', window);           
                    end
                else             
                
                putvalue(dio,3)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(ankles(:,:,i))+repmat(translation_x,1,2) - dot_size ; squeeze(ankles(:,:,i)) + repmat(translation_x,1,2)+ dot_size]));
                        Screen('Flip', window); 
%                         if flag_record_avi
%                             %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
%                             ANIM = getframe(rec_fig);
%                             mov = addframe(mov,ANIM);
%                         end
                    end
                end
                case 4
                bouncernb=bouncernb+1;
                phase_fr=1+(bouncernb-1)*6; 
                mean_init_x=mean(bouncer(1,:,phase_fr),2);
                translation_x=[round(W/4-mean_init_x) ; 0];
                
                if  ismember(stimulusnb,odd_stimuli)
                    
                    last_odd_stimulus='0';
                    start_green=floor(rand(1)*possible_start);
                    
                    putvalue(dio,8)
                    for i=phase_fr:phase_fr+stimulus_frames 
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-phase_fr-start_green>=0 && i-phase_fr-start_green<green_frames
                        Screen('FillOval', window, green, round([squeeze(bouncer(:,:,i)) + repmat(translation_x,1,2) - dot_size ; squeeze(bouncer(:,:,i)) + repmat(translation_x,1,2) + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(bouncer(:,:,i)) + repmat(translation_x,1,2) - dot_size ; squeeze(bouncer(:,:,i)) + repmat(translation_x,1,2) + dot_size]));  
                        end                            
                        Screen('Flip', window);           
                    end
                else    
                
                putvalue(dio,4)
                    for i=phase_fr:phase_fr+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(bouncer(:,:,i))+ repmat(translation_x,1,2) - dot_size ; squeeze(bouncer(:,:,i)) + repmat(translation_x,1,2)+ dot_size]));
                        Screen('Flip', window); 
%                         if flag_record_avi
%                             %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
%                             ANIM = getframe(rec_fig);
%                             mov = addframe(mov,ANIM);
%                         end
                    end
                end
        end
        %part devoted to posing the question, if that is the case
        if ismember(stimulusnb,questions)
            if stimulusnb==N_stimuli
                disp('I arrived here')
            end
            
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('DrawText', window, '         Which was the last animation that changed color?' , W/2-500 , H/2-100, white);
            Screen('DrawText', window, '    Type 1, 2, 3, or 0 to give your answer.' , W/2-500 , H/2, white);
            Screen('Flip', window,[],1);
            ch='l';
            while ~ismember(ch,['1' '2' '3' '0'])
            [ch , when]=GetChar(0,0);
            end
            if last_odd_stimulus==ch
                Screen('Flip',window);
                Screen('DrawLines', window, cross_center, 3, red);
                Screen('DrawText', window, 'You gave the right answer! Press any key to continue.' , W/2-500 , H/2-100, white); 
                Screen('Flip',window,[],1);
                WaitSecs(.2);
                KbWait; 
            else
                wrong_answer=1;
                Screen('Flip',window);
                Screen('DrawLines', window, cross_center, 3, red);
                Screen('DrawText', window, 'You gave the wrong answer. Press any key to finish this block.' , W/2-500 , H/2-100, white);
                Screen('Flip',window,[],1);
                WaitSecs(.2);
                KbWait;
            end
        end
          if wrong_answer
              break
          end
        if stimulusnb==N_stimuli
            wrong_answer=1;
            break
        end
        
 end
end
ListenChar(0); 
if flag_record_avi
    mov = close(mov);
end
ShowCursor;
toc
Screen('Flip', window);
Screen('CloseAll');
sca;
catch
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('CloseAll');
    fra = lasterror(psychlasterror);
    fra
end

