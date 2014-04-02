%in questo file si trova l'esperimento per presentare PL displays. Alcune
%features: è commentata la procedura per una attention task, quella per cui
%una o due animazioni in tutto il blocco cambiano colore, da bianco a
%verde, per poco tempo, e dopo compare la domanda "qual'era l'ultima
%animazione che ha cambiato colore?"

clear all 
close all

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
    
random_questions=0;    
N_stimuli=6;
N_type_stim=3; %the number of different types of stimuli
stimulus_time=1; %time of presentation for each stimulus in seconds
intro_time=2;    %time of the red fixation cross  at the beginning of the experimental block
isi_time=3; %inter stimulus time in seconds
green_time=0.1; %time in seconds of the color changing of odd stimuli
tot_frames=268; %total number of frames of each animation
ListenChar(2);
load stimuli_pozzo2

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
Screen('CloseAll');
monitor_freq = 1/monitorFlipInterval;

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
                                                  
%--------------------------------------------------------------------------
%piece of code to decide how many stimuli we are going to present in each
%block, which presentations are going to change color for 0.25 sec., and
%how many and where are the questions regarding the color of the last
%stimulus which changed its color
%--------------------------------------------------------------------------
if random_questions

N_odd_stimuli=ceil(rand(1)*2); % the number of "odd stimuli", the ones which
                              %change color for 0.25 sec., can be at most 2
                              
                           
if N_odd_stimuli==2
   odd_stimuli=[1 2];
   while odd_stimuli(size(odd_stimuli,2))<14
      permutation=randperm(N_stimuli);
      odd_stimuli=sort(permutation([1 2]));
   end
else
    permutation=randperm(N_stimuli);

    odd_stimuli=permutation(1);
end
    
N_questions=ceil(rand(1)*N_odd_stimuli);

aux=1:N_stimuli;

if N_questions==1
    Ind=find(aux>=odd_stimuli(1));
    scope=size(Ind,2);
    permutation=randperm(scope);
    Ind=Ind(permutation);
    questions=Ind(1);
else
    segment1=odd_stimuli(1):odd_stimuli(2)-1;
    segment2=odd_stimuli(2):N_stimuli;
    scope1=size(segment1,2);
    scope2=size(segment2,2);
    permutation1=randperm(scope1);
    permutation2=randperm(scope2);
    segment1=segment1(permutation1);
    segment2=segment2(permutation2);
    questions=[segment1(1) segment2(2)];
    
end

else
   odd_stimuli=[4 10];
   questions=[6 13];
   N_odd_stimuli=2;
   N_questions=2;
end

odd_stimuli=[];
questions=[];
%--------------------------------------------------------------------------
%end of this terrible part...
%--------------------------------------------------------------------------

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
Presentation=B;%(permutation);
% A=0:8;
% permutation=randperm(9);
% walkershift=A(permutation);
% permutation=randperm(9);
% scrambleshift=A(permutation);

if flag_record_avi
    % Create black figure
    rec_fig = figure;
    set(rec_fig,'Position',rect,...
        'MenuBar','none',...
        'Toolbar','none',...
        'NextPlot','replacechildren',...
        'Visible','off',...
        'DoubleBuffer','on');

    %initializing file
    mov = avifile(avi_file,...
        'compression',codec{used_codec},...
        'fps',video_freq,...
        'keyframe',20,...
        'quality',video_quality);
    test= getframe(rec_fig);
    test.cdata=[];
    ANIM = struct(test);
end





stimulusnb=1;
walkernb=0;%so far, the walker was presented 0 times
scramblenb=0;%idem for the scramble
 
[window, rect] = Screen('OpenWindow', 0, black, rec);
HideCursor;
tic
for j=1
    for i=1:intro_frames 
          Screen('DrawLines', window, cross_center, 3, red);
          Screen('Flip', window);
          if flag_record_avi
                            %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
                            ANIM = getframe(rec_fig);
                            mov = addframe(mov,ANIM);
          end
    end
    
end

% wrong_answer=0;
% while wrong_answer==0

Indexes=1;  %introduce this variable to make the scramble points move with random speed, if needed
while size(Indexes,2)<268
    addendum=ceil(abs(267*rand(1)));
    Indexes=cat(2,Indexes,addendum);
end
Indexes=sort(Indexes);
if size(Indexes,2)>268
    Indexes=Indexes(1:268);
end

 for iter = Presentation
        
        for i=1:isi_frames 
                        Screen('DrawLines', window, cross_center, 3, red);
                        %Screen('FillOval', window, white, round([squeeze(walker(:,:,i)) - dot_size ; squeeze(walker(:,:,i)) + dot_size]));
                        Screen('Flip', window); 
                        if flag_record_avi
                            %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
                            ANIM = getframe(rec_fig);
                            mov = addframe(mov,ANIM);
                        end
        end
        switch iter
            case 1
                walkernb=walkernb+1;
                initial_frame=floor(rand(1)*(tot_frames-stimulus_frames));
                if  ismember(stimulusnb,odd_stimuli)
