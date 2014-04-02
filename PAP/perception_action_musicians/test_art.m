% EEGLAB history file generated on the 28-Jan-2014
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );
EEG = clean_rawdata(EEG, -1, [-1], -1, 5, 0.5);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 0, 1, 1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
eeglab redraw;


EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
EEG = clean_rawdata(EEG, -1, [-1], -1, 5, -1);