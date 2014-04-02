% EEGLAB history file generated on the 31-Oct-2013
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[STUDY ALLEEG] = pop_loadstudy('filename', 'moving_scrambled_walker.study', 'filepath', 'G:\moving_scrambled_walker\epochs\OCICA_250');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];

STUDY = std_erspplot(STUDY,ALLEEG,'channels',{'F3'});
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw;
