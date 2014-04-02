clear all 
close all
% if test ~ 0 run in test modality (without sending values to serial
% ports), if test==0 active 2 is supposed to be connected
test=0;
%duration of the trigger in s (to avoid trigger overlapping AND trigger detection even subsampling)
trigger_duration=0.02; 

% set the sound card to load and send audios when required
% create an object mapping the soundcard
ao = analogoutput('winsound');
% set the trigger to manual to use the trigger() and get a faster sound
% reproduction
set(ao,'TriggerType','Manual')
%add an audio channel to the sound card to reproduce the sound
chans = addchannel(ao,1);


try

video_file_extension='.mp4';
audio_file_extension='.wav';

%  input_video_folder='C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\video';
input_video_folder='C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\video\FINAL\video';
input_audio_folder='C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\video\FINAL\audio';

% input_video_folder='/data/projects/cp_action_observation/video';

N_blocks=2;             % number of blocks composing the experiment, a 3-4 minutes rest is done during the experiment.
N_type_stim=4;          % number of different types of stimuli
N_stimuli_x_cond=66;    % number of stimuli for condition
N_tot_stimuli=N_stimuli_x_cond * N_type_stim;

N_available_video=6;
N_video_repetition=N_stimuli_x_cond / N_available_video;  % 66/6=11

N_random_questions=24; 
N_stimuli_noquestions=N_tot_stimuli - N_random_questions;

stimulus_time=3;    %time of presentation for each stimulus in seconds
fix_time=0.5;         %time of the red fixation cross at the beginning of the experimental block
iti_time=2;       %fixed inter stimulus time in seconds (actual ITI = 2 + rand(1) )
question_time=4;    %time of question panel 

black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% =======================================================
subject_label=input('please insert subject label (do not fill in any space char) :','s');
output_log_file=['C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\logs\log_' subject_label '_' date '.txt'];
% output_log_file=['/data/projects/cp_action_observation/logs/log_' subject_label '_' date '.txt'];

% while exist(output_log_file)
%     subject_label=input('the entered subject already exist....do you want to overwrite the current log file (Y) or insert a new subject label (N) ?','s');
%     if (subject_label == 'Y')
%         break;
%     else
%         subject_label=input('please insert subject label (do not fill in any space char)','s');
%         output_log_file=['C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\log\log_' subject_label '_' date '.txt'];
%     endppp
% end
 fp=fopen(output_log_file,'w+');

% =======================================================
% SCREEN SETTINGS
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'SuppressAllWarnings', 1);

 %rec = Screen('Rect',0);[W, H]=Screen('windowSize', 0);
 rec = [0,0,1280,768]; W=1280; H=768;
% rec = [0,0,300,300]; W=300; H=300;

[win, rect] = Screen('Openwindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', win);
monitor_freq = 1/monitorFlipInterval;

% =======================================================
% TRIGGERS
% 1 -> 1: control video
% 2 -> 2: action observation (AO)
% 3 -> 4: AO + congruent audio (AOCS)
% 5 -> 8: AO + incongruent audio (AOIS)
% 6 -> 16: question
% 7 -> 32: audio start in AOCS
% 8 -> 64: audio start in AOIS
% 9 -> 128: fixation cross

control_trigger_value=1;
AO_trigger_value=2;
AOCS_trigger_value=4;
AOIS_trigger_value=8;
question_trigger_value=16;
AOCS_audio_trigger_value=32;
AOIS_audio_trigger_value=64;
cross_trigger_value=128;

% crea oggetto porta parallela usanndo le impostazioni di default
if test  
    dio='none';
else
    dio=digitalio('parallel','LPT1');
    % aggiunge una linea dati in output di 8 bit
    line=addline(dio,0:7,'out');
end
% =======================================================
% STIMULI PERMUTATION

A=[1 2 3 4];                                    % --- conditions : controls, ao, aocs, aois
ordered_list=repmat(A,1,N_stimuli_x_cond);
permutation=randperm(N_tot_stimuli);
trials_list=ordered_list(permutation);        ... get (NUMCOND * NUMSTIMxCOND) events

% --- files
video_file={'ctrl01','ctrl02','ctrl03','ctrl04','ctrl05','ctrl06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'};
audio_file={'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'cs01','cs02','cs03','cs04','cs05','cs06'; ...
            'is01','is02','is03','is04','is05','is06'};        
        
        
ordered_video_files=repmat(video_file, 1, N_video_repetition); ... create a matrix of 4x66 cells, replicating the base one (video_file)   
video_files_list=cell(N_type_stim,N_stimuli_x_cond);    

ordered_audio_files=repmat(audio_file, 1, N_video_repetition); ... create a matrix of 4x66 cells, replicating the base one (video_file)   
audio_files_list=cell(N_type_stim,N_stimuli_x_cond);    



audio_onsets_frame={'45','45','45','45','45','45'};    % carta, bottiglia,  pompetta, dadi, giraffa
% audio_onsets_frame={'4','4','4','4','4','4'};    % carta, bottiglia,  pompetta, dadi, giraffa

