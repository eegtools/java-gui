% SECTIONS:
%   1)  local paths
%   2)  data acquisitions objects (parallel, audio)
%   3)  stimuli & task definition (permutations etc..)
%   4)  temporal & graphics setting
%   5)  output triggers definition
%   6)  input (user selections: 6.1 subject name, 6.2 exp mode, 6.3 video side)
%   7)  screen settings (start psychtoolbox
%   8)  init vars
%   9)  TRAINING
%   10) EXPERIMENT ( 10.1 check resume, 10.2 show stimuli, 10.3 check question, 10.4 check pause, 10.5 check rest)


clear all 
close all

% =========================================================================
% 1) LOCAL PATHS
% =========================================================================

root_dir = 'C:\Documents and Settings\Gaslini\My Documents\MATLAB\cpchildren';
global_scripts_path='C:\Documents and Settings\Gaslini\My Documents\MATLAB\EEG_tools_svn\global_scripts\';
ptb3_scripts_path=fullfile(global_scripts_path, 'ptb3');

%root_dir = 'X:\projects\cp_action_observation'; % '/data/projects/cp_action_observation';
%global_scripts_path='X:\behavior_lab_svn\behaviourPlatform\EEG_Tools\global_scripts\ptb3'; %'/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/global_scripts/ptb3';

addpath(ptb3_scripts_path);

% =========================================================================
% 2) DATA ACQUISITION OBJECTS
% =========================================================================
% if test ~ 0 run in test modality (without sending values to serial ports), if test==0 active 2 is supposed to be connected
test=0;
if ~test
    ao = analogoutput('winsound');  % set the sound card to load and send audios when required. create an object mapping the soundcard
    set(ao,'TriggerType','Manual'); % set the trigger to manual to use the trigger() and get a faster sound reproduction
    chans = addchannel(ao,1);       %add an audio channel to the sound card to reproduce the sound
    
    dio=digitalio('parallel','LPT1');% crea oggetto porta parallela usando le impostazioni di default
    line=addline(dio,0:7,'out');     % aggiunge una linea dati in output di 8 bit
else
    ao='none';
    chans='none';
    dio='none';
end


try
    
% Check if Psychtoolbox is properly installed:
AssertOpenGL;


% ===================================================================
% 3) STIMULI & TASK DEFINITION 
% ===================================================================
% accepted values are when : N_stimuli_x_cond * N_type_stim / N_block / N_available_video ..... is an integer
N_games_block = 3;
N_block=5;                                              % number of blocks composing the experiment, a 3-4 minutes rest is done during the experiment.
N_type_stim=4;                                          % number of different types of stimuli
N_stimuli_x_cond=60;                                    % number of stimuli for condition
N_available_video=6;                                    % number of available video

N_stimuli_x_cond_x_block=N_stimuli_x_cond / N_block;    % number of stimuli for condition for each block
N_tot_stimuli=N_stimuli_x_cond * N_type_stim;           % TOTAL number of stimuli 
N_tot_stimuli_x_block=N_tot_stimuli / N_block;          % number of stimuli for block

N_video_repetition=N_stimuli_x_cond / N_available_video;  % 60/6=10

N_random_questions=24; 
N_stimuli_noquestions=N_tot_stimuli - N_random_questions;

% PERMUTATION (each of the 3 block is permuted separately, then stimuli are then concatenated)
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
        
A=[1 2 3 4];        % --- conditions : controls, ao, aocs, aois

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

trials_list=cat(2,trials_list1, trials_list2, trials_list3, trials_list4, trials_list5);

% permute stimuli....
ordered_video_files=repmat(video_file, 1, N_video_repetition); ... create a matrix of 4x60 cells, replicating the base one (video_file)   
video_files_list=cell(N_type_stim,N_stimuli_x_cond); 

ordered_audio_files=repmat(audio_file, 1, N_video_repetition); ... create a matrix of 4x60 cells, replicating the base one (video_file)   
audio_files_list=cell(N_type_stim,N_stimuli_x_cond); 

ordered_triggers_values=repmat(triggers_values, 1, N_video_repetition); ... create a matrix of 4x60 cells, replicating the base one (video_file)   
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

ordered_question_appearance1=zeros(N_tot_stimuli/N_games_block);
for n=1:(N_random_questions/N_games_block)
    ordered_question_appearance1(n)=1;
end
permutation=randperm(N_tot_stimuli/N_games_block);
question_appearance1 = ordered_question_appearance1(permutation);

ordered_question_appearance2=zeros(N_tot_stimuli/N_games_block);
for n=1:(N_random_questions/N_games_block)
    ordered_question_appearance2(n)=1;
end
permutation=randperm(N_tot_stimuli/N_games_block);
question_appearance2 = ordered_question_appearance2(permutation);

