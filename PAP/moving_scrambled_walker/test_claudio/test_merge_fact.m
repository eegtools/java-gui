% EEGLAB history file generated on the 07-Oct-2013
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
pop_editoptions( 'option_storedisk', 1, 'option_savetwofiles', 1, 'option_saveica', 0, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 1, 'option_chat', 1);
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[STUDY ALLEEG] = pop_loadstudy('filename', 'moving_scrambed_walker.study', 'filepath', '/media/ADATA NH03/moving_scrambled_walker/epochs/OCICA_250_noconcat');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = std_makedesign(STUDY, ALLEEG, 4, 'variable1','condition','variable2','','name','Design 4','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',{{'tscrambled' 'twalker'} {'cscrambled' 'tscrambled'}},'subjselect',{'alessandra_finisguerra' 'alessia' 'amedeo_schipani' 'antonio2' 'augusta2' 'claudio2' 'denis_giambarrasi' 'eleonora_bartoli' 'giada_fix2' 'jorhabib' 'martina2' 'stefano' 'yannis3'});
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw;