ordered_audio_onsets_frame=repmat(audio_onsets_frame, 2, N_video_repetition);
audio_onsets_frame_list=cell(2,N_stimuli_x_cond);    

% calculate and apply permutations to stimuli
for row=1:2
    permutation=randperm(N_stimuli_x_cond);

    input_row_video=ordered_video_files(row,:);
    input_row_audio=ordered_audio_files(row,:);
    
    video_files_list(row,:)=input_row_video(permutation);
    audio_files_list(row,:)=input_row_audio(permutation);
    
end

for row=3:4
    permutation=randperm(N_stimuli_x_cond);
    
    input_row_video=ordered_video_files(row,:);
    input_row_audio=ordered_audio_files(row,:);
    
    video_files_list(row,:)=input_row_video(permutation);  
    audio_files_list(row,:)=input_row_audio(permutation);  
    
    dd=row-2;
    input_row_video=ordered_audio_onsets_frame(dd,:);
    input_row_audio=ordered_audio_onsets_frame(dd,:);
    
    audio_onsets_frame_list(dd,:)=input_row_video(permutation);
    
end

% define question trials onset
ordered_question_appearance=zeros(N_tot_stimuli);
for n=1:N_random_questions
    ordered_question_appearance(n)=1;
end
permutation=randperm(N_tot_stimuli);
question_appearance = ordered_question_appearance(permutation);

% CROCE
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];






%====================================================================================================================================
% START EXPERIMENT
%====================================================================================================================================
% HideCursor;
is_paused=0;
can_pause=0;
curr_stimulus_num=0; control_trial=0; ao_trial=0; aocs_trial=0; aois_trial=0; question_trial=0;
%====================================================================================================================================
% TRAINING / EXPLANATIONS

