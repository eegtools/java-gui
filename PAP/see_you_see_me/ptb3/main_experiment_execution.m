% PSYCHTOOLBOX experiment : mirror...mirror

% mut be run on Linux as Webcam recording is more accurate and stable
% webcam recording is done extracting the video texture and filling a video file
% it records audio from webcam microphones and save as wav.
% manages 3 separate monitors
% send trigger to 2 different EEG devices through a MEX file
% PART 1:
% it has 4 pause

% Author: Alberto Inuggi, March 2014.

% open points:
% mix effectors?
% interleave agents?

% SECTIONS:
%   1)  local paths
%   2)  string definition
%   3)  data acquisitions objects (parallel, audio)
%   4)  WebCam settings
%   5)  stimuli & task definition (permutations etc..)
%   6)  temporal & graphics setting
%   7)  output triggers definition
%   8)  input (user selections: 7.1 subject name, 7.2 exp mode, 7.3 video side)
%   9)  screen settings (start psychtoolbox
%   10) init vars
%   11) EXPERIMENT ( 11.1 check resume, 11.2 show stimuli, 11.3 check question, 11.4 check pause, 11.5 check rest)

clear all 
close all

do_debug=1;

% =========================================================================
% 1) LOCAL PATHS
% =========================================================================
root_dir = '/media/vicon/Data/Projects/mirror_mirror';
global_scripts_path='/media/vicon/Data/behaviour_platform_svn/EEG_Tools/global_scripts';
ptb3_scripts_path=fullfile(global_scripts_path, 'ptb3');
webcam_scripts_path=fullfile(global_scripts_path, 'ptb3', 'webcam');
lpt_scripts_path='/media/vicon/Data/behaviour_platform_svn/CommonScript/LPT/ppMex/Lin64';

addpath(ptb3_scripts_path);
addpath(webcam_scripts_path);
addpath(lpt_scripts_path);

% ===================================================================
% 2) STRING DEFINITION 
% ===================================================================
%== screen instructions =====================================================
txt_letsgo='Cominciamo!';   ...'Let's go!'
txt_start_question_subjects='Se ti e` tutto chiaro possiamo iniziare con l`esperimento'; ...'If everything is clear, we can start the experiment \nPress S key to start \nor any other key to review the videos'
txt_start_question_experimenter='Premi un tasto per iniziare l`esperimento'; ...'If everything is clear, we can start the experiment \nPress S key to start \nor any other key to review the videos'
txt_start_iti='Premi p per mettere in pausa e q per uscire'; ...'If everything is clear, we can start the experiment \nPress S key to start \nor any other key to review the videos'
txt_pause='esperimento in PAUSA';...'PAUSE ...'
txt_pause_resume='Preparati! stiamo sta per ripartire\n\n\n'; ...'Get Ready! The experiment is going to start\n\n\n', 'Let's start!'
txt_question='QUESTION !!!'; ...'Get Ready! The experiment is going to start\n\n\n', 'Let's start!'
txt_resuming='RESUMING';

% =========================================================================
% 3) DATA ACQUISITION OBJECTS
% =========================================================================
address=hex2dec('B030');
portnum=1;  ... parport1
trigger_duration=0.02;   % duration of the trigger in sec. (to avoid trigger overlapping AND trigger detection even subsampling)

isLinux=1;

% audio settings
InitializePsychSound;
recording_freq=16000;

% if send_out_trigger ~ 0 run in test modality (without sending values to serial ports), if test==0 active 2 is supposed to be connected
send_out_trigger=1;

% ===================================================================
% 4) WEBCAM SCREEN SETTINGS
% ===================================================================
init_webcam_screens

% ===================================================================
% 5) TEMPORAL & GRAPHICS SETTINGS
% ===================================================================
% ==== temporal 
cue_time        = 1;
iti_time        = 2;           % fixed inter stimulus time in seconds (actual ITI = 1.5 + rand(1) )
question_time   = 4;        % time of question panel 
video_length    = 3;

