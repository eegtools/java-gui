% EEGLAB history file generated on the 30-Jan-2014
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[STUDY ALLEEG] = pop_loadstudy('filename', 'perception_action_musicians.study', 'filepath', '/media/ADATA/Projects/perception_action_musicians/epochs');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','CueVsImperative','variable2','','name','STUDY.design 1','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',{'Match' 'Misatch' 'nolevels'},'subjselect',{'2 carol active-Deci' '2 carol passive-Deci'});
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
[STUDY ALLEEG] = pop_loadstudy('filename', 'perception_action_musicians.study', 'filepath', '/media/ADATA/Projects/perception_action_musicians/epochs');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
[STUDY ALLEEG] = pop_loadstudy('filename', 'perception_action_musicians.study', 'filepath', '/media/ADATA/Projects/perception_action_musicians/epochs');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
[STUDY ALLEEG] = pop_loadstudy('filename', 'perception_action_musicians.study', 'filepath', '/media/ADATA/Projects/perception_action_musicians/epochs');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = std_makedesign(STUDY, ALLEEG, 3, 'variable1','CueVsImperative','variable2','','name','Design 3','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',{'Match' 'Misatch'},'subjselect',{'2 carol active-Deci' '2 carol passive-Deci'});
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw;
