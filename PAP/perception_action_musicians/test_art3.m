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
pop_saveh( ALLCOM, 'test_art.m', '/media/Data/behaviourPlatform/EEG_Tools/perception_action_musicians/');
pop_processMARA ( ALLEEG,EEG,CURRENTSET )
ALLEEG = pop_delset( ALLEEG, [2] );
[EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,1);
ALLEEG = pop_delset( ALLEEG, [1] );
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:78] ,'computepower',0,'linefreqs',[50 100] ,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',1);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = clean_rawdata(EEG, -1, [0.25 0.75], -1, 5, -1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
pop_saveh( EEG.history, 'test_art2.m', '/media/Data/behaviourPlatform/EEG_Tools/perception_action_musicians/');
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = clean_rawdata(EEG, -1, [-1], -1, 5, -1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
pop_saveh( ALLCOM, 'test_art2.m', '/media/Data/behaviourPlatform/EEG_Tools/perception_action_musicians/');
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','3 andre active second-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_loadset('filename','3 andre active second-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_autobssemg( EEG, [121.6797], [121.6797], 'bsscca', {'eigratio', [1000000]}, 'emg_psd', {'ratio', [10],'fs', [256],'femg', [15],'estimator',spectrum.welch,'range', [0  39]});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename','2 carol active-Deci_raw.set','filepath','/media/ADATA/Projects/perception_action_musicians/epochs/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_autobssemg( EEG, [121.6797], [121.6797], 'bsscca', {'eigratio', [1000000]}, 'emg_psd', {'ratio', [10],'fs', [256],'femg', [15],'estimator',spectrum.welch,'range', [0  39]});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
eeglab redraw;