%                     initialframe=ceil(rand(1)*(stimulus_frames-green_frames-1));
                    
                    last_odd_stimulus='w';
                    for i=1+shift_gait*walkershift(walkernb):stimulus_frames+shift_gait*walkershift(walkernb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-initialframe-shift_gait*walkershift(walkernb)>=0 && i-initialframe-shift_gait*walkershift(walkernb)<green_frames
                        Screen('FillOval', window, green, round([squeeze(walker(:,:,i)) - dot_size ; squeeze(walker(:,:,i)) + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(walker(:,:,i)) - dot_size ; squeeze(walker(:,:,i)) + dot_size]));  
                        end
                            
                        Screen('Flip', window);           
                    end
                else        
                    for i=initial_frame:initial_frame+stimulus_frames %1+shift_gait*walkershift(walkernb):stimulus_frames+shift_gait*walkershift(walkernb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(walker(:,:,i)) - dot_size ; squeeze(walker(:,:,i)) + dot_size]));
                        Screen('Flip', window); 
                        if flag_record_avi
                            %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
                            ANIM = getframe(rec_fig);
                            mov = addframe(mov,ANIM);
                        end
                    end
                end
                case 2
                scramblenb=scramblenb+1;
                initial_frame=floor(rand(1)*(tot_frames-stimulus_frames));
                if  ismember(stimulusnb,odd_stimuli)
                    initialframe=ceil(rand(1)*(stimulus_frames-green_frames-1));
                    last_odd_stimulus='c';
                    for i=1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb)
                        Screen('DrawLines', window, cross_center, 3, red);
                        if i-initialframe-shift_gait*scrambleshift(scramblenb)>=0 && i-initialframe-shift_gait*scrambleshift(scramblenb)<green_frames
                        Screen('FillOval', window, green, round([squeeze(scramble2(:,:,i)) - dot_size ; squeeze(scramble2(:,:,i)) + dot_size]));  
                        else
                        Screen('FillOval', window, white, round([squeeze(scramble2(:,:,i)) - dot_size ; squeeze(scramble2(:,:,i)) + dot_size]));  
                        end                            
                        Screen('Flip', window);           
                    end
                else        
                    for i=initial_frame:initial_frame+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(scramble(:,:,i)) - dot_size ; squeeze(scramble(:,:,i)) + dot_size]));
%                         Screen('FillOval', window, white, round([squeeze(scramble(:,:,Indexes(i))) - dot_size ; squeeze(scramble(:,:,Indexes(i))) + dot_size]));
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(1),randomframes(1,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(1),randomframes(1,i))) + dot_size]));
%                         
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(2),randomframes(2,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(2),randomframes(2,i))) + dot_size]));
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(3),randomframes(3,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(3),randomframes(3,i))) + dot_size]));
%                         Screen('FillOval', window, red, round([squeeze(inv_scramble2(:,test_markers(4),randomframes(4,i))) - dot_size ; squeeze(inv_scramble2(:,test_markers(4),randomframes(4,i))) + dot_size]));
                        Screen('Flip', window);
                        if flag_record_avi
                            %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
                            ANIM = getframe(rec_fig);
                            mov = addframe(mov,ANIM);
                        end
                    end
                end
            case 3
                initial_frame=floor(rand(1)*(tot_frames-stimulus_frames));
                    for i=initial_frame:initial_frame+stimulus_frames %1+shift_gait*scrambleshift(scramblenb):stimulus_frames+shift_gait*scrambleshift(scramblenb) 
                        Screen('DrawLines', window, cross_center, 3, red);
                        Screen('FillOval', window, white, round([squeeze(ankles(:,:,i)) - dot_size ; squeeze(ankles(:,:,i)) + dot_size]));
                        Screen('Flip', window); 
                        if flag_record_avi
                            %ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
                            ANIM = getframe(rec_fig);
                            mov = addframe(mov,ANIM);
                        end
                    end
        end
        %part devoted to posing the question, if that is the case
%         if ismember(stimulusnb,questions)
%             
%             Screen('DrawLines', window, cross_center, 3, red);
%             Screen('DrawText', window, '         Which was the last animation that changed color?' , W/2-500 , H/2-100, white);
%             Screen('DrawText', window, '    Type "w" if it was the walker, type "c" if it was the cloud.' , W/2-500 , H/2, white);
%             Screen('Flip', window,[],1);
%             ch='l';
%             while ~ismember(ch,['w' 'c'])
%             [ch , when]=GetChar(0,0);
%             end
%             if last_odd_stimulus==ch
%                 Screen('Flip',window);
%             else
%                 wrong_answer=1;
%                 Screen('Flip',window);
%                 Screen('DrawText', window, 'You gave the wrong answer. Press any key to finish this block.' , W/2-500 , H/2-100, white);
%                 Screen('Flip',window,[],1);
%                 WaitSecs(.2);
%                 KbWait;
%             end
%         end
%           if wrong_answer
%               break
%           end
%         if stimulusnb==18
%             wrong_answer=1;
%             break
%         end
        stimulusnb=stimulusnb+1;
 end
% end
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