while 0

    [nx ny textbounds] = DrawFormattedText(win,['In questo esperimento vedrai una serie di video.\n' 'Alcuni saranno senza audio, altri con il loro giusto audio, altri con un audio sbagliato' ... 
                                                   '\n\n' 'Fai in cenno quando sei pronto'],'center','center',white, 55 ,[],[],1.5);
    Screen('Flip', win);
    KbWait;
    
    [nx ny textbounds] = DrawFormattedText(win,'scenario naturale','center', 'center', white, 55 ,[],[],1.5);
    Screen('Flip', win);
    WaitSecs(2);
    rnd=ceil(rand()*N_stimuli_x_cond);
    file_video=fullfile(input_video_folder, [video_files_list{1,rnd} video_file_extension]);
    showMovieSendStartTrigger_cla_4(file_video, win, dio, control_trigger_value,test,trigger_duration);

    [nx ny textbounds] = DrawFormattedText(win,'azione senza audio','center', 'center', white, 55 ,[],[],1.5);
    Screen('Flip', win);
    WaitSecs(2);
    rnd=ceil(rand()*N_stimuli_x_cond);
    file_video=fullfile(input_video_folder, [video_files_list{2,rnd} video_file_extension]);    
    showMovieSendStartTrigger_cla_4(file_video, win, dio, AO_trigger_value,test,trigger_duration);
    
    [nx ny textbounds] = DrawFormattedText(win,'azione con audio giusto','center', 'center', white, 55 ,[],[],1.5);
    Screen('Flip', win);
    WaitSecs(2);
    rnd=ceil(rand()*N_stimuli_x_cond);
    file_video=fullfile(input_video_folder, [video_files_list{3,rnd} video_file_extension]);
    file_audio=fullfile(input_audio_folder, [audio_files_list{3,rnd} audio_file_extension]);
    audio_frame=str2double(audio_onsets_frame_list{1,aocs_trial});    
    showMovieSendDoubleTrigger_cla_4(file_video, file_audio,win, dio, AOCS_trigger_value, audio_frame, AOCS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger

    [nx ny textbounds] = DrawFormattedText(win,'azione con audio sbagliato','center', 'center', white, 55 ,[],[],1.5);
    Screen('Flip', win);
    WaitSecs(2);
    rnd=ceil(rand()*N_stimuli_x_cond);
    file_video=fullfile(input_video_folder, [video_files_list{4,rnd} video_file_extension]);
    file_audio=fullfile(input_audio_folder, [audio_files_list{4,rnd} audio_file_extension]);
    audio_frame=str2double(audio_onsets_frame_list{2,aois_trial});
    showMovieSendDoubleTrigger_cla_4(file_video, file_audio, win, dio, AOS_trigger_value, audio_frame, AOIS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger
    
    [nx ny textbounds] = DrawFormattedText(win,'Ogni tanto ti verra chiesto di dire allo sperimentatore come era il suono del video appena visto.\nle tre possibilita` sono:\n1) suono assente\n2) suono giusto\n3) suono sbagliato','center','center',white, 55 ,[],[],1.5);
    Screen('Flip', win);
    WaitSecs(2);
    
    [nx ny textbounds] = DrawFormattedText(win,'Se ti e` tutto chiaro possiamo iniziare con l`esperimento\nIniziamo?','center','center',white, 55 ,[],[],1.5);
    Screen('Flip', win);
    [a,keypressed,c] = KbWait; 
    
    if KbName(keypressed) == 's'
        break;          ... esci dal while ed inizia l'esperimento
    else
        continue;       ... fai un nuovo ciclo di training
    end


end

%====================================================================================================================================
% EXPERIMENT
trials_list
for iter = trials_list
%     iter
       if~test 
            WaitSecs(0.02);putvalue(dio,0);
       end

%     if is paused, check for a 'p' press in order to resume the experiment
    while is_paused == 1
        [nx ny textbounds] = DrawFormattedText(win,'esperimento in PAUSA','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',win);
        [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
        if keyIsDown
            if KbName(keyCode) == 'p'
                is_paused=0;
                
                % show a 3 seconds countdown panel
                start_time=GetSecs;
                while 1 
                    elapsed=GetSecs-start_time;
                    left=ceil(3-elapsed);
                    [nx ny textbounds] = DrawFormattedText(win,['Preparati!, stiamo sta per ripartire\n\n\n' num2str(left)],'center','center',white, 55 ,[],[],1.5);
                    Screen('Flip', win);
                    if elapsed > 3
                        [nx ny textbounds] = DrawFormattedText(win,'Ricominciamo!','center','center',white, 55 ,[],[],1.5);
                        Screen('Flip', win);
                        WaitSecs(1);
                        break;
                    end
                end                
            end
        end 
    end

    % draw the cross and wait for half a second
    Screen('DrawLines', win, cross_center, 3, white);
    Screen('Flip', win);
    if ~ test 
        put_trigger(cross_trigger_value,dio,trigger_duration);
    end 
%     
    start_time=GetSecs;
    while 1 
        elapsed=GetSecs-start_time;
        if elapsed > 0.5            
            break;
        end
    end     
%     show videos
%     curr_stimulus_num
    curr_stimulus_num=curr_stimulus_num+1;
    switch iter
% =======================================================
% TRIGGERS
% 1 -> 1: control video
% 2 -> 2: action observation (AO)

% 3 -> 4: AO + congruent audio (AOCS)
% 5 -> 8: AO + incongruent audio (AOIS)
% 6 -> 16: question
% 7 -> 32: audio start in AOCS
% 8 -> 64: audio start in AOIS


        case 1
            control_trial=control_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,control_trial} video_file_extension]);
            showMovieSendStartTrigger_cla_4(file_video, win, dio, control_trigger_value,test,trigger_duration);
            fwrite(fp, [video_files_list{iter,control_trial} '\n']);

        case 2
            ao_trial=ao_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,ao_trial} video_file_extension]);
            showMovieSendStartTrigger_cla_4(file_video, win, dio, AO_trigger_value,test,trigger_duration);
            fwrite(fp, [video_files_list{iter,ao_trial} '\n']);

        case 3
            aocs_trial=aocs_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aocs_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aocs_trial} audio_file_extension]);
            audio_frame=str2double(audio_onsets_frame_list{1,aocs_trial});
            showMovieSendDoubleTrigger_cla_4(file_video, file_audio, win, dio, AOCS_trigger_value, audio_frame, AOCS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger
            fwrite(fp, [video_files_list{iter,aocs_trial} '\n']);

        case 4
            aois_trial=aois_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aois_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aois_trial} audio_file_extension]);
            audio_frame=str2double(audio_onsets_frame_list{2,aois_trial});            
            showMovieSendDoubleTrigger_cla_4(file_video, file_audio, win, dio, AOIS_trigger_value, audio_frame, AOIS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger
            fwrite(fp, [video_files_list{iter,aois_trial} '\n']);
    end
    
    % check if question must be shown
    if question_appearance(curr_stimulus_num)
       if ~ test
           put_trigger(question_trigger_value,dio,trigger_duration);
%            
       end
       
        [nx ny textbounds] = DrawFormattedText(win,'come era il suono appena sentito?\na) assente\nb) giusto\nc) sbagliato','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',win);
        WaitSecs(question_time);
    end
    
  
    Screen('FillRect', win, black, rect);
    Screen('Flip', win);
    iti=round(iti_time+rand(1));

    % check if 'p' is pressed in order to pause the experiment
    can_pause=1;
    start_time=GetSecs;
    while is_paused == 0
        [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
        if (keyIsDown && can_pause == 1)
            if KbName(keyCode) == 'p'
                is_paused=1;
                WaitSecs(0.2);
                break
            end
        end 
        elapsed=GetSecs-start_time;
        if elapsed > iti
            break;
        end            

    end  
    can_pause=0;

    % check if half of experiment is reached
    if (curr_stimulus_num == N_tot_stimuli/2)
       
        [nx ny textbounds] = DrawFormattedText(win,'la prima parte dell esperimento e` finita\nriposati qualche minuto\nquando sei pronto, avvisa lo sperimentatore','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',win);
        KbWait;
    end
    
    
end

 
% ShowCursor;
Screen('Flip', win);
Screen('CloseAll');
 sca;
if ~ test
        %reset trigger channels
        WaitSecs(0.02);putvalue(dio,0);
end
sca;
catch err
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen win if it's open.
    Screen('CloseAll');
    err
    err.stack(1)
end