ordered_question_appearance3=zeros(N_tot_stimuli/N_games_block);
for n=1:(N_random_questions/N_games_block)
    ordered_question_appearance3(n)=1;
end
permutation=randperm(N_tot_stimuli/N_games_block);
question_appearance3 = ordered_question_appearance3(permutation);

question_appearance=cat(2,question_appearance1,question_appearance2,question_appearance3);


% define when to rest : two pauses are planned for children (mode 0), 4 pauses for adults (mode 1 & 2)
rest_appearence=zeros(N_tot_stimuli);


% ===================================================================
% 4) TEMPORAL & GRAPHICS SETTINGS
% ===================================================================

% ==== temporal 
stimulus_time=3;        %time of presentation for each stimulus in seconds
fix_time=0.5;           %time of the red fixation cross at the beginning of the experimental block
iti_time=1.5;           %fixed inter stimulus time in seconds (actual ITI = 1.5 + rand(1) )
question_time=4;        %time of question panel 
trigger_duration=0.02;  %duration of the trigger in sec. (to avoid trigger overlapping AND trigger detection even subsampling)
sound_frame=45;         % frame at which start audio and send trigger (thought to be 1.5 sec @ 30 fps)

% ==== graphics 
black = [0 0 0];
white = [255 255 255];
dot_size = 4;


% ===================================================================
%  5) OUTPUTS (TRIGGERS)
% ===================================================================
% Control video:                    11,12,13,14,15,16
% action observation (AO):          21,22,23,24,25,26
% AO + congruent audio (AOCS):      31,32,33,34,35,36
% AO + incongruent audio (AOIS):    41,42,43,44,45,46
start_experiment_value = 1;
pause_value = 2;                    % start: pause, feedback and rest period
resume_value = 3;                   % end: pause, feedback and rest period

question_trigger_value = 6;
AOCS_audio_trigger_value = 7;
AOIS_audio_trigger_value = 8;
cross_trigger_value = 9;

% ===================================================================
%  6) INPUTS (user selections)
% ===================================================================
% used keys
s_key = KbName('s');    ... s: to start experiment after training
r_key = KbName('r');    ... r: to resume after a manual pause
p_key = KbName('p');    ... p: to manually pause the experiment
y_key = KbName('y');    ... y: correct answer
n_key = KbName('n');    ... n: wrong answer


% 6.1) subject name =====================================================
subject_label = input('please insert subject label (do not fill in any space char) :','s');
output_log_file = fullfile(root_dir, 'logs', ['log_' subject_label '_' date '.txt']);

while exist(output_log_file, 'file')
    subject_label=input('the entered subject already exist....do you want to overwrite the current log file (Y) or insert a new subject label (N) ?','s');
    if (subject_label == 'Y')
        break;
    else
        subject_label=input('please insert subject label (do not fill in any space char)','s');
        output_log_file=fullfile(root_dir, 'logs', ['log_' subject_label '_' date '.txt']);
    end
end
 fp=fopen(output_log_file,'w+');
if ~fp 
    disp('error opening file descriptor');
end

% 6.2) experiment mode ================================================
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
    % adults mode = 4 big pauses 
    rest_appearence(48)=1;
    rest_appearence(96)=1;
    rest_appearence(144)=1;
    rest_appearence(192)=1;
else
    % children mode = only 2 big pauses 
    rest_appearence(N_tot_stimuli/N_games_block)=1;
    rest_appearence((N_tot_stimuli/N_games_block)*2)=1;    
end

% 6.3) video side =====================================================
while 1
    video_side = input('please specify the hand side to be displayed (press : r or l): ', 's');
    switch video_side
        case {'r','l'}
            break;
        otherwise
            disp('accepted sides are: l & r');
    end
end

input_video_folder = fullfile(root_dir, 'video', ['video_' video_side], '');
input_audio_folder = fullfile(root_dir, 'video', 'audio', '');
games_folder = fullfile(root_dir, 'video', 'games', '');

start_video = fullfile(games_folder, 'start_video.avi');
instruction_image = fullfile(games_folder, 'descrizione_compito.jpg');
question_image = fullfile(games_folder, 'question.jpg');

fb_roots = {fullfile(games_folder, 'feedback_1', ''), fullfile(games_folder, 'feedback_2', ''), fullfile(games_folder, 'feedback_3', '')};
feedback_files = {'fb1_1.jpg','fb1_2.jpg','fb1_3.jpg','fb1_4.jpg','fb1_5.jpg','fb1_6.jpg','fb1_7.jpg','fb1_8.jpg'; ...
                  'fb2_1.jpg','fb2_2.jpg','fb2_3.jpg','fb2_4.jpg','fb2_5.jpg','fb2_6.jpg','fb2_7.jpg','fb2_8.jpg'; ...
                  'fb3_1.mp4','fb3_2.mp4','fb3_3.mp4','fb3_4.mp4','fb3_5.mp4','fb3_6.mp4','fb3_7.mp4','fb3_8.mp4'};
              
