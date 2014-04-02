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
project.name='eeg_bar_dot';         ... must correspond to 'local_projects_data_path' subfolder name
project.analysis_name='raw_90hz';                          ... subfolder containing the current analysis type (refers to EEG device input data type)

project.do_source_analysis=0;
project.do_emg_analysis=0;
project.do_cluster_analysis=0;
project.do_emg_analysis=0;

% ======================================================================================================
% PATHS
% ======================================================================================================
project.paths.projects='';
project.paths.epochs='';
project.paths.scripts='';

% ======================================================================================================
% TASK
% ======================================================================================================
project.task.events.start_experiment_trigger_value = 'S  2';
project.task.events.end_experiment_trigger_value = 'S  4';
project.task.events.calibrate_start_trigger_value = 'S  6';                    % start: pause, feedback and rest period
project.task.events.calibrate_end_trigger_value = 'S  8';                   % end: pause, feedback and rest period
project.task.events.pause_start_trigger_value = 'S 10';                    % start: pause, feedback and rest period
project.task.events.pause_end_trigger_value = 'S 12';                   % end: pause, feedback and rest period


% ======================================================================================================
% EEGDATA
% ======================================================================================================

%Fp1 Fp2 F7  F3  Fz F4 F8 FC5 FC1 FC2 FC6 T7  C3  Cz   C4 T8 LEOG CP5 CP1 CP2 CP6 REOG P7  P3 Pz P4 P8 PO9 O1  Oz  O2 PO10
%F7  AF3 AF4 AF8 F5 F1 F2 F6  FT9 FT7 FC3 FC4 FT8 FT10 C5 C1 C2   C6  TP7 CP3 AFz CP4  TP8 P5 P1 P2 P6 PO7 PO3 FCz PO4 PO8 

project.eegdata.nch=64;         % channels_number
project.eegdata.nch_eeg=62;     % channels_number
project.eegdata.fs=250;         % sampling frequency in Hz
project.eegdata.eeglab_channels_file_name='standard-10-5-cap385.elp';       % channels file name
project.eegdata.eeglab_channels_file_path=''; ... later set by define_paths
    

project.eegdata.eeg_channels_list=[1:16 18:21 23:project.eegdata.nch];
project.eegdata.emg_channels_list=[];
project.eegdata.emg_channels_list_labels={};
project.eegdata.eog_channels_list=[17 22];
project.eegdata.no_eeg_channels_list=[project.eegdata.emg_channels_list project.eegdata.eog_channels_list];

% ======================================================================================================
% IMPORT
% ======================================================================================================
project.import.acquisition_system='BRAINAMP';
% input
% typical file name is: [project.import.original_data_prefix subj_name project.import.original_data_suffix project.import.output_suffix]
project.import.original_data_extension='vhdr';
project.import.original_data_folder='raw';
project.import.original_data_suffix=''; ... often empty
project.import.original_data_prefix=''; ... often empty
%output
project.import.output_suffix='_raw'; 
project.import.emg_output_postfix= '';

project.import.electrodes2discard={};
project.import.reference_channels={'all'};

project.import.polygraphic2transform={};

project.import.valid_marker='stimuli'; .... other options are:  'responses' | 'all' | {'11' '12' '13' '14' '15' '16' '21'};

% ======================================================================================================
% PREPROCESSING
% ======================================================================================================
% GLOBAL FILTER
project.preproc.ff1_global=0.16;        % lower frequency in Hz
project.preproc.ff2_global=100;         % higher frequency

%FURTHER EEG FILTER
project.preproc.ff1_eeg=0.16;           % lower frequency
project.preproc.ff2_eeg=90;             % higher frequency

%FURTHER EOG FILTER
project.preproc.ff1_eog=0.16;           % lower frequency
project.preproc.ff2_eog=8;              % higher frequency
project.preproc.ch_eog1=project.eegdata.nch_eeg+1;       % first EOG-related channel
project.preproc.ch_eog2=project.eegdata.nch_eeg+2;       % second EOG-related channel

%FURTHER EMG FILTER
project.preproc.ff1_emg=5;              % lower frequency
project.preproc.ff2_emg=100;            % higher frequency

% NOTCH
project.preproc.do_notch=0;

% ======================================================================================================
% EPOCHING
% ======================================================================================================
% EEG
project.epoching.input_suffix=[project.import.output_suffix '_mc']; 

project.epoching.epo_st.s=-1;             % epochs start latency
project.epoching.epo_end.s=1.5;             % epochs end latency
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
project.epoching.mrkcode_cond={};
project.epoching.valid_marker={'S 20' 'S 22' 'S 24' 'S 26'};     % conditions: marker codes & name

project.epoching.condition_names={'bar_right' 'bar_left' 'dot_right' 'dot_left'};
project.epoching.numcond=length(project.epoching.condition_names);

% ======================================================================================================
% GROUPS
% ======================================================================================================
project.subjects.group_names={'AC', 'CC'};
project.subjects.groups={{'AC_01_alice', 'AC_02_chiara','AC_03_vale', 'AC_04_dan', 'AC_05_miki', 'AC_06_alby_sw', 'AC_07_diego', 'AC_10_cristina_sw','AC_11_claudio','AC_12_fabio','AC_13_emmanuel','AC_14_andrea', 'AC_15_alessandra'}; ...
            {'BB', 'BB2'} ...
            };
% non c'è completa coerenza con il valore gruppo definito a livello di singolo soggetto, e le liste presenti in groups
project.subjects.data(1)=struct('name',  '01_RV',    'group', 'AC', 'age', 30, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(2)=struct('name',  '02_CN',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(3)=struct('name',  '03_MA',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(4)=struct('name',  '04_ML',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(5)=struct('name',  '05_MU',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(6)=struct('name',  '06_MC',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(7)=struct('name',  '07_ER',    'group', 'AC', 'age', 30, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(8)=struct('name',  '08_EC',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(9)=struct('name',  '09_AP',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(10)=struct('name',  '10_EA',   'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(11)=struct('name',  '11_GP',   'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(12)=struct('name',  '12_MA',   'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(13)=struct('name',  '13_LG',   'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(14)=struct('name',  '14_ER',   'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);



% when bad_ch are more than 1, values must be added here to patch a annoying matlab behavior
project.subjects.data(1).bad_ch={'CP6', 'TP7'};
...project.subjects.data(6).bad_ch={'FP1', 'FP2','AF7','AF3','AF4','AF8'};
project.subjects.data(7).bad_ch={'Oz'};
project.subjects.data(8).bad_ch={'Oz'};
project.subjects.data(9).bad_ch={'Pz','Oz','O1','O2','PO10','P2','P04','PO8'};
project.subjects.data(10).bad_ch={'P4','P8','Oz','O2','PO4'};
project.subjects.data(11).bad_ch={'Oz','O1','PO3'};
project.subjects.data(13).bad_ch={'PO3'};


% project.subjects.list(5).data=struct('name',  'AC_05_miki',      'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(6).data=struct('name',  'AC_06_alby',      'group', 'AC', 'age', 41, 'gender', 'm', 'handedness', 'l', 'bad_ch', []);
% project.subjects.list(7).data=struct('name',  'AC_07_diego',     'group', 'AC', 'age', 32, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(8).data=struct('name',  'AC_08_miki',      'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(9).data=struct('name',  'AC_09_mikiv',     'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(10).data=struct('name', 'AC_10_cristina',  'group', 'AC', 'age', 37, 'gender', 'f', 'handedness', 'l', 'bad_ch', []);
% project.subjects.list(11).data=struct('name', 'AC_11_claudio',   'group', 'AC', 'age', 30, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(12).data=struct('name', 'AC_12_fabio',     'group', 'AC', 'age', 32, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(13).data=struct('name', 'AC_13_emmanuel',  'group', 'AC', 'age', 32, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(14).data=struct('name', 'AC_14_andrea',    'group', 'AC', 'age', 32, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(15).data=struct('name', 'AC_15_alessandra','group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(16).data=struct('name', 'CC_01_diego',     'group', 'CC', 'age', 10, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(17).data=struct('name', 'CC_02_miki',      'group', 'CC', 'age', 9,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(18).data=struct('name', 'CC_03_mikiv',     'group', 'CC', 'age', 8,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(19).data=struct('name', 'CC_04_cristina',  'group', 'CC', 'age', 6,  'gender', 'f', 'handedness', 'l', 'bad_ch', []);
% project.subjects.list(20).data=struct('name', 'CC_05_claudio',   'group', 'CC', 'age', 10, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(21).data=struct('name', 'CC_06_fabio',     'group', 'CC', 'age', 9,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(22).data=struct('name', 'CC_07_emmanuel',  'group', 'CC', 'age', 8,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(23).data=struct('name', 'CC_08_andrea',    'group', 'CC', 'age', 11, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.list(24).data=struct('name', 'CC_09_alessandra','group', 'CC', 'age', 12, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);

project.subjects.list={project.subjects.data.name};
project.subjects.numsubj=length(project.subjects.list);

% ======================================================================================================
% DESIGN
% ======================================================================================================
project.design(1).list=struct('name', 'stimulus'        , 'factor1_name', 'stimulus', 'factor1_levels', {'ao','control'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(2).list=struct('name', 'side'            , 'factor1_name', 'side', 'factor1_levels', {'aocs','control'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(3).list=struct('name', 'stimulus_x_side' , 'factor1_name', 'stimulus', 'factor1_levels', {'bar','dot'} , 'factor1_pairing', 'on', 'factor2_name', 'side', 'factor2_levels', {'right','left'}, 'factor2_pairing', 'on');

% structures that associates conditions' file with (multiple) factor(s)
project.design(1).factor_list=struct('file_match',{'bar'}   ,'factor','stimulus','level','bar');
project.design(2).factor_list=struct('file_match',{'dot'}   ,'factor','stimulus','level','dot');
project.design(3).factor_list=struct('file_match',{'right'} ,'factor','side','level','right');
project.design(4).factor_list=struct('file_match',{'left'}  ,'factor','side','level','left');
        
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
project.postprocess.erp.design(1).time_windows(1)=struct('name','0-750','min',0, 'max',750);
project.postprocess.erp.design(1).time_windows(2)=struct('name','750','min',750, 'max',1500);
project.postprocess.erp.design(1).time_windows(3)=struct('name','750','min',1700, 'max',3000);
project.postprocess.erp.design(1).time_windows(4)=struct('name','750','min',0, 'max',3000);
    
project.postprocess.erp.design(2).time_windows(1)=struct('name','0-750','min',0, 'max',750);
project.postprocess.erp.design(2).time_windows(2)=struct('name','750','min',750, 'max',1500);
project.postprocess.erp.design(2).time_windows(3)=struct('name','750','min',1700, 'max',3000);
project.postprocess.erp.design(2).time_windows(4)=struct('name','750','min',0, 'max',3000);

project.postprocess.erp.design(3).time_windows(1)=struct('name','0-750','min',0, 'max',750);
project.postprocess.erp.design(3).time_windows(2)=struct('name','750','min',750, 'max',1500);
project.postprocess.erp.design(3).time_windows(3)=struct('name','750','min',1700, 'max',3000);
project.postprocess.erp.design(3).time_windows(4)=struct('name','750','min',0, 'max',3000);

project.postprocess.erp.design(4).time_windows(1)=struct('name','0-750','min',0, 'max',750);
project.postprocess.erp.design(4).time_windows(2)=struct('name','750','min',750, 'max',1500);
project.postprocess.erp.design(4).time_windows(3)=struct('name','750','min',1700, 'max',3000);
project.postprocess.erp.design(4).time_windows(4)=struct('name','750','min',0, 'max',3000);


project.postprocess.ersp.frequency_bands(1)=struct('name','teta','min',4,'max',8);
project.postprocess.ersp.frequency_bands(2)=struct('name','mu','min',8,'max',12);
project.postprocess.ersp.frequency_bands(3)=struct('name','beta1','min',14, 'max',20);
project.postprocess.ersp.frequency_bands(4)=struct('name','beta2','min',20, 'max',32);


project.postprocess.ersp.frequency_bands_list={}; ... writes something like {[4,8];[8,12];[14,20];[20,32]};
for fb=1:length(project.postprocess.ersp.frequency_bands)
    bands=[project.postprocess.ersp.frequency_bands(fb).min, project.postprocess.ersp.frequency_bands(fb).max];
    project.postprocess.ersp.frequency_bands_list=[project.postprocess.ersp.frequency_bands_list bands];
end
project.postprocess.ersp.frequency_bands_names={project.postprocess.ersp.frequency_bands.name}; ... corresponds to {'a','b','c','d'};



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



