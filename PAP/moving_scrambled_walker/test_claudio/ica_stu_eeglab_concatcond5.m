%==========================================================================
%==========================================================================
% PROJECT DATA
project_name='moving_scrambled_walker';
subjects_list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
analysis_name='OCICA_250';
%==========================================================================
%==========================================================================


%change the script to overcome a bug of eeglab: is seems that subjects
%names longer than 21 charahters cause problems in the study structure

%define alternative (shoter) names for the subjects
% names=cell(length(subjects_list),1);
% for i=1:9
%     names{i}=['S00' num2str(i)];
% end
% 
% for i=10:length(subjects_list)
%     names{i}=['S0' num2str(i)];
% end


%names of conditions
name_cond={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};

% path where eeglab epochs files are exported
epochs_path=fullfile('/media/ADATA NH03/OCICA_250_concat_cond');

nset=1;

% start EEGLab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

% create the study with the epoched data of all subjects
commands={};
% load each epochs set file (subject and condition) into the study structure
% of EEGLab
for nsubj=1:length(subjects_list)
    for cond=1:length(name_cond)
        setname=[subjects_list{nsubj} '_' analysis_name '_' name_cond{cond} '.set'];
        fullsetname=fullfile(epochs_path,setname,'');
        %using the short names in thes tudy structure (they are written -in
        %any case - into the correponding .set files of the subjects)
        cmd={'index' nset 'load' fullsetname 'subject' subjects_list{nsubj} 'session' 1 'condition' name_cond{cond} 'group' '1'};
        commands=[commands, cmd];    
        nset=nset+1;    
    end
end
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name' ,project_name, 'commands',commands,'updatedat','on','savedat','on' );
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
% edit study design (very simple: only comparing 4 conditions without
% considering motion and shape factors

% change the script to overcome a bug of eeglab: file produced by computing measures in the study structure are saved with the design1...n prefix instead of with the design name chosen by the experimenter, so i prefer to be congruent. the characteristics of the design(s) can still be obtained by the eeglab gui and by the study structure.  

STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','condition','variable2','','name','design1','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',{'cwalker' 'twalker' 'cscrambled' 'tscrambled'});
% possible simpler design with only the centered condtions (see literature)
STUDY = std_makedesign(STUDY, ALLEEG, 2, 'variable1','condition','variable2','','name','design2','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',{'cwalker' 'cscrambled'});

% total number of study designs 
tstd=length(STUDY.design);

%select the study design for the analyses
STUDY = std_selectdesign(STUDY, ALLEEG, 1);
%save study on file
[STUDY EEG] = pop_savestudy( STUDY, EEG, 'filename','moving_scrambed_walker.study','filepath',epochs_path);


% % *TEST* downsampling to test
% %  EEG = pop_resample(EEG, 16); 
% 
% perform ica (conditions of the same subject are previously concatenated)
EEG = pop_runica(EEG, 'icatype','runica','concatcond','on','options',{'extended' 1});

[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'updatedat','on','savedat','on','rmclust','on' );
% 
% save study on file
[STUDY EEG] = pop_savestudy( STUDY, EEG, 'filename','moving_scrambed_walker.study','filepath',epochs_path);


for nstd=1:tstd
    % clean up
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

    % reload the study and working with the study structure 
    [STUDY ALLEEG] = pop_loadstudy( 'filename','moving_scrambed_walker.study','filepath',epochs_path);

    %select the study design for the analyses
    STUDY = std_selectdesign(STUDY, ALLEEG, nstd);

    
    % compute measures for all channels
    [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','off','allcomps','on','erp','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'spec','on','specparams',{'specmode' 'fft','freqs' [1:0.5:40]},'ersp','on','erspparams',{'cycles', [0], 'freqs', 1:0.5:40, 'timesout', -200:8:800,'padratio',16,'freqscale','linear'},'itc','on','recompute','on');        

    % compute measures for all components
    [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'components','scalp','on','interp','off','allcomps','on','erp','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'spec','on','specparams',{'specmode' 'fft','freqs' [1:0.5:40]},'ersp','on','erspparams',{'cycles', [0], 'freqs', 1:0.5:40, 'timesout', -200:8:800,'padratio',16,'freqscale','linear'},'itc','on','recompute','on');        
    % save study

    [STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');

    % create vector to cluster components
    [STUDY ALLEEG] = std_preclust(STUDY, ALLEEG, 1,{'spec' 'npca' 10 'norm' 1 'weight' 1 'freqrange' [4 40] },{'erp' 'npca' 10 'norm' 1 'weight' 1 'timewindow' []},{'scalp' 'npca' 10 'norm' 1 'weight' 1 'abso' 1},{'ersp' 'npca' 10 'freqrange' [4 40]  'timewindow' [] 'norm' 1 'weight' 1},{'itc' 'npca' 10 'freqrange' [4 40]  'timewindow' [] 'norm' 1 'weight' 1});
    % cluster components (10 clusters)
    [STUDY] = pop_clust(STUDY, ALLEEG, 'algorithm','kmeans','clus_num',  10 );
    % save study
    [STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');

end
