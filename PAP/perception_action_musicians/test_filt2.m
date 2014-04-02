% EEGLAB history file generated on the 30-Jan-2014
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','2 carol active-Deci_raw_100-R.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG  = pop_basicfilter( EEG,  1:78 , 'Cutoff', [ 0.1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2 ); % GUI: 30-Jan-2014 18:03:13
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG  = pop_basicfilter( EEG,  1:78 , 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180, 'RemoveDC', 'on' ); % GUI: 30-Jan-2014 18:04:08
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
eeglab redraw;
