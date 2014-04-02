clear all 
close all

try
    
    
N_type_stim=4;          % number of different types of stimuli
N_stimuli_x_cond=66;    % number of stimuli for condition
N_tot_stimuli=N_stimuli_x_cond * N_type_stim;

N_available_video=6;
N_video_repetition=N_stimuli_x_cond / N_available_video;  % 66/6=11

N_random_questions=24; 
N_stimuli_noquestions=N_tot_stimuli - N_random_questions;

stimulus_time=3;    %time of presentation for each stimulus in seconds
fix_time=1;         %time of the red fixation cross at the beginning of the experimental block
iti_time=1.5;       %fixed inter stimulus time in seconds (actual ITI = 1.5 * rand(1) )
question_time=4;    %time of question panel 

ListenChar(2);

flipSpdback = 0;
flipSpdwindow = 0; 
black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% MONITOR SETTINGS
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'SuppressAllWarnings', 1);

% rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
rec = [0,0,1280,800]; W=1280; H=800;

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

stimulus_frames=ceil(monitor_freq*stimulus_time);   %number of frames corresponding to stimulus_time seconds
fix_frames=round(monitor_freq*fix_time);      
iti_frames=round(monitor_freq*iti_time);

% TRIGGERS
% crea oggetto porta parallela usanndo le impostazioni di default
 dio = digitalio('parallel','LPT1');

% aggiunge una lian dati in output di 4 bit
 line=addline(dio,0:3,'out');


 for tr=1:20
    putvalue(dio,tr);
    WaitSecs(3);
 end
 
end

 
 