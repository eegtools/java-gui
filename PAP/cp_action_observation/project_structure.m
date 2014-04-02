%  project
%           file system links
%           task
%           import    
%           eegdata
%           preproc
%           epoching
%           groups
%           design
%           stats
%           postprocess
%           results_display
%           export
%           brainstorm

% times are set in seconds and derived in ms 
% ======================================================================================================
% START
% ======================================================================================================
project.name='cp_action_observation';         ... must correspond to 'local_projects_data_path' subfolder name
project.analysis_name='raw';                  ... subfolder containing the current analysis type (refers to EEG device input data type)

project.do_source_analysis=0;
project.do_emg_analysis=1;
project.do_cluster_analysis=0;

% ======================================================================================================
% PATHS
% ======================================================================================================
project.paths.projects='';
project.paths.epochs='';
project.paths.scripts='';

% ======================================================================================================
% TASK
% ======================================================================================================
project.task.events.start_experiment_trigger_value = 1;
project.task.events.pause_trigger_value = 2;                    % start: pause, feedback and rest period
project.task.events.resume_trigger_value = 3;                   % end: pause, feedback and rest period
project.task.events.end_experiment_trigger_value = 4;
project.task.events.videoend_trigger_value = 5;
project.task.events.question_trigger_value = 6;
project.task.events.AOCS_audio_trigger_value = 7;
project.task.events.AOIS_audio_trigger_value = 8;
project.task.events.cross_trigger_value = 9;
project.task.events.baseline_start_trigger_value = 10;


% ======================================================================================================
% EEGDATA
% ======================================================================================================
project.eegdata.nch=68;         % channels_number
project.eegdata.nch_eeg=64;     % channels_number
project.eegdata.fs=256;         % sampling frequency in Hz
project.eegdata.eeglab_channels_file_name='standard-10-5-cap385.elp';       % channels file name
project.eegdata.eeglab_channels_file_path=''; ... later set by define_paths
    

project.eegdata.eeg_channels_list=[1:project.eegdata.nch_eeg];
project.eegdata.emg_channels_list=[66 67 68];
project.eegdata.emg_channels_list_labels={'DFDR' 'NDFDR' 'DTA'};
project.eegdata.eog_channels_list=[65];
project.eegdata.no_eeg_channels_list=[project.eegdata.emg_channels_list project.eegdata.eog_channels_list];

% ======================================================================================================
% IMPORT
% ======================================================================================================
project.import.acquisition_system='BIOSEMI';
% input
project.import.original_data_extension='bdf';
project.import.original_data_folder='raw';
project.import.original_data_suffix=''; ... often empty
project.import.original_data_prefix=''; ... often empty

%output
project.import.output_suffix='_raw'; 
project.import.emg_output_postfix= '_observation_emg';

project.import.electrodes2discard=[];   ...{'HEOG','RM','VEOG'};
project.import.reference_channels=[];

project.import.polygraphic2transform={{65,66,'DVEOG'};{67,68,'DFDR'};{69,70,'NDFDR'};{71,72,'DTA'}};

project.import.valid_marker={'11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46' '1' '2' '3' '4' '5' '6' '7' '8' '9' '50' '60' '70' '80'};  ... 'stimuli'
% ======================================================================================================
% PREPROCESSING
% ======================================================================================================
% GLOBAL FILTER
project.preproc.ff1_global=0.16;        % lower frequency in Hz
project.preproc.ff2_global=100;         % higher frequency

%FURTHER EEG FILTER
project.preproc.ff1_eeg=0.16;           % lower frequency
project.preproc.ff2_eeg=45;             % higher frequency

%FURTHER EOG FILTER
project.preproc.ff1_eog=0.16;           % lower frequency
project.preproc.ff2_eog=8;              % higher frequency

%FURTHER EMG FILTER
project.preproc.ff1_emg=5;              % lower frequency
project.preproc.ff2_emg=100;            % higher frequency

% NOTCH
project.preproc.do_notch=1;

% ======================================================================================================
% EPOCHING
% ======================================================================================================
% EEG
project.epoching.input_suffix=[project.import.output_suffix '_mc']; 

project.epoching.epo_st.s=-1;             % epochs start latency
project.epoching.epo_end.s=3;             % epochs end latency
project.epoching.bc_st.s=-0.9;            % baseline correction start latency
project.epoching.bc_end.s=-0.512;         % baseline correction end latency

% point
project.epoching.bc_st_point=round(abs(project.epoching.epo_st.s-project.epoching.bc_st.s)/(1/project.eegdata.fs))+1;
project.epoching.bc_end_point=round(abs(project.epoching.epo_st.s-project.epoching.bc_end.s)*project.eegdata.fs)+1;

% EMG
project.epoching.emg_epo_st.s=-1;             % epochs start latency
project.epoching.emg_epo_end.s=3;             % epochs end latency
project.epoching.emg_bc_st.s=-0.9;            % baseline correction start latency
project.epoching.emg_bc_end.s=-0.512;         % baseline correction end latency

% point
project.epoching.emg_bc_st_point=round(abs(project.epoching.emg_epo_st.s-project.epoching.emg_bc_st.s)/(1/project.eegdata.fs))+1;
project.epoching.emg_bc_end_point=round(abs((project.epoching.emg_epo_st.s-project.epoching.emg_bc_end.s))*project.eegdata.fs)+1;

% markers
project.epoching.mrkcode_cond={{'11' '12' '13' '14' '15' '16'};... 
		   {'21' '22' '23' '24' '25' '26'};... 
		   {'31' '32' '33' '34' '35' '36'};...
		   {'41' '42' '43' '44' '45' '46'};...  % conditions: marker codes & name
           };
project.epoching.valid_marker={'11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46'};     % conditions: marker codes & name

project.epoching.condition_names={'control' 'AO' 'AOCS' 'AOIS'};
project.epoching.numcond=length(project.epoching.condition_names);

% ======================================================================================================
% GROUPS
% ======================================================================================================
project.subjects.group_names={'CC', 'CP'};
project.subjects.groups={{'AC_01_alice', 'AC_02_chiara','AC_03_vale', 'AC_04_dan', 'AC_05_miki', 'AC_06_alby_sw', 'AC_07_diego', 'AC_10_cristina_sw','AC_11_claudio','AC_12_fabio','AC_13_emmanuel','AC_14_andrea', 'AC_15_alessandra'}; ...
            {'BB', 'BB2'} ...
            };
