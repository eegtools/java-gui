clear all 
close all

root_dir = 'C:\Documents and Settings\Gaslini\My Documents\MATLAB\cpchildren';


% if test ~ 0 run in test modality (without sending values to serial
% ports), if test==0 active 2 is supposed to be connected
test=0;
%duration of the trigger in sec. (to avoid trigger overlapping AND trigger detection even subsampling)
trigger_duration=0.02; 

if ~test
    % set the sound card to load and send audios when required
    % create an object mapping the soundcard
    ao = analogoutput('winsound');
    % set the trigger to manual to use the trigger() and get a faster sound
    % reproduction
    set(ao,'TriggerType','Manual')
    %add an audio channel to the sound card to reproduce the sound
    chans = addchannel(ao,1);
else
    ao='none';
    chans='none';
end

try

video_side='left';
% Check if Psychtoolbox is properly installed:
AssertOpenGL;    

video_file_extension='.mp4';
audio_file_extension='.wav';

% accepted values are when : N_stimuli_x_cond * N_type_stim / N_block / N_available_video ..... is an integer
N_block=6;                                              % number of blocks composing the experiment, a 3-4 minutes rest is done during the experiment.
N_type_stim=4;                                          % number of different types of stimuli
N_stimuli_x_cond=72;                                    % number of stimuli for condition
N_available_video=6;                                    % number of available video

N_stimuli_x_cond_x_block=N_stimuli_x_cond / N_block;   % number of stimuli for condition for each block
N_tot_stimuli=N_stimuli_x_cond * N_type_stim;
N_tot_stimuli_x_block=N_tot_stimuli / N_block;          % number of stimuli for blcok

N_video_repetition=N_stimuli_x_cond / N_available_video;  % 72/6=12

N_random_questions=24; 
N_stimuli_noquestions=N_tot_stimuli - N_random_questions;

stimulus_time=3;    %time of presentation for each stimulus in seconds
fix_time=0.5;       %time of the red fixation cross at the beginning of the experimental block
iti_time=1.5;       %fixed inter stimulus time in seconds (actual ITI = 1.5 + rand(1) )
question_time=4;    %time of question panel 

black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% frame at which start audio and send trigger (thought to be 1.5 sec @ 30 fps)
sound_frame=45;

% define when to rest (by default two pauses are planned). in mode 1 & 2 five pauses will be done
rest_appearence=zeros(N_tot_stimuli);
rest_appearence(96)=1;
rest_appearence(192)=1;

% == subject name =====================================================
subject_label = input('please insert subject label (do not fill in any space char) :','s');
output_log_file=[root_dir '\logs\log_' subject_label '_' date '.txt'];

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
if ~fp 
    disp('error opening file descriptor');
end

% == experiment mode =====================================================
% 0:    full children   do training, wait for key press during questions, do 2 pauses
% 1:    full adults     do training, 4 secs pause during questions, do 5 pauses
% 2:    fast mode       no training, 4 secs pause during questions, do 5 pauses
while 1
    modestr = input('please insert experiment mode (accepted values are: 0,1,2) [0] :','s');
    if isempty(modestr)
        mode = 0;
    else
        switch modestr
            case {'0','1','2'}
                mode = str2num(modestr);
                break;
            otherwise
                disp('accepted mode are: 0,1,2');
        end
    end
end
switch mode
    case 0
        do_training = 1;
        do_question_pause = 1;
    case 1
        do_training = 1;
        do_question_pause = 0;
    case 2
        do_training = 0;
        do_question_pause = 0;
end

if do_question_pause == 0
    rest_appearence(48)=1;  ... add three extra pauses 
    rest_appearence(144)=1;
    rest_appearence(240)=1;
end
% == video side =====================================================
while 1
    video_side = input('please specify the hand side to be displayed (press : r or l): ', 's');
    switch video_side
        case {'r','l'}
            break;
        otherwise
            disp('accepted sides are: l & r');
    end
end

input_video_folder = [root_dir '\video\FINAL\video_' video_side];
input_audio_folder = [root_dir '\video\FINAL\audio'];
% =======================================================
% SCREEN SETTINGS
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
%W=800; H=600; rec = [0,0,W,H]; 

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

