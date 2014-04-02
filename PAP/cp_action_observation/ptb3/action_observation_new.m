% PSYCHTOOLBOX experiment : multisensory Action Observation for adults and children (healthy and Cerebral Palsy)
% Author: Alberto Inuggi, September 2013.

% SECTIONS:
%   1)  local paths
%   2)  string definition
%   3)  data acquisitions objects (parallel, audio)
%   4)  stimuli & task definition (permutations etc..)
%   5)  temporal & graphics setting
%   6)  output triggers definition
%   7)  input (user selections: 7.1 subject name, 7.2 exp mode, 7.3 video side)
%   8)  screen settings (start psychtoolbox
%   9)  init vars
%   10) TRAINING
%   11) EXPERIMENT ( 11.1 check resume, 11.2 show stimuli, 11.3 check question, 11.4 check pause, 11.5 check rest)

clear all 
close all

% =========================================================================
% 1) LOCAL PATHS
% =========================================================================

...root_dir = 'C:\Documents and Settings\finisguerra\My Documents\MATLAB\cpchildren';
...global_scripts_path='C:\Documents and Settings\finisguerra\My Documents\MATLAB\EEG_tools_svn\global_scripts\';
...ptb3_scripts_path=fullfile(global_scripts_path, 'ptb3');

root_dir = 'C:\Users\pippo\Documents\BEHAVIOUR_PLATFORM\behaviourPlatform@local\cpchildren\';
global_scripts_path='C:\Users\pippo\Documents\BEHAVIOUR_PLATFORM\behaviourPlatform@svn\EEG_Tools\cp_action_observation\';
ptb3_scripts_path=fullfile(global_scripts_path, 'ptb3');
lpt_scripts_path='/media/vicon/Data/behaviour_platform_svn/CommonScript/LPT/ppMex/Lin64';

addpath(ptb3_scripts_path);
addpath(lpt_scripts_path);

% ===================================================================
% 2) STRING DEFINITION 
% ===================================================================
%== screen instructions =====================================================
txt_pre_samplevideos='Preparati! ti mostreremo alcuni video di esempio\n\n\n'; ...'Get ready! we'll show you some sample video\n\n\n'
txt_letsgo='Cominciamo!';   ...'Let's go!'
txt_start_question='Se ti e` tutto chiaro possiamo iniziare con l`esperimento\nPremi S per iniziare \nun qualsiasi altro tasto per rivedere i video'; ...'If everything is clear, we can start the experiment \nPress S key to start \nor any other key to review the videos'
txt_pause='esperimento in PAUSA';...'PAUSE ...'
txt_pause_resume='Preparati! stiamo sta per ripartire\n\n\n'; ...'Get Ready! The experiment is going to start\n\n\n', 'Let's start!'
txt_big_pause='Questa parte dell esperimento e` finita\nriposati qualche minuto\nquando sei pronto, avvisa lo sperimentatore';  ...'This part of the experiment is finished Relac for a few minutes, when you're ready, warns the experimenter'
txt_big_pause_resume='Fai un cenno quando sei pronto per ricominciare';... 'when you are ready, make a sign'


% =========================================================================
% 3) DATA ACQUISITION OBJECTS
% =========================================================================
isWindow=0;
if  strncmp(system_dependent('getos'),'Microsoft',9)
    isWindow=1;
end

if isWindow
    ao = analogoutput('winsound');  % set the sound card to load and send audios when required. create an object mapping the soundcard
    set(ao,'TriggerType','Manual'); % set the trigger to manual to use the trigger() and get a faster sound reproduction
    chans = addchannel(ao,1);       %add an audio channel to the sound card to reproduce the sound
    
    if send_out_trigger
        dio=digitalio('parallel','LPT1');% crea oggetto porta parallela usando le impostazioni di default
        line=addline(dio,0:7,'out');     % aggiunge una linea dati in output di 8 bit
    else
        dio='none';
        line='none';
    end    
else
    InitializePsychSound;
    pahandle = PsychPortAudio('Open', 0, 1, 0, 16000, 2);
    
    address=hex2dec('0378');
    portnum=0;          ... /dev/parport0
    ao='none';
    chans='none';    
