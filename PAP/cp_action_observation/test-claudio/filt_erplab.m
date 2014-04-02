% EEGLAB history file generated on the 19-Jul-2013
% ------------------------------------------------

EEG = eeg_checkset( EEG );
EEG = pop_loadset('filename','03_vale-Deci_AO.set','filepath','G:\\groups\\behaviour_lab\\Projects\\EEG_tools\\cp_action_observation\\epochs\\');
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 0.16, 45, 5280, 0, [], 0);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_loadset('filename','03_vale-Deci_AO.set','filepath','G:\\groups\\behaviour_lab\\Projects\\EEG_tools\\cp_action_observation\\epochs\\');
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_basicfilter( EEG,  1:64, 0, 45, 2, 'butter', 0, [] );
EEG = eeg_checkset( EEG );
