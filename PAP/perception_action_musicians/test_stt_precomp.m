% EEGLAB history file generated on the 31-Jan-2014
% % ------------------------------------------------
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% [STUDY ALLEEG] = pop_loadstudy('filename', 'perception_action_musicians.study', 'filepath', '/media/ADATA/Projects/perception_action_musicians/epochs');
% CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
% 
% STUDY = std_erpplot(STUDY,ALLEEG,'channels',{'Fp1'});
% STUDY = std_specplot(STUDY,ALLEEG,'channels',{'Fp1'});
% CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
% STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
% pop_editoptions( 'option_storedisk', 1, 'option_savetwofiles', 1, 'option_saveversion6', 1, 'option_single', 1, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 1, 'option_chat', 1);
% [STUDY ALLEEG] = pop_loadstudy('filename', 'perception_action_musicians.study', 'filepath', '/media/ADATA/Projects/perception_action_musicians/epochs');
% CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
% [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','ersp','on','erspparams',{'cycles' [3 0.8]  'nfreqs' 100 'ntimesout' 200},'itc','on');
% CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
% EEG = eeg_checkset( EEG );
% [STUDY EEG] = pop_savestudy( STUDY, EEG, 'savemode','resave');
% CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
% eeglab redraw;


[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','ersp','on',...
    'erspparams',{'cycles' [0]  'freqs', [4:0.5:32], 'timesout', [-1500:20:2996],'freqscale','linear','padratio',4 }...
    ,'itc','on');

% [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','ersp','on','erspparams',{'cycles' [3 0.8]  'freqs', [4:0.5:32], 'timesout', [-900:10:2400],'freqscale','linear'},'itc','on');


'cycles', [0], 'freqs', 4:0.5:40, 'ntimesout', 200,'padratio',2