% ==== graphics 
black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% ===================================================================
%  6) OUTPUTS (TRIGGERS)
% ===================================================================

start_experiment_trigger_value  = 1;
pause_trigger_value             = 2;                    % start: pause, feedback and rest period
resume_trigger_value            = 3;                   % end: pause, feedback and rest period
end_experiment_trigger_value    = 4;
end_trial_trigger_value         = 5;
question_trigger_value          = 6;
cue_cross_trigger_value         = 9;

% =========================================================================
% =========================================================================

try
    
% Check if Psychtoolbox is properly installed:
AssertOpenGL;

% ===================================================================
%  7) INPUTS (user selections)
% ===================================================================
% used keys
q_key = KbName('q');    ... q: to quit experiment
s_key = KbName('s');    ... s: to start experiment after training
r_key = KbName('r');    ... r: to resume after a manual pause
p_key = KbName('p');    ... p: to manually pause the experiment
y_key = KbName('y');    ... y: correct answer
n_key = KbName('n');    ... n: wrong answer

% 7.1) session ID =====================================================
session_number=1;
output_video_folder=fullfile(root_dir, 'video', ['sess' num2str(session_number)],'');

% get first available session ID
while exist(output_video_folder, 'dir')
    session_number=session_number+1;
    output_video_folder=fullfile(root_dir, 'video', ['sess' num2str(session_number)],'');
end


% ask for confirmation, and check if available
while 1
    str_session_number = input(['please insert session ID (should be ' num2str(session_number) ') :'],'s');
    output_video_folder = fullfile(root_dir, 'video', ['sess' str_session_number],'');
    if ~exist(output_video_folder, 'dir')
        break;
    end
end
session_number=str2num(str_session_number);
mkdir(output_video_folder);



% 7.2 log file and FOLDER definition ======================================
output_log_file=fullfile(root_dir, ['log_execution_session' str_session_number '.txt']); 
fp=fopen(output_log_file,'w+');
if ~fp 
    disp('error opening file descriptor');
end

cues_folder = fullfile(root_dir, 'cues', '');
question_image=fullfile(cues_folder, 'question.png');
video_file_extension='.avi';
audio_file_extension='.wav';
img_file_extension='.png';

% ===================================================================
% 8) STIMULI & TASK DEFINITION 
% ===================================================================
output_stimuli_file=fullfile(output_video_folder, 'stimuli_list.mat');
permute_execution_stimuli
curr_stimulus_num=0;
written_video=cell(2, N_COND, N_TRIALS_X_COND);
written_trigger=cell(2, N_COND, N_TRIALS_X_COND);
% ===================================================================
% 9) SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

if (do_debug == 1)
    W=800; H=900; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end

[mainwnd, rect]         = Screen('OpenWindow', 0, black, rec);
experimenter_cue_wnd    = Screen('OpenWindow', mainwnd, black, [1300 750 1780 1070]);
[wnd_1, rect]           = Screen('OpenWindow', 1, black);  ... RIGHT SIDE
[wnd_2, rect]           = Screen('OpenWindow', 2, black);  ..., [0,0,320,240]);  ... LEFT SIDE
all_screens             = {mainwnd, wnd_1, wnd_2};
subjects_screens        = {wnd_1, wnd_2};
num_scr                 = length(subjects_screens);

executing_subject=1;
observing_subject=2;
%====================================================================================================================================
% 10) INIT VARS
HideCursor;
movements_counter=zeros(2,3);
is_paused=0;
can_pause=0;
pauses_number=0;
fb_answers={0,0,0};     ... stores number of correct answers
curr_block = 1;
question_trial=0;
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12]; % cross
do_quit=0;

init_dummy_functions
ListenChar(2);
%====================================================================================================================================
% 11) EXPERIMENT  
%====================================================================================================================================
% show TEXT and wait for keypress
[nx, ny, textbounds] = DrawFormattedText(mainwnd, txt_start_question_experimenter, 'center', 800, white, 55 , [], [], 1.5);
Screen('Flip',mainwnd);
for w=1:num_scr 
    [nx, ny, textbounds] = DrawFormattedText(subjects_screens{w}, txt_start_question_subjects, 'center', 'center', white, 55 , [], [], 1.5);
    Screen('Flip',subjects_screens{w});