pause_videos = {fullfile(games_folder, 'pause_1.avi'), fullfile(games_folder, 'pause_2.mp4')};
end_video = fullfile(games_folder, 'end_video.mp4');

video_file_extension='.mp4';
audio_file_extension='.wav';

% ===================================================================
% 7) SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

%W=800; H=600; rec = [0,0,W,H]; 
rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

%====================================================================================================================================
% 8) INIT VARS
HideCursor;
is_paused=0;
can_pause=0;
pauses_number=0;
fb_answers={0,0,0};     ... stores number of correct answers
curr_block = 1;
curr_stimulus_num=0; control_trial=0; ao_trial=0; aocs_trial=0; aois_trial=0; question_trial=0;
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12]; % cross

%====================================================================================================================================
if do_question_pause == 1
    showMovie(start_video, window);
    showImageNseconds(instruction_image, window, 0);
end

%====================================================================================================================================
% 9) TRAINING / EXPLANATIONS    ================================================================================================
%====================================================================================================================================
%====================================================================================================================================

%[nx, ny, textbounds] = DrawFormattedText(window,['In questo esperimento vedrai una serie di video.\n' 'Alcuni saranno senza audio, altri con il loro giusto audio, altri con un audio sbagliato' ... 
%                                                   '\n\n' 'Fai in cenno quando sei pronto'],'center','center',white, 55 ,[],[],1.5);
%Screen('Flip', window);
%KbWait;

showCountDown(window, 3, 'Preparati!, ti mostreremo alcuni video di esempio\n\n\n', 'Cominciamo!', white, 55);

while 1
    if do_training == 1
              
        showCross(window, 0.5, white, 3);       % pick a random control video
        rnd=ceil(rand()*N_stimuli_x_cond);
        file_video=fullfile(input_video_folder, [video_files_list{1,rnd} video_file_extension]);
        showMovie(file_video, window);
        Screen('FillRect', window, black, rect);
        Screen('Flip', window);
        WaitSecs(2);

        showCross(window, 0.5, white, 3);       % pick a random AO video
        rnd=ceil(rand()*N_stimuli_x_cond);
        file_video=fullfile(input_video_folder, [video_files_list{2,rnd} video_file_extension]);
        trigger_value=triggers_values{2,rnd};    
        showMovie(file_video, window);
        Screen('FillRect', window, black, rect);
        Screen('Flip', window);
        WaitSecs(2);

        % show all AOCS & AOIS videos
        for id=1:3 ... N_available_video

            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{3,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{3,id} audio_file_extension]);
            showMovieAudio(file_video, file_audio, window, sound_frame,ao);
            WaitSecs(2);

            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{4,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{4,id} audio_file_extension]);
            showMovieAudio(file_video,file_audio, window, sound_frame,ao);
            WaitSecs(2);
        end
        showImageNseconds(question_image, window, 0);
        
        for id=4:N_available_video
            
            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{4,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{4,id} audio_file_extension]);
            showMovieAudio(file_video,file_audio, window, sound_frame,ao);
            WaitSecs(2);
            
            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{3,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{3,id} audio_file_extension]);
            showMovieAudio(file_video, file_audio, window, sound_frame,ao);
            WaitSecs(2);
        end        
        showImageNseconds(question_image, window, 0);

        % STOP
        [nx, ny, textbounds] = DrawFormattedText(window,'Se ti e` tutto chiaro possiamo iniziare con l`esperimento\nPremi S per iniziare \nun qualsiasi altro tasto per rivedere i video','center','center',white, 55 ,[],[],1.5);
        Screen('Flip', window);
        
        [a, keypressed, c] = KbWait;
        if keypressed(s_key)
            break;          ... esci dal while ed inizia l'esperimento
        else 
            continue;       ... fai un nuovo ciclo di training
        end
    else
        % do_training = 0;
        break;
    end
end

%====================================================================================================================================
%====================================================================================================================================
% 10) EXPERIMENT  ===============================================================================================================
%====================================================================================================================================
%====================================================================================================================================

if ~test
    put_trigger(start_experiment_value, dio, trigger_duration);