% =======================================================
% =======================================================
% TRIGGERS
% Control video:                    11,12,13,14,15,16
% action observation (AO):          21,22,23,24,25,26
% AO + congruent audio (AOCS):      31,32,33,34,35,36
% AO + incongruent audio (AOIS):    41,42,43,44,45,46    
question_trigger_value = 50;
AOCS_audio_trigger_value = 60;
AOIS_audio_trigger_value = 70;
cross_trigger_value = 80;

% crea oggetto porta parallela usando le impostazioni di default
if test  
    dio='none';
else
    dio=digitalio('parallel','LPT1');
    % aggiunge una linea dati in output di 8 bit
    line=addline(dio,0:7,'out');
end
 
% =========================================================================================================
% STIMULI PERMUTATION (each of the 3 block is permuted separately, then stimuli are then concatenated)

% --- files
video_file={'ctrl01','ctrl02','ctrl03','ctrl04','ctrl05','ctrl06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'};
        
audio_file={'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'cs01','cs02','cs03','cs04','cs05','cs06'; ...
            'is01','is02','is03','is04','is05','is06'};         

triggers_values={11,12,13,14,15,16; ...
            21,22,23,24,25,26; ...
            31,32,33,34,35,36; ...
            41,42,43,44,45,46};
        
A=[1 2 3 4];                                    % --- conditions : controls, ao, aocs, aois

ordered_list1=repmat(A,1,N_stimuli_x_cond_x_block);
permutation1=randperm(N_tot_stimuli_x_block);
trials_list1=ordered_list1(permutation1); 

ordered_list2=repmat(A,1,N_stimuli_x_cond_x_block);
permutation2=randperm(N_tot_stimuli_x_block);
trials_list2=ordered_list2(permutation2); 

ordered_list3=repmat(A,1,N_stimuli_x_cond_x_block);
permutation3=randperm(N_tot_stimuli_x_block);
trials_list3=ordered_list3(permutation3); 

ordered_list4=repmat(A,1,N_stimuli_x_cond_x_block);
permutation4=randperm(N_tot_stimuli_x_block);
trials_list4=ordered_list4(permutation4); 

ordered_list5=repmat(A,1,N_stimuli_x_cond_x_block);
permutation5=randperm(N_tot_stimuli_x_block);
trials_list5=ordered_list5(permutation5); 

ordered_list6=repmat(A,1,N_stimuli_x_cond_x_block);
permutation6=randperm(N_tot_stimuli_x_block);
trials_list6=ordered_list6(permutation6); 

trials_list=cat(2,trials_list1, trials_list2, trials_list3, trials_list4, trials_list5, trials_list6);

% permute stimuli....
ordered_video_files=repmat(video_file, 1, N_video_repetition); ... create a matrix of 4x72 cells, replicating the base one (video_file)   
video_files_list=cell(N_type_stim,N_stimuli_x_cond); 

ordered_audio_files=repmat(audio_file, 1, N_video_repetition); ... create a matrix of 4x72 cells, replicating the base one (video_file)   
audio_files_list=cell(N_type_stim,N_stimuli_x_cond); 

ordered_triggers_values=repmat(triggers_values, 1, N_video_repetition); ... create a matrix of 4x72 cells, replicating the base one (video_file)   
triggers_values=cell(N_type_stim,N_stimuli_x_cond); 


for row=1:N_type_stim
    permutation=randperm(N_stimuli_x_cond);

    input_row=ordered_video_files(row,:);
    video_files_list(row,:)=input_row(permutation);   

    input_row=ordered_audio_files(row,:);
    audio_files_list(row,:)=input_row(permutation);   
    
    input_row=ordered_triggers_values(row,:);
    triggers_values(row,:)=input_row(permutation);   
   
end

% define question trials onset
ordered_question_appearance=zeros(N_tot_stimuli);
for n=1:N_random_questions
    ordered_question_appearance(n)=1;
end
permutation=randperm(N_tot_stimuli);
question_appearance = ordered_question_appearance(permutation);


% cross
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];
%====================================================================================================================================
% START EXPERIMENT
%====================================================================================================================================
HideCursor;
is_paused=0;
can_pause=0;
curr_stimulus_num=0; control_trial=0; ao_trial=0; aocs_trial=0; aois_trial=0; question_trial=0;
%====================================================================================================================================
% TRAINING / EXPLANATIONS

