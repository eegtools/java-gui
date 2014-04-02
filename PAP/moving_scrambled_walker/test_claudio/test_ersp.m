% EEGLAB history file generated on the 30-Oct-2013
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
[STUDY ALLEEG] = pop_loadstudy('filename', 'moving_scrambled_walker.study', 'filepath', 'F:\moving_scrambled_walker\epochs\OCICA_250');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
pop_saveh( ALLCOM, 'test_ersp.m', 'D:\behaviourPlatform\EEG_Tools\moving_scrambled_walker\');

STUDY = pop_erpparams(STUDY, 'plotconditions','together','averagechan','on','topotime',[]);
STUDY = std_erspplot(STUDY,ALLEEG,'channels',{'Fp1' 'Fp2' 'F7'});
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw;
