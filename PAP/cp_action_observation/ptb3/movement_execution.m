% PSYCHTOOLBOX experiment : multisensory Action Observation for adults and children (healthy and Cerebral Palsy)
% Author: Alberto Inuggi, September 2013.

clear all 
close all

% =========================================================================
% 1) LOCAL PATHS
% =========================================================================

root_dir = 'C:\Documents and Settings\finisguerra\My Documents\MATLAB\cpchildren';
global_scripts_path='C:\Documents and Settings\finisguerra\My Documents\MATLAB\EEG_tools_svn\global_scripts\';
ptb3_scripts_path=fullfile(global_scripts_path, 'ptb3');

%root_dir = 'X:\projects\cp_action_observation'; % '/data/projects/cp_action_observation';
%global_scripts_path='X:\behavior_lab_svn\behaviourPlatform\EEG_Tools\global_scripts\ptb3'; %'/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/global_scripts/ptb3';

addpath(ptb3_scripts_path);

% =========================================================================
% 2) DATA ACQUISITION OBJECTS
% =========================================================================
% if test ~ 0 run in test modality (without sending values to serial ports), if test==0 active 2 is supposed to be connected
test=1;
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
N_block=4;                                              % number of blocks composing the experiment, a 3-4 minutes rest is done during the experiment.
N_type_movement=2;                                      % number of different types of movement [left, right]
N_mov_x_block=5;                                        % number of stimuli for condition

N_tot_mov=N_mov_x_block * N_block;                      % TOTAL number of movements 

% ===================================================================
% 4) TEMPORAL & GRAPHICS SETTINGS
% ===================================================================

% ==== graphics 
black = [0 0 0];
white = [255 255 255];
dot_size = 4;

% ===================================================================
%  5) OUTPUTS (TRIGGERS)
% ===================================================================

start_experiment_trigger_value = 1;
end_experiment_trigger_value = 4;

dominant_mov_trigger_value = 2;
non_dominant_mov_trigger_value = 3;

% ===================================================================
%  6) INPUTS (user selections)
% ===================================================================
% used keys
g_key = KbName('g');    ... g: GO command


% 6.1) subject name =====================================================
subject_label = input('please insert subject label (do not fill in any space char) :','s');
output_log_file = fullfile(root_dir, 'logs', ['log_' subject_label '_' date '.txt']);

while exist(output_log_file, 'file')
    subject_label=input('the entered subject already exist....do you want to overwrite the current log file (y) or insert a new subject label (n) ?','s');
    if (subject_label == 'y' || subject_label == 'Y')
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


% 6.3) movemement start side =====================================================
while 1
    first_hand = input('please specify the hand side to be moved first (press : r or l): ', 's');
    switch first_hand
        case {'r','l'}
            break;
        otherwise
            disp('accepted sides are: l & r');
    end
end


block_sequences=zeros(1, N_block);
if first_hand == 'r'
    block_sequences={'destra','sinistra','destra','sinistra'};
else
    block_sequences={'sinistra','destra','sinistra','destra'};
end



games_folder = fullfile(root_dir, 'video', 'games', '');

use_left_instruction_image = fullfile(games_folder, 'use_left_hand.jpg');
use_right_instruction_image = fullfile(games_folder, 'use_right_hand.jpg');

go_audio = fullfile(games_folder, 'dai_cazzo.wav');

% ===================================================================
% 7) SCREEN SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

W=800; H=600; rec = [0,0,W,H]; 
%rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

%====================================================================================================================================
% 8) INIT VARS
HideCursor;
curr_block = 1;
curr_mov_num_in_block=0; 

%====================================================================================================================================
%====================================================================================================================================
% EXPERIMENT  ===============================================================================================================
%====================================================================================================================================
%====================================================================================================================================
[nx, ny, textbounds] = DrawFormattedText(window,'Dovrai compiere 20 movimenti,10 con la mano destra e 10 con la sinistra. Se ti e` tutto chiaro possiamo iniziare con l`esperimento\nPremi un tasto per iniziare','center','center',white, 55 ,[],[],1.5);
Screen('Flip', window);
KbWait;

if ~test
    put_trigger(start_experiment_trigger_value, dio, trigger_duration);
    WaitSecs(0.5);
end

for bl=1:N_block
    curr_mov_num_in_block=0;
    lato=block_sequences{bl};
    [nx, ny, textbounds] = DrawFormattedText(window,['Ora dovrai muovere la mano ' lato ' per ' num2str(N_mov_x_block) ' volte. Prima di muovere rilassati completamente\naspetta il via dello sperimentatore'],'center','center',white, 55 ,[],[],1.5);
    Screen('Flip', window);
    WaitSecs(8);
    
    for mov=1:N_mov_x_block
        curr_mov_num_in_block=curr_mov_num_in_block+1;
        [nx, ny, textbounds] = DrawFormattedText(window,['Movimento ' num2str(curr_mov_num_in_block) '\nPronto a muovere la mano ' lato '\nRilassati completamente e aspetta il via dello sperimentatore'],'center','center',white, 55 ,[],[],1.5);
        Screen('Flip', window);
        KbWait;
        WaitSecs(1);
        [nx, ny, textbounds] = DrawFormattedText(window,['MUOVI la mano ' lato ],'center','center',white, 55 ,[],[],1.5);
        Screen('Flip', window);
        KbWait;
        WaitSecs(1);        
    end
end

if ~test
    put_trigger(end_experiment_trigger_value, dio, trigger_duration);
end

catch err
    
end
% =========================================================================================================
% =========================================================================================================
% LAST MODS
% =========================================================================================================
% =========================================================================================================