% non c'è completa coerenza con il valore gruppo definito a livello di singolo soggetto, e le liste presenti in groups
project.subjects.data(1)=struct('name',  'CC_01_vittoria', 'group', 'CC', 'age', 10, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(2)=struct('name',  'CC_02_fabio',    'group', 'CC', 'age', 9,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(3)=struct('name',  'CC_03_anna',     'group', 'CC', 'age', 8,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(4)=struct('name',  'CC_04_giacomo',  'group', 'CC', 'age', 6,  'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(5)=struct('name',  'CC_05_stefano',  'group', 'CC', 'age', 10, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(6)=struct('name', 'CC_06_giovanni',  'group', 'CC', 'age', 6, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(6)=struct('name', 'CC_07_davide',  'group', 'CC', 'age', 10, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);

project.subjects.data(7)=struct('name',  'CP_01_riccardo', 'group', 'CP', 'age', 9,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(8)=struct('name',  'CP_02_ester',    'group', 'CP', 'age', 8,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(9)=struct('name',  'CP_03_sara',     'group', 'CP', 'age', 11, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(10)=struct('name',  'CP_04_matteo',   'group', 'CP', 'age', 12, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(11)=struct('name', 'CP_05_gregorio', 'group', 'CP', 'age', 8,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(12)=struct('name', 'CP_06_fernando', 'group', 'CP', 'age', 11, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(13)=struct('name', 'CP_07_roberta',  'group', 'CP', 'age', 12, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(14)=struct('name', 'CP_08_mattia',  'group', 'CP', 'age', 7, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(15)=struct('name', 'CP_09_alessia',  'group', 'CP', 'age', 10, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(16)=struct('name', 'CP_10_livia',  'group', 'CP', 'age', 10, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);

project.subjects.data(13).bad_ch={'P1'};
project.subjects.data(6).bad_ch={'PO3'};

project.subjects.list={project.subjects.data.name};
project.subjects.numsubj=length(project.subjects.list);

% ======================================================================================================
% DESIGN
% ======================================================================================================
project.design(1).list=struct('name', 'ao_control'  , 'factor1_name', 'condition', 'factor1_levels', {'ao','control'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(2).list=struct('name', 'aocs_control', 'factor1_name', 'condition', 'factor1_levels', {'aocs','control'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(3).list=struct('name', 'aocs_ao'     , 'factor1_name', 'condition', 'factor1_levels', {'aocs','ao'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(4).list=struct('name', 'aocs_aois'   , 'factor1_name', 'condition', 'factor1_levels', {'aocs','aois'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(5).list=struct('name', 'aois_ao'     , 'factor1_name', 'condition', 'factor1_levels', {'aois','ao'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(6).list=struct('name', 'sound_effect', 'factor1_name', 'sound'    , 'factor1_levels', {'aocs','aois','ao'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');

% structures that associates conditions' file with (multiple) factor(s)
project.design(1).factor_list=struct('file_match',{'control'}   ,'factor','condition','level','control');
project.design(2).factor_list=struct('file_match',{'AO'}        ,'factor','condition','level','ao');
project.design(3).factor_list=struct('file_match',{'AOCS'}      ,'factor','condition','level','aocs');
project.design(4).factor_list=struct('file_match',{'AOIS'}      ,'factor','condition','level','aois');
        
% ======================================================================================================
% STATS
% ======================================================================================================
% ERP
project.stats.erp.pvalue=0.025; ...0.01;                % level of significance applied in ERP statistical analysis
project.stats.erp.num_permutations=5000;                % number of permutations applied in ERP statistical analysis
project.stats.eeglab.erp.method='bootstrap';            % method applied in ERP statistical analysis
project.stats.eeglab.erp.correction='fdr';              % multiple comparison correction applied in ERP statistical analysis

% ERSP
project.stats.ersp.pvalue=0.025; ...0.01;               % level of significance applied in ERSP statistical analysis
project.stats.ersp.num_permutations=5000;               % number of permutations applied in ERP statistical analysis
project.stats.eeglab.ersp.method='bootstrap';           % method applied in ERP statistical analysis
project.stats.eeglab.ersp.correction='fdr';             % multiple comparison correction applied in ERP statistical analysis

% BRAINSTORM
project.stats.brainstorm.pvalue=0.025; ...0.01;         % level of significance applied in ERSP statistical analysis
project.stats.brainstorm.correction='fdr';              % multiple comparison correction applied in ERP statistical analysis

% SPM
project.stats.spm.pvalue=0.025; ...0.01;                % level of significance applied in ERSP statistical analysis
project.stats.spm.correction='fwe';             % multiple comparison correction applied in ERP statistical analysis

% for each design of interest, perform or not statistical analysis of erp
project.stats.show_statistics_list={'on','on','on','on','on','on','on','on'};   

% ======================================================================================================
% POSTPROCESS
% ======================================================================================================
% project.postprocess.erp.design(1).time_windows(1)=struct('name','0-750' ,'mins',0, 'maxs',0.75,'minms',0, 'maxms',750);
% project.postprocess.erp.design(1).time_windows(2)=struct('name','750'   ,'mins',0.75, 'maxs',1.5,'minms',750, 'maxms',1500);
% project.postprocess.erp.design(1).time_windows(3)=struct('name','750'   ,'mins',1.7, 'maxs',3,'minms',1700, 'maxms',3000);
% project.postprocess.erp.design(1).time_windows(4)=struct('name','750'   ,'mins',0, 'maxs',3,'minms',0, 'maxms',3000);
%     
% project.postprocess.erp.design(2).time_windows(1)=struct('name','0-750' ,'mins',0, 'maxs',0.75,'minms',0, 'maxms',750);
% project.postprocess.erp.design(2).time_windows(2)=struct('name','750'   ,'mins',0.75, 'maxs',1.5,'minms',750, 'maxms',1500);
% project.postprocess.erp.design(2).time_windows(3)=struct('name','750'   ,'mins',1.7, 'maxs',3,'minms',1700, 'maxms',3000);
% project.postprocess.erp.design(2).time_windows(4)=struct('name','750'   ,'mins',0, 'maxs',3,'minms',0, 'maxms',3000);
% 
% project.postprocess.erp.design(3).time_windows(1)=struct('name','0-750' ,'mins',0, 'maxs',0.75,'minms',0, 'maxms',750);
% project.postprocess.erp.design(3).time_windows(2)=struct('name','750'   ,'mins',0.75, 'maxs',1.5,'minms',750, 'maxms',1500);
% project.postprocess.erp.design(3).time_windows(3)=struct('name','750'   ,'mins',1.7, 'maxs',3,'minms',1700, 'maxms',3000);
% project.postprocess.erp.design(3).time_windows(4)=struct('name','750'   ,'mins',0, 'maxs',3,'minms',0, 'maxms',3000);
% 
% project.postprocess.erp.design(4).time_windows(1)=struct('name','0-750' ,'mins',0, 'maxs',0.75,'minms',0, 'maxms',750);
% project.postprocess.erp.design(4).time_windows(2)=struct('name','750'   ,'mins',0.75, 'maxs',1.5,'minms',750, 'maxms',1500);
% project.postprocess.erp.design(4).time_windows(3)=struct('name','750'   ,'mins',1.7, 'maxs',3,'minms',1700, 'maxms',3000);
% project.postprocess.erp.design(4).time_windows(4)=struct('name','750'   ,'mins',0, 'maxs',3,'minms',0, 'maxms',3000);
% % frequency bands
% project.postprocess.ersp.frequency_bands(1)=struct('name','teta','min',4,'max',8);
% project.postprocess.ersp.frequency_bands(2)=struct('name','mu','min',8,'max',12);
% project.postprocess.ersp.frequency_bands(3)=struct('name','beta1','min',14, 'max',20);
% project.postprocess.ersp.frequency_bands(4)=struct('name','beta2','min',20, 'max',32);


project.postprocess.ersp.frequency_bands_list={}; ... writes something like {[4,8];[8,12];[14,20];[20,32]};
for fb=1:length(project.postprocess.ersp.frequency_bands)
    bands=[project.postprocess.ersp.frequency_bands(fb).min, project.postprocess.ersp.frequency_bands(fb).max];
    project.postprocess.ersp.frequency_bands_list=[project.postprocess.ersp.frequency_bands_list bands];
end
project.postprocess.ersp.frequency_bands_names={project.postprocess.ersp.frequency_bands.name}



project.postprocess.roi_list={{'F5','F7','AF7','FT7'}; ... left IFG
          {'F6','F8','AF8','FT8'}; ... right IFG
          {'FC3','FC5'}; ... l PMD
          {'FC4','FC6'}; ... r PMD    
          {'C3'}; ...       iM1 hand
          {'C4'}; ...       cM1 hand
          {'Cz'}; ...       SMA
          {'CP3','CP5','P3','P5'}; ... left IPL
          {'CP4','CP6','P4','P6'}; ... right IPL
          {'CP3','P3','CP1','P1'}; ... left SPL
          {'CP4','P4','CP2','P2'}; ... right SPL
          {'T7','TP7','CP5','P5'}; ... left pSTS
          {'T8','TP8','CP6','P6'}; ... right pSTS          
          {'O1','PO3','POz','Oz'}; ... left occipital          
          {'O2','PO4','POz','Oz'} ... right occipital 
};
project.postprocess.numroi=length(project.postprocess.roi_list);
project.postprocess.roi_names={'left-ifg','right-ifg','left-PMd','right-PMd','left-SM1','right-SM1','SMA','left-ipl','right-ipl','left-spl','right-spl','left-sts','right-sts','left-occipital','right-occipital'};


% ERP
project.postprocess.erp.tmin_analysis.s=project.epoching.epo_st.s;
project.postprocess.erp.tmax_analysis.s=project.epoching.epo_end.s;
project.postprocess.erp.ts_analysis.s=0.008;
project.postprocess.erp.timeout_analysis_interval.s=[project.postprocess.erp.tmin_analysis.s:project.postprocess.erp.ts_analysis.s:project.postprocess.erp.tmax_analysis.s];

% ERSP
project.postprocess.ersp.tmin_analysis.s=project.epoching.epo_st.s;
project.postprocess.ersp.tmax_analysis.s=project.epoching.epo_end.s;
project.postprocess.ersp.ts_analysis.s=0.008;
project.postprocess.ersp.timeout_analysis_interval.s=[project.postprocess.ersp.tmin_analysis.s:project.postprocess.ersp.ts_analysis.s:project.postprocess.ersp.tmax_analysis.s];

project.postprocess.ersp.fmin_analysis=4;
project.postprocess.ersp.fmax_analysis=32;
project.postprocess.ersp.fs_analysis=0.5;
project.postprocess.ersp.freqout_analysis_interval=[project.postprocess.ersp.fmin_analysis:project.postprocess.ersp.fs_analysis:project.postprocess.ersp.fmax_analysis];
project.postprocess.ersp.padratio=16;

% ======================================================================================================
% RESULTS DISPLAY
% ======================================================================================================
% insert parameters for ERP and TF analysis in the STUDY
% frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
project.results_display.filter_freq=10;
%y limits (uV)for the representation of ERP
project.results_display.ylim_plot=[-2.5 2.5];
      
project.results_display.erp.time_range.s=[project.postprocess.erp.tmin_analysis.s project.postprocess.erp.tmax_analysis.s];       % time range for erp representation
project.results_display.ersp.time_range.s=[project.postprocess.ersp.tmin_analysis.s project.postprocess.ersp.tmax_analysis.s];       % time range for erp representation

project.results_display.display_only_significant='off'; %on             % the threshold is always set, however you can choose to display only the significant p values or all the p values (in the curve plots the threshold is added as a landmark)
project.results_display.compact_plots='on';                             % display (curve) plots with different conditions/groups on the same plots
project.results_display.single_subjects='off';                          % display patterns of the single subjcts (keeping the average pattern)
project.results_display.compact_h0='on';                                % display parameters for compact plots
project.results_display.compact_v0='on';
project.results_display.compact_sem='off';
project.results_display.compact_stats='on';
project.results_display.compact_display_xlim=[];
project.results_display.compact_display_ylim=[];

project.results_display.freq_scale='linear';   %'log'|'linear'

% ======================================================================================================
% EXPORT
% ======================================================================================================
export.r.bands=[];
for nband=1:length(project.postprocess.ersp.frequency_bands_names)
    export.r.bands(nband).freq=project.postprocess.ersp.frequency_bands_list{nband};
    export.r.bands(nband).name=project.postprocess.ersp.frequency_bands_names{nband};
end

% ======================================================================================================
% CLUSTERING
% ======================================================================================================
project.clustering.channels_file_name='cluster_projection_channel_locations.loc';
project.clustering.channels_file_path=''; ... later set by define_paths

% ======================================================================================================
% BRAINSTORM
% ======================================================================================================
project.brainstorm.db_name='healthy_action_observation_sound';                  ... must correspond to brainstorm db name

project.brainstorm.sources.sources_norm='wmne';        % possible values are: wmne, dspm, sloreta
project.brainstorm.sources.source_orient='fixed';      % possible values are: fixed, loose
project.brainstorm.sources.loose_value=0.2;
project.brainstorm.sources.depth_weighting='nodepth';   % optional parameter, actually it is enabled for wmne and dspm and disabled for sloreta
project.brainstorm.sources.downsample_atlasname='s3000';

project.brainstorm.analysis_bands={{ ...
                    project.postprocess.ersp.frequency_bands(1).name, [num2str(project.postprocess.ersp.frequency_bands(1).min) ', ' num2str(project.postprocess.ersp.frequency_bands(1).max)], 'mean'; ...
                    project.postprocess.ersp.frequency_bands(2).name, [num2str(project.postprocess.ersp.frequency_bands(2).min) ', ' num2str(project.postprocess.ersp.frequency_bands(2).max)], 'mean'; ...
                    project.postprocess.ersp.frequency_bands(3).name, [num2str(project.postprocess.ersp.frequency_bands(3).min) ', ' num2str(project.postprocess.ersp.frequency_bands(3).max)], 'mean'; ...
                    project.postprocess.ersp.frequency_bands(4).name, [num2str(project.postprocess.ersp.frequency_bands(4).min) ', ' num2str(project.postprocess.ersp.frequency_bands(4).max)], 'mean' ...
                                  }};
                                  
project.brainstorm.analysis_times={{'t-4', '-0.4000, -0.3040', 'mean'; 't-3', '-0.3000, -0.2040', 'mean'; 't-2', '-0.2000, -0.1040', 'mean'; 't-1', '-0.1000, -0.0040', 'mean'; 't1', '0.0000, 0.0960', 'mean'; 't2', '0.1000, 0.1960', 'mean'; 't3', '0.2000, 0.2960', 'mean'; 't4', '0.3000, 0.3960', 'mean'; 't5', '0.4000, 0.4960', 'mean'; 't6', '0.5000, 0.5960', 'mean'; 't7', '0.6000, 0.6960', 'mean'; 't8', '0.7000, 0.7960', 'mean'; 't9', '0.8000, 0.8960', 'mean'; 't10', '0.9000, 0.9960', 'mean'}};

project.brainstorm.bem_file_name='headmodel_surf_openmeeg.mat';
project.brainstorm.use_same_montage=1;
project.brainstorm.default_anatomy='MNI_Colin27';
project.brainstorm.channels_file_name='brainstorm_channel.pos';
project.brainstorm.channels_file_path=''; ... later set by define_paths
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================



















% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% DERIVED TIMES from seconds to milliseconds
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================

% ======================================================================================================
% EPOCHING
% ======================================================================================================

%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.epoching.bc_st.ms=project.epoching.bc_st.s*1000;            % baseline correction start latency
project.epoching.bc_end.ms=project.epoching.bc_end.s*1000;           % baseline correction end latency
project.epoching.epo_st.ms=project.epoching.epo_st.s*1000;             % epochs start latency
project.epoching.epo_end.ms=project.epoching.epo_end.s*1000;             % epochs end latency
%  ********* /DERIVED DATA *****************************************************************


% ======================================================================================================
% POSTPROCESS
% ======================================================================================================

%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.postprocess.eeglab.frequency_bands_list={ ...
    [project.postprocess.ersp.frequency_bands(1).min,project.postprocess.ersp.frequency_bands(1).max]; ... 
    [project.postprocess.ersp.frequency_bands(2).min,project.postprocess.ersp.frequency_bands(2).max]; ...
    [project.postprocess.ersp.frequency_bands(3).min,project.postprocess.ersp.frequency_bands(3).max]; ...
    [project.postprocess.ersp.frequency_bands(4).min,project.postprocess.ersp.frequency_bands(4).max]; ...
    };
project.postprocess.eeglab.frequency_bands_names={project.postprocess.ersp.frequency_bands(1).name,project.postprocess.ersp.frequency_bands(2).name,project.postprocess.ersp.frequency_bands(3).name,project.postprocess.ersp.frequency_bands(4).name};
%  ********* /DERIVED DATA  *****************************************************************


% ERP
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.postprocess.erp.tmin_analysis.ms=project.postprocess.erp.tmin_analysis.s*1000;
project.postprocess.erp.tmax_analysis.ms=project.postprocess.erp.tmax_analysis.s*1000;
project.postprocess.erp.ts_analysis.ms=project.postprocess.erp.ts_analysis.s*1000;
project.postprocess.erp.timeout_analysis_interval.ms=project.postprocess.erp.timeout_analysis_interval.s*1000;
%  ********* /DERIVED DATA  *****************************************************************


% ERSP
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.postprocess.ersp.tmin_analysis.ms=project.postprocess.ersp.tmin_analysis.s*1000;
project.postprocess.ersp.tmax_analysis.ms=project.postprocess.ersp.tmax_analysis.s*1000;
project.postprocess.ersp.ts_analysis.ms=project.postprocess.ersp.ts_analysis.s*1000;
project.postprocess.ersp.timeout_analysis_interval.ms=project.postprocess.ersp.timeout_analysis_interval.s*1000;
%  ********* /DERIVED DATA  *****************************************************************


% ======================================================================================================
% RESULTS DISPLAY
% ======================================================================================================
% insert parameters for ERP and TF analysis in the STUDY

%frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
project.results_display.filter_freq=10;
%y limits (uV)for the representation of ERP
project.results_display.ylim_plot=[-2.5 2.5];
      
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.results_display.erp.time_range.ms=project.results_display.erp.time_range.s*1000;
project.results_display.ersp.time_range.ms=project.results_display.ersp.time_range.s*1000;
%  ********* /DERIVED DATA  *****************************************************************

% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================



