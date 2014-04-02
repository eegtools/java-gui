% EEGLAB history file generated on the 13-Nov-2013
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','alessandra_finisguerra_OCICA_250_cscrambled.set','filepath','I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
pop_fourieeg( EEG, 1, 1, 125);
EEG = eeg_checkset( EEG );
EEG = pop_firws(EEG, 'fcutoff', [1 50], 'ftype', 'bandpass', 'wtype', 'blackman', 'forder', 250);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','alessandra_finisguerra_OCICA_250_cscrambled.set','filepath','I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
EEG = pop_firma(EEG, 'forder', 800);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','alessandra_finisguerra_OCICA_250_cscrambled.set','filepath','I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_firws(EEG, 'fcutoff', [8 12], 'ftype', 'bandpass', 'wtype', 'blackman', 'forder', 250);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','alessandra_finisguerra_OCICA_250_cscrambled.set','filepath','I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw;