end

% if send_out_trigger ~ 0 run in test modality (without sending values to serial ports), if test==0 active 2 is supposed to be connected
send_out_trigger=1;

try
    
% Check if Psychtoolbox is properly installed:
AssertOpenGL;

% ===================================================================
% 4) TEMPORAL & GRAPHICS SETTINGS
% ===================================================================

% ==== temporal 
stimulus_time=3;        % time of presentation for each stimulus in seconds
fix_time=0.5;           % time of the red fixation cross at the beginning of the experimental block
iti_time=1.5;           % fixed inter stimulus time in seconds (actual ITI = 1.5 + rand(1) )
question_time=4;        % time of question panel 
trigger_duration=0.02;  % duration of the trigger in sec. (to avoid trigger overlapping AND trigger detection even subsampling)
sound_frame=45;         % frame at which start audio and send trigger (thought to be 1.5 sec @ 30 fps)
sound_start_onset=1.5;  % latency, within each video, where audio must be triggered

% ==== graphics 
black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% ===================================================================
%  5) OUTPUTS (TRIGGERS)
% ===================================================================

start_experiment_trigger_value = 1;
pause_trigger_value = 2;                    % start: pause, feedback and rest period
resume_trigger_value = 3;                   % end: pause, feedback and rest period
end_experiment_trigger_value = 4;

videoend_trigger_value = 5;
question_trigger_value = 6;
AOCS_audio_trigger_value = 7;
AOIS_audio_trigger_value = 8;
cross_trigger_value = 9;

% ===================================================================
%  6) INPUTS (user selections)
% ===================================================================
user_inputs_paths

% ===================================================================
% 7) STIMULI & TASK DEFINITION 
% ===================================================================
permute_observation_stimuli

% ===================================================================
% 8) SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

...W=800; H=600; rec = [0,0,W,H]; 
rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

%====================================================================================================================================
% 9) INIT VARS
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
% 10) TRAINING / EXPLANATIONS    ====================================================================================================
%====================================================================================================================================
%====================================================================================================================================
ListenChar(2);
showCountDown(window, 3,txt_pre_samplevideos, txt_letsgo, white, 55);

while 1
    if do_training == 1
              
        showCross(window, 0.5, white, 3);       % pick a random control video
        rnd=ceil(rand()*N_TRIALS_X_COND);
        file_video=fullfile(input_video_folder, [video_files_list{1,rnd} video_file_extension]);
        showMovie(file_video, window);
        Screen('FillRect', window, black, rect);
        Screen('Flip', window);
        WaitSecs(2);

        showCross(window, 0.5, white, 3);       % pick a random AO video
        rnd=ceil(rand()*N_TRIALS_X_COND);
        file_video=fullfile(input_video_folder, [video_files_list{2,rnd} video_file_extension]);
        trigger_value=conditions_triggers_values{2,rnd};    
        showMovie(file_video, window);
        Screen('FillRect', window, black, rect);
        Screen('Flip', window);
        WaitSecs(2);

        % show all AOCS & AOIS videos
        for id=1:3 ... N_available_video

            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{3,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{3,id} audio_file_extension]);
            showMovieAudio(file_video, file_audio, window, sound_frame, ao);
            WaitSecs(2);

            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{4,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{4,id} audio_file_extension]);
            showMovieAudio(file_video,file_audio, window, sound_frame, ao);
            WaitSecs(2);
        end
        showImageNseconds(question_image, window, 0);
        
        for id=4:N_available_video
            
            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{4,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{4,id} audio_file_extension]);
            showMovieAudio(file_video,file_audio, window, sound_frame, ao);
            WaitSecs(2);
            
            showCross(window, 0.5, white, 3); 
            file_video=fullfile(input_video_folder, [video_file{3,id} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_file{3,id} audio_file_extension]);
            showMovieAudio(file_video, file_audio, window, sound_frame, ao);
            WaitSecs(2);
        end        
        showImageNseconds(question_image, window, 0);

        % STOP
        [nx, ny, textbounds] = DrawFormattedText(window, txt_start_question,'center','center',white, 55 ,[],[],1.5);
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
% 11) EXPERIMENT  ===============================================================================================================
%====================================================================================================================================
%====================================================================================================================================


