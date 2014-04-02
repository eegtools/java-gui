% in the current experiment we have:
% 4 experimental conditions ('control' 'AO' 'AOCS' 'AOIS') 
% and we registered EMG activity in 3 muscles: 'DFDR' 'NDFDR' 'DTA'
% each condition is displayed 60 times and it lasts 3400 ms (400 ms of prestimulus and 3000 ms of video observation).
% considering we used a sampling frequency of 256 Hz, each epoch is composed by 870 samples.

% EMG data are stored in a STRUCT variable called emg_structure.
% it contains 3 fields: 
% channels_name:    a cell array containing the labels of the 3 channels
% cond_name:        a cell array containing the labels of the 4 conditions
% channels_data     a 3x4 cell array containing in each cell a 60x870 matrix with the EMG amplitude values.

% Epochs composition:
% 1:102 is baseline
% 103:487 is the reaching part
% 487:870 is the grasping/manipulating part with the sound (in the last two conditions)

% Data present in the structure were ALREADY:
% filtered:             butterworth 0.16-100
% filtered:             butterworth 5-100
% baseline corrected:   -212:-12 ms before video onset 
% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------
% input_folder (set according to your local file system)
input_folder = '/data/projects/cp_action_observation/epochs_emg/raw';
subj_name='CP_03_sara';

% -------------------------------------------------------------------------------------------------------------
load(fullfile(input_folder, [subj_name '_raw_mc_observation_emg.mat']));

emg_structure.channels_name            ... final_muscles_channels_label={'DFDR' 'NDFDR' 'DTA'};   dominant (most used) FDR, non-dominant (least used) FDR, dominant TA
emg_structure.cond_names               ... name_cond={'control' 'AO' 'AOCS' 'AOIS'};

% structured defined as : emg_structure.channels_data{muscle}{condition}(epoch, timepoint)
emg_structure.channels_data{1}{1}(1,1)      ... single value
    
% PLOT MUSCLE DFDR in condition AOCS
muscle_id=1;
cond_id=3;
muscle_condition_trials = emg_structure.channels_data{muscle_id}{cond_id}
 