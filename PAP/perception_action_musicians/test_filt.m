% EEGLAB history file generated on the 30-Jan-2014
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_eegfiltnew(EEG, 0.5, 45, 1690, 0, [], 1);
eeglab redraw;