[nx, ny, textbounds] = DrawFormattedText(window,['In questo esperimento vedrai una serie di video.\n' 'Alcuni saranno senza audio, altri con il loro giusto audio, altri con un audio sbagliato' ... 
                                                   '\n\n' 'Fai in cenno quando sei pronto'],'center','center',white, 55 ,[],[],1.5);
Screen('Flip', window);
KbWait;

while 1
    if do_training == 1
        %[nx ny textbounds] = DrawFormattedText(window,'video senza audio','center', 'center', white, 55 ,[],[],1.5);
        %Screen('Flip', window);
        %WaitSecs(2);
    % draw the cross and wait for half a second
        Screen('DrawLines', window, cross_center, 3, white);
        Screen('Flip', window);

        start_time=GetSecs;
        while 1 
            elapsed=GetSecs-start_time;
            if elapsed > 0.5
                break;
            end
        end          
        
        rnd=ceil(rand()*N_stimuli_x_cond);
        file_video=fullfile(input_video_folder, [video_files_list{1,rnd} video_file_extension]);
        showMovie(file_video, window);

        WaitSecs(2.5);

        % draw the cross and wait for half a second
        Screen('DrawLines', window, cross_center, 3, white);
        Screen('Flip', window);

        start_time=GetSecs;
        while 1 
            elapsed=GetSecs-start_time;
            if elapsed > 0.5
                break;
            end
        end          
        
        rnd=ceil(rand()*N_stimuli_x_cond);
        file_video=fullfile(input_video_folder, [video_files_list{2,rnd} video_file_extension]);
        trigger_value=triggers_values{2,rnd};    
        showMovie(file_video, window);


        for id=1:0 %... N_available_video

            %[nx ny textbounds] = DrawFormattedText(window,'azione con audio giusto','center', 'center', white, 55 ,[],[],1.5);
            %Screen('Flip', window);
            %WaitSecs(2);

            file_video=fullfile(input_video_folder, [video_file{3,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{3,id} audio_file_extension]);
            showMovieAudio(file_video, file_audio, window, sound_frame,ao);
            WaitSecs(2);
            %[nx ny textbounds] = DrawFormattedText(window,'azione con audio sbagliato','center', 'center', white, 55 ,[],[],1.5);
            %Screen('Flip', window);
            %WaitSecs(2);

            file_video=fullfile(input_video_folder, [video_file{4,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{4,id} audio_file_extension]);
            showMovieAudio(file_video,file_audio, window, sound_frame,ao);
            WaitSecs(2);
        end

        [nx, ny, textbounds] = DrawFormattedText(window,'Ogni tanto ti verra chiesto di dire allo sperimentatore come era il suono del video appena visto.\nle tre possibilita` sono:\n1) suono assente\n2) suono giusto\n3) suono sbagliato','center','center',white, 55 ,[],[],1.5);
        Screen('Flip', window);
        KbWait;
        %WaitSecs(10);

        [nx, ny, textbounds] = DrawFormattedText(window,'Se ti e` tutto chiaro possiamo iniziare con l`esperimento\nPremi S per iniziare \nun qualsiasi altro tasto per rivedere i video','center','center',white, 55 ,[],[],1.5);
        Screen('Flip', window);
        
        
        s_key = KbName('s');
        [a,keypressed,c] = KbWait;  ... DON'T WORK!!! don't know
        if keypressed(s_key) ... eq(KbName(keypressed),'s')
            break;          ... esci dal while ed inizia l'esperimento
        else 
            continue;       ... fai un nuovo ciclo di training
        end
        %end
    end
end

%====================================================================================================================================
% EXPERIMENT
%trials_list
for iter = trials_list

    % if is paused, check for a 'p' press in order to resume the experiment
    while is_paused == 1
        [nx, ny, textbounds] = DrawFormattedText(window,'esperimento in PAUSA','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        r_key = KbName('r');
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(r_key)
                is_paused=0;
                
                % show a 3 seconds countdown panel
                start_time=GetSecs;
                while 1 
                    elapsed=GetSecs-start_time;
                    left=ceil(3-elapsed);
                    [nx, ny, textbounds] = DrawFormattedText(window,['Preparati!, stiamo sta per ripartire\n\n\n' num2str(left)],'center','center',white, 55 ,[],[],1.5);
                    Screen('Flip', window);
                    if elapsed > 3
                        [nx, ny, textbounds] = DrawFormattedText(window,'Ricominciamo!','center','center',white, 55 ,[],[],1.5);
                        Screen('Flip', window);
                        WaitSecs(1);
                        break;
                    end
                end                
            end
        end 
    end

    % draw the cross and wait for half a second
    Screen('DrawLines', window, cross_center, 3, white);
    Screen('Flip', window);

    start_time=GetSecs;
    while 1 
        elapsed=GetSecs-start_time;
        if elapsed > 0.5
            break;
        end
    end     
    
    % show videos
    curr_stimulus_num=curr_stimulus_num+1;
    switch iter

        case 1
            control_trial=control_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,control_trial} video_file_extension]);
            control_trigger_value=triggers_values{iter,control_trial};
            showMovieSendStartTrigger(file_video, window, dio, control_trigger_value,test,trigger_duration);
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,control_trial} '\n']);

        case 2
            ao_trial=ao_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,ao_trial} video_file_extension]);
            AO_trigger_value=triggers_values{iter,ao_trial};
            showMovieSendStartTrigger(file_video, window, dio, AO_trigger_value,test,trigger_duration);
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,ao_trial} '\n']);

        case 3
            aocs_trial=aocs_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aocs_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aocs_trial} audio_file_extension]);            
            AOCS_trigger_value=triggers_values{iter,aocs_trial};
            showMovieSendDoubleTrigger(file_video, file_audio, window, dio, AOCS_trigger_value, sound_frame, AOCS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,aocs_trial} '\n']);

        case 4
            aois_trial=aois_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aois_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aois_trial} audio_file_extension]);            
            AOIS_trigger_value=triggers_values{iter,aois_trial};
            showMovieSendDoubleTrigger(file_video, file_audio, window, dio, AOIS_trigger_value, sound_frame, AOIS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,aois_trial} '\n']);
    end

    % check if question must be shown
    if question_appearance(curr_stimulus_num)
        if ~test
           put_trigger(question_trigger_value,dio,trigger_duration);
        end        
        [nx, ny, textbounds] = DrawFormattedText(window,'come era il suono appena sentito?\na) assente\nb) giusto\nc) sbagliato','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        if do_question_pause == 1
            KbWait;
        else
            WaitSecs(question_time);
        end
    end

    Screen('FillRect', window, black, rect);
    Screen('Flip', window);
    iti=round(iti_time+rand(1));

    % check if 'p' is pressed in order to pause the experiment
    can_pause=1;
    start_time=GetSecs;
    while is_paused == 0
        p_key = KbName('p');
        [keyIsDown,secs, keyCode] = KbCheck;
        if (keyIsDown && can_pause == 1)
%            if eq(KbName(keyCode),'p')
            if keyCode(p_key)
                is_paused=1;
                WaitSecs(0.5);
                break
            end
        end 
        elapsed=GetSecs-start_time;
        if elapsed > iti
            break;
        end            

    end  
    can_pause=0;

    % check if rest is expected
    if rest_appearence(curr_stimulus_num) == 1
        
        [nx, ny, textbounds] = DrawFormattedText(window,'questa parte dell esperimento e` finita\nriposati qualche minuto\nquando sei pronto, avvisa lo sperimentatore','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        KbWait;
        
        % show a 3 seconds countdown panel
        start_time=GetSecs;
        while 1 
            elapsed=GetSecs-start_time;
            left=ceil(3-elapsed);
            [nx, ny, textbounds] = DrawFormattedText(window,['Preparati!, stiamo sta per ripartire\n\n\n' num2str(left)],'center','center',white, 55 ,[],[],1.5);
            Screen('Flip', window);
            if elapsed > 3
                [nx, ny, textbounds] = DrawFormattedText(window,'Ricominciamo!','center','center',white, 55 ,[],[],1.5);
                Screen('Flip', window);
                WaitSecs(1);
                break;
            end
        end        
    end
end

 
ShowCursor;
Screen('Flip', window);
Screen('CloseAll');
sca;
catch err
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('CloseAll');
    err
    err.stack(1)
end