end
experiment_start_time = GetSecs;
for iter = trials_list

    % 10.1) ========================================= if is paused, check for a 'r' press in order to resume the experiment
    while is_paused == 1
        [nx, ny, textbounds] = DrawFormattedText(window,'esperimento in PAUSA','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(r_key)
                is_paused=0;
                showCountDown(window, 3, 'Preparati!, stiamo sta per ripartire\n\n\n', 'Ricominciamo!', white, 55);
                if ~test
                    put_trigger(resume_value,dio,trigger_duration);
                end
            end
        end 
    end

    % draw the cross and wait for half a second
    showCross(window, 0.5, white, 3); 
 
    % 10.2) ========================================= show videos
    curr_stimulus_num=curr_stimulus_num+1;
    switch iter

        case 1
            control_trial=control_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,control_trial} video_file_extension]);
            control_trigger_value=triggers_values{iter,control_trial};
            showMovieTrigger(file_video, window, dio, control_trigger_value,test,trigger_duration);
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,control_trial} ' ' num2str(GetSecs-experiment_start_time) '\n']);

        case 2
            ao_trial=ao_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,ao_trial} video_file_extension]);
            AO_trigger_value=triggers_values{iter,ao_trial};
            showMovieTrigger(file_video, window, dio, AO_trigger_value,test,trigger_duration);
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,ao_trial} ' ' num2str(GetSecs-experiment_start_time) '\n']);

        case 3
            aocs_trial=aocs_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aocs_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aocs_trial} audio_file_extension]);            
            AOCS_trigger_value=triggers_values{iter,aocs_trial};
            showMovieAudioTriggers(file_video, file_audio, window, dio, AOCS_trigger_value, sound_frame, AOCS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,aocs_trial} ' ' num2str(GetSecs-experiment_start_time) '\n' ]);

        case 4
            aois_trial=aois_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aois_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aois_trial} audio_file_extension]);            
            AOIS_trigger_value=triggers_values{iter,aois_trial};
            showMovieAudioTriggers(file_video, file_audio, window, dio, AOIS_trigger_value, sound_frame, AOIS_audio_trigger_value,test,trigger_duration,ao);    % also send the frame at which send the second trigger
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,aois_trial} ' ' num2str(GetSecs-experiment_start_time) '\n']);
    end

    % 10.3) ========================================= check if QUESTION - FEEDBACK must be shown
    if question_appearance(curr_stimulus_num)
        if ~test
           put_trigger(question_trigger_value,dio,trigger_duration);
        end  
        % SHOW QUESTION IMAGE
        keypressed = showImageNseconds(question_image, window, 0);
        if do_question_pause == 1
            %[a, keypressed, c] = KbWait;
            if keypressed(y_key)
                fb_answers{curr_block}=fb_answers{curr_block}+1;
            end
            if fb_answers{curr_block} == 0
                source = fullfile(fb_roots{curr_block}, feedback_files{curr_block,1});
            else
                source = fullfile(fb_roots{curr_block}, feedback_files{curr_block,fb_answers{curr_block}});
            end
            if curr_block == 3
                showMovie(source, window);
            else
                showImageNseconds(source, window, question_time);
            end
            showCountDown(window, 3, 'Preparati!, stiamo sta per ripartire\n\n\n', 'Ricominciamo!', white, 55); 
        else
            WaitSecs(question_time);
        end
        if ~test
            put_trigger(resume_value,dio,trigger_duration);
        end        
    end

    Screen('FillRect', window, black, rect);
    Screen('Flip', window);
    iti=round(iti_time+rand(1));

    % 10.4) ========================================= check if 'p' is pressed in order to pause the experiment
    can_pause=1;
    start_time=GetSecs;
    while is_paused == 0
        [keyIsDown,secs, keyCode] = KbCheck;
        if (keyIsDown && can_pause == 1)
            if keyCode(p_key)
                is_paused=1;
                WaitSecs(0.5);
                if ~test
                    put_trigger(pause_value, dio, trigger_duration);
                end                
                break
            end
        end 
        elapsed=GetSecs-start_time;
        if elapsed > iti
            break;
        end            

    end  
    can_pause=0;
    
    % 10.5) ========================================= check if rest is expected
    if rest_appearence(curr_stimulus_num) == 1
        if ~test
            put_trigger(pause_value,dio,trigger_duration);
        end        
        %[nx, ny, textbounds] = DrawFormattedText(window,'questa parte dell esperimento e` finita\nriposati qualche minuto\nquando sei pronto, avvisa lo sperimentatore','center','center',white, 55 ,[],[],1.5);
        showMovie(pause_videos{curr_block}, window);
        
        [nx, ny, textbounds] = DrawFormattedText(window,'Fai in cenno quando sei pronto per ricominciare','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        KbWait;
        % show a 3 seconds countdown panel
        showCountDown(window, 3, 'Preparati!, stiamo sta per ripartire\n\n\n', 'Ricominciamo!', white, 55); 
        if ~test
            put_trigger(resume_value,dio,trigger_duration);
        end       
        curr_block=curr_block+1;
    end
end
showMovie(end_video, window);
 
ShowCursor;
Screen('Flip', window);
Screen('CloseAll');
sca;
catch err
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('CloseAll');
    err
    err.message
    err.stack(1)
end