end

while 1
    if KbCheck
        break;
    end;
end

% clear screens
for w=1:length(all_screens) 
    Screen('FillRect', all_screens{w}, black);
    Screen('Flip', all_screens{w});
end
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
%====================================================================================================================================
% start playback
webcamscreens = open_webcam_screens(mainwnd, webcamscreens);
webcamscreens = switch_capturing_webcam_screens(observing_subject, webcamscreens);

if send_out_trigger
    put_trigger_linux(address, start_experiment_trigger_value,  trigger_duration, portnum);
end
experiment_start_time = GetSecs;
WaitSecs(3);

for effector = concat_trials_list

    % 11.1) if is paused, check for a 'r' press in order to resume the experiment
    check_resume
    
    Screen('FillRect', mainwnd, black);
    Screen('Flip', mainwnd);  
    
    % 11.2) show trial
    curr_stimulus_num           = curr_stimulus_num+1;
    movements_counter(executing_subject, effector) = movements_counter(executing_subject, effector) + 1;
    file_cue                    = fullfile(cues_folder, [movement_type_list{executing_subject, effector, movements_counter(executing_subject, effector)} img_file_extension]);
    cue_trigger_value           = trigger_value_list{executing_subject, effector, movements_counter(executing_subject, effector)};
    
    media_name                  = ['sess' num2str(session_number)       ...
                                   '_subj' num2str(executing_subject)   ...
                                   '_' movement_type_list{executing_subject, effector, movements_counter(executing_subject, effector)} ...
                                   '_' num2str(curr_stimulus_num)];
      
    output_video_file           = fullfile(output_video_folder, [media_name video_file_extension]);
    output_audio_file           = fullfile(output_video_folder, [media_name audio_file_extension]);
    written_video{executing_subject, effector, movements_counter(executing_subject, effector)} = media_name;
    written_trigger{executing_subject, effector, movements_counter(executing_subject, effector)} = cue_trigger_value;
    
    fwrite(fp, [num2str(curr_stimulus_num) ': ' movement_type_list{executing_subject, effector, movements_counter(executing_subject, effector)} ' ' num2str(GetSecs-experiment_start_time) char([13 10])]);
    [nx, ny, textbounds] = DrawFormattedText(mainwnd, ['TRIAL: ' num2str(curr_stimulus_num)], 'center', 800, white, 55 , [], [], 1.5);
    Screen('Flip',mainwnd);     
    show_execution_trial
    
    % 11.3)check if QUESTION - FEEDBACK must be shown
    check_question

    Screen('FillRect', experimenter_cue_wnd, black);
    Screen('Flip',experimenter_cue_wnd);    
    
    % 11.4)  check if REST must be shown
    check_rest
    
    % 11.5)  ITI + check if CAN PAUSE (press p)
    check_pause_iti
    
    % 11.6) ========================================= SWITCH
    if (executing_subject == 1)
        executing_subject=2;
        observing_subject=1;
    else
        executing_subject=1;
        observing_subject=2;
    end
    % 11.7) ========================================= QUIT ???
    if do_quit
       break;
    end
    
end

switch_capturing_webcam_screens(0, webcamscreens);   
if send_out_trigger
    put_trigger_linux(address, end_experiment_trigger_value, trigger_duration, portnum);
end

save(output_stimuli_file, 'written_video');
save(output_stimuli_file, 'written_trigger', '-append');

ShowCursor;
ListenChar(0);
Screen('CloseAll');

catch err
    ListenChar(0);
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    psychrethrow(psychlasterror);
    switch_capturing_webcam_screens(0, webcamscreens);    
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
% 11/3/2014
% First version
% 25/3/2014
% steps in different files