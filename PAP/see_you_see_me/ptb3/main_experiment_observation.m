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

%   4)  stimuli & task definition (permutations etc..)
%   5)  temporal & graphics setting
%   6)  output triggers definition
%   7)  input (user selections: 7.1 subject name, 7.2 exp mode, 7.3 video side)
%   8)  screen settings (start psychtoolbox
%   9)  init vars
%   10) EXPERIMENT ( 11.1 check resume, 11.2 show stimuli, 11.3 check question, 11.4 check pause, 11.5 check rest)

clear all 
close all

do_debug=0;

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
...put_trigger=@put_trigger_linux;
isLinux=1;

% audio settings
InitializePsychSound;
pahandle = PsychPortAudio('Open', 0, 1, 0, 16000, 2);

% if send_out_trigger ~ 0 run in test modality (without sending values to serial ports), if test==0 active 2 is supposed to be connected
send_out_trigger=1;






% ===================================================================
% 4) TEMPORAL & GRAPHICS SETTINGS
% ===================================================================
% ==== temporal 
fix_time=1;             % fixation cross display time
iti_time=2;             % fixed inter stimulus time in seconds (actual ITI = 1.5 + rand(1) )
question_time=4;        % time of question panel 
video_length=3;

% ==== graphics 
black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% ===================================================================
%  5) OUTPUTS (TRIGGERS)
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
%  6) INPUTS (user selections)
% ===================================================================
user_inputs_paths

% ===================================================================
% 7) STIMULI & TASK DEFINITION 
% ===================================================================
input_stimuli_file=fullfile(output_video_folder, 'stimuli_list.mat');
permute_observation_stimuli
curr_stimulus_num=0;


% ===================================================================
% 8) SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

if (do_debug == 1)
    W=800; H=900; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end

[mainwnd, rect]         = Screen('OpenWindow', 1, black, [0,0,600,400]);
experimenter_cue_wnd    = Screen('OpenWindow', mainwnd, black, [1300 750 1780 1070]);
[wnd_1, rect]           = Screen('OpenWindow', 0, black, rec);  ... RIGHT SIDE

all_screens             = {mainwnd, wnd_1};
subjects_screens        = {wnd_1};
num_scr                 = length(subjects_screens);



%====================================================================================================================================
% 9) INIT VARS
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


ListenChar(2);
%====================================================================================================================================
% 10) EXPERIMENT  
%====================================================================================================================================
% show TEXT and wait for keypress
[nx, ny, textbounds] = DrawFormattedText(mainwnd, txt_start_question_experimenter, 'center', 'center', white, 55 , [], [], 1.5);
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




if send_out_trigger
    put_trigger_linux(address, start_experiment_trigger_value,  trigger_duration, portnum);
end
experiment_start_time = GetSecs;
WaitSecs(3);

for effector = concat_trials_list

    % 10.1) if is paused, check for a 'r' press in order to resume the experiment
    check_resume_obs
    
    Screen('FillRect', mainwnd, black);
    Screen('Flip', mainwnd);  
    
    % 10.2) show trial
    curr_stimulus_num           = curr_stimulus_num+1;
    disp_subj                   = displayed_agents(curr_stimulus_num);
    movements_counter(disp_subj, effector) = movements_counter(disp_subj, effector) + 1;
    
    cue_trigger_value           = trigger_value_list{disp_subj, effector, movements_counter(disp_subj, effector)};
    media_name                  = video_name_list{disp_subj, effector, movements_counter(disp_subj, effector)};
      
    input_video_file            = fullfile(output_video_folder, [media_name video_file_extension]);
    input_audio_file            = fullfile(output_video_folder, [media_name audio_file_extension]);
    
    fwrite(fp, [num2str(curr_stimulus_num) ': ' video_name_list{disp_subj, effector, movements_counter(disp_subj, effector)} ' ' num2str(GetSecs-experiment_start_time) char([13 10])]);
    
    [nx, ny, textbounds] = DrawFormattedText(mainwnd, ['TRIAL: ' num2str(curr_stimulus_num)], 'center', 'center', white, 55 , [], [], 1.5);
    Screen('Flip',mainwnd);
    
    showCross(wnd_1, fix_time, white, 3);
    %                        (file_video,       file_audio,       win,   dio, start_video_trigger_value, audio_frame, audio_trigger_value, end_video_trigger,       send_out_trigger,duration,         ao)
    showMovieAudioTriggers_mm(input_video_file, input_audio_file, wnd_1, {address, portnum},  cue_trigger_value,         1,          [],   end_trial_trigger_value, 1,               trigger_duration, pahandle);    % also send the frame at which send the second trigger

    
    % 10.3) check if QUESTION - FEEDBACK must be shown
    check_question_obs
    
    Screen('FillRect', experimenter_cue_wnd, black);
    Screen('Flip',experimenter_cue_wnd);
    
    % 10.4)  check if REST must be shown
    check_rest_obs
    
    % 10.5)  ITI + check if CAN PAUSE (press p)
    check_pause_iti_obs
    
    
    
    
    
    
    
    
    
    % 10.7) ========================================= QUIT ???
    if do_quit
       break;
    end
    
end


if send_out_trigger
    put_trigger_linux(address,end_experiment_trigger_value, trigger_duration, portnum);
end

 


ShowCursor;
ListenChar(0);
Screen('CloseAll');

catch err
    ListenChar(0);
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    psychrethrow(psychlasterror);
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
% 25/3/2014
% First version