if ~send_out_trigger
    put_trigger(start_experiment_trigger_value, dio, trigger_duration);
    WaitSecs(0.5);
end
experiment_start_time = GetSecs;
for iter = trials_list

    % 11.1) ========================================= if is paused, check for a 'r' press in order to resume the experiment
    check_resume

    % draw the cross and wait for half a second
    showCross(window, 0.5, white, 3); 
 
    % 11.2) ========================================= show videos
    curr_stimulus_num=curr_stimulus_num+1;
    switch iter

        case 1
            control_trial=control_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,control_trial} video_file_extension]);
            control_trigger_value=conditions_triggers_values{iter,control_trial};
            showMovieTrigger(file_video, window, dio, control_trigger_value, send_out_trigger, trigger_duration);
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,control_trial} ' ' num2str(GetSecs-experiment_start_time) '\n']);

        case 2
            ao_trial=ao_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,ao_trial} video_file_extension]);
            AO_trigger_value=conditions_triggers_values{iter,ao_trial};
            showMovieTrigger(file_video, window, dio, AO_trigger_value, send_out_trigger, trigger_duration);
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,ao_trial} ' ' num2str(GetSecs-experiment_start_time) '\n']);

        case 3
            aocs_trial=aocs_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aocs_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aocs_trial} audio_file_extension]);            
            AOCS_trigger_value=conditions_triggers_values{iter,aocs_trial};
            showMovieAudioTriggers(file_video, file_audio, window, dio, AOCS_trigger_value, sound_frame, AOCS_audio_trigger_value, send_out_trigger, trigger_duration, ao);    % also send the frame at which send the second trigger
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,aocs_trial} ' ' num2str(GetSecs-experiment_start_time) '\n' ]);

        case 4
            aois_trial=aois_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aois_trial} video_file_extension]);
            file_audio=fullfile(input_audio_folder, [audio_files_list{iter,aois_trial} audio_file_extension]);            
            AOIS_trigger_value=conditions_triggers_values{iter,aois_trial};
            showMovieAudioTriggers(file_video, file_audio, window, dio, AOIS_trigger_value, sound_frame, AOIS_audio_trigger_value, send_out_trigger, trigger_duration, ao);    % also send the frame at which send the second trigger
            fwrite(fp, [curr_stimulus_num ' ' video_files_list{iter,aois_trial} ' ' num2str(GetSecs-experiment_start_time) '\n']);
    end
    
    if send_out_trigger
        put_trigger(videoend_trigger_value, dio, trigger_duration);
    end
    
    % 11.3) check if QUESTION - FEEDBACK must be shown
    check_question

    Screen('FillRect', window, black, rect);
    Screen('Flip', window);
    
    % 11.4) check if REST must be shown
    check_rest
    
    % 11.5) ITI + check if CAN PAUSE (press p)
    check_pause_iti
    
    % 11.6) QUIT ?
    if do_quit
       break;
    end
end

put_trigger(end_experiment_trigger_value, dio, trigger_duration);

if do_question_pause == 1
    showMovie(end_video, window);
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
    err.message
    err.stack(1)
end

% =========================================================================================================
% =========================================================================================================
% LAST MODS
% =========================================================================================================
% =========================================================================================================
% 18/9/2013
% set photo before the 2 pauses' videos
% predetermined questions onsets
% no success sound before 3rd block videos
% 20/09/2013
% send pause trigger together with question triggers (to enable automatic removal of undesidered recordings)
% 23/9/2013
% added a feedback image at block 3 (the map), before video.
% 3/10/2013
% added 0.5 sec pause after start trigger
% 4/11/2013
% added end video & end experiment triggers
% 6/11/2013
% removed need to press Y after a question in adults experiment
% 11/2/2014
% language localization, text set in variables and located at the beginning of the code