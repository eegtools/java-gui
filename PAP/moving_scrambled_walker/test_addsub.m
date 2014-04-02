% EEGLAB history file generated on the 27-Nov-2013
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab('redraw');
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[STUDY ALLEEG] = pop_loadstudy('filename', 'moving_scrambed_walker.study', 'filepath', 'I:\Projects\moving_scrambled_walker\epochs\OCICA_250');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name','test','commands',{{'index' 1 'load' 'I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\alessandra_finisguerra_OCICA_250_cscrambled.set'} {'index' 2 'load' 'I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\alessandra_finisguerra_OCICA_250_cwalker.set'}},'updatedat','on','savedat','on' );
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'commands',{{'index' 3 'load' 'I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\alessia_OCICA_250_cscrambled.set'} {'index' 4 'load' 'I:\\Projects\\moving_scrambled_walker\\epochs\\OCICA_250\\alessia_OCICA_250_cwalker.set'}},'updatedat','on','savedat','on' );
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw;
