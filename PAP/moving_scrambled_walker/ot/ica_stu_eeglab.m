%==========================================================================
%==========================================================================
% GLOBAL PATHS 
projects_data_path='G:/moving_scrambed_walker/';
plugins_path='/data/matlab';
%==========================================================================
%==========================================================================


%==========================================================================
%==========================================================================
% PROJECT DATA
project_name='moving_scrambled_walker';
subjects_list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
analysis_name='OCICA_250';
%==========================================================================
%==========================================================================

%names of conditions
name_cond={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};

% path where eeglab epochs files are exported
epochs_path=fullfile(projects_data_path,'epochs',analysis_name, '');


% if 1, a preliminary ica decomposition is applyed to each dataset. If a
% decomposition is already present, it is useless.
do_ica=0;


nset=1;

%start EEGLab
%%%%[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

if do_ica
    %compute ica for each dataset
    for nsubj=1:length(subjects_list)
        for cond=1:length(name_cond)
            setname=[subjects_list{nsubj} '_' analysis_name '_' name_cond{cond} '.set'];
            fullsetname=fullfile(epochs_path,setname,'');
            EEG = pop_loadset('filename',setname,'filepath',epochs_path);
            EEG = pop_runica(EEG, 'extended',1,'interupt','on');
            EEG=pop_saveset( EEG, 'filename',EEG.filename,'filepath',EEG.filepath);
        end
    end
end
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];


% discard noisy components


%load the first set file (to inzialize the STUDY structure)
setname=[subjects_list{1} '_' analysis_name '_' name_cond{1} '.set'];
fullsetname=fullfile(epochs_path,setname,'');
EEG = pop_loadset('filename',setname,'filepath',epochs_path);
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name' ,project_name, 'commands',{{ 'index' nset 'load' fullsetname 'subject' subjects_list{1} 'session' 1 'condition' name_cond{1} 'group' '1'}},'updatedat','on','savedat','on' );

%load each epochs set file (subject and condition) into the study structure
%of EEGLab
for nsubj=1:length(subjects_list)
    for cond=1:length(name_cond)
        setname=[subjects_list{nsubj} '_' analysis_name '_' name_cond{cond} '.set'];
        fullsetname=fullfile(epochs_path,setname,'');
        %check study
        [STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
        %load the set file into the study
        [STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'commands',{{'index' nset 'load' fullsetname 'subject' subjects_list{nsubj} 'session' 1 'condition' name_cond{cond} 'group' '1'}},'updatedat','on','savedat','on' );
        CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
        nset=nset+1;    
    end
end
%save study on file
[STUDY EEG] = pop_savestudy( STUDY, EEG, 'filename','moving_scrambed_walker.study','filepath',epochs_path);



%edit study design (very simple: only comparing 4 conditions without
%considering motion and shape factors
STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','condition','variable2','','name','STUDY.design4cond','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',{'cwalker' 'twalker' 'cscrambled' 'tscrambled'});
%save study
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
%compute measures for all channels
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','off','allcomps','on','erp','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'spec','on','specparams',{'specmode' 'fft','freqs' [1:40]},'ersp','on','erspparams',{'cycles', [0.5 0.5], 'freqs' [1:40],'timesout',-400:10:1000,'winsize',64,'freqscale','linear'},'itc','on','recompute','on');        
%compute measures for all components
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'components','scalp','on','interp','off','allcomps','on','erp','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'spec','on','specparams',{'specmode' 'fft','freqs' [1:40]},'ersp','on','erspparams',{'cycles', [0.5 0.5], 'freqs' [1:40],'timesout',-400:10:1000,'winsize',64,'freqscale','linear'},'itc','on','recompute','on');        
%save study
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
%create vector to cluster components
[STUDY ALLEEG] = std_preclust(STUDY, ALLEEG, 1,{'spec' 'npca' 10 'norm' 1 'weight' 1 'freqrange' [4 40] },{'erp' 'npca' 10 'norm' 1 'weight' 1 'timewindow' []},{'scalp' 'npca' 10 'norm' 1 'weight' 1 'abso' 1},{'ersp' 'npca' 10 'freqrange' [4 40]  'timewindow' [] 'norm' 1 'weight' 1},{'itc' 'npca' 10 'freqrange' [4 40]  'timewindow' [] 'norm' 1 'weight' 1});
%cluster components (10 clusters)
[STUDY] = pop_clust(STUDY, ALLEEG, 'algorithm','kmeans','clus_num',  10 );
%save study
[STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');

