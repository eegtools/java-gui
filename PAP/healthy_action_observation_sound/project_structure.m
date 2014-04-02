%% project
%           A: start
%           B: paths
%           C: task
%           D: import    
%           E: eegdata
%           F: preproc
%           G: epoching
%           H: subjects
%           I: design
%           L: stats
%           M: postprocess
%           N: results_display
%           O: export
%           P: clustering
%           Q: brainstorm

% times are always defined in seconds and derived in ms 

%% ======================================================================================================
% A:    START
% ======================================================================================================
project.name=project_folder;                        % A1: must correspond to 'local_projects_data_path' subfolder name
project.analysis_name='raw_bc2';                    % A2: subfolder containing the current analysis type (refers to epochs ouptput folder)

project.do_source_analysis=0;                       % A3:  
project.do_emg_analysis=1;                          % A4:
project.do_cluster_analysis=0;                      % A5:

%% ======================================================================================================
% B:    PATHS (set by: define_paths_structure.m) 
% ======================================================================================================
project.paths.project='';                           % B1:   folder containing data, epochs, results etc...(not scripts)
project.paths.scripts='';                           % B2:   folder containing matlab scripts under EEG_Tools SVN repository
project.paths.original_data='';                     % B3:   folder containing EEG raw data (BDF, vhdr, eeg, etc...)
project.paths.epochs='';                            % B4:   folder containing EEGLAB EEG epochs set files 
project.paths.results='';                           % B5:   folder containing statistical results
project.paths.emg_epochs='';                        % B6:   folder containing EEGLAB EMG epochs set files 
project.paths.emg_epochs_mat='';                    % B7:   folder containing EMG data strucuture
project.paths.tf='';                                % B8:   folder containing 
project.paths.cluster_projection_erp='';            % B9:   folder containing 
project.paths.batches='';                           % B10:  folder containing bash batches (usually for SPM analysis)
project.paths.spmsources='';                        % B11:  folder containing sources images exported by brainstorm
project.paths.spmstats='';                          % B12:  folder containing spm stat files
%% ======================================================================================================
% C:    TASK
% ======================================================================================================
project.task.events.start_experiment_trigger_value = 1;         % C1:   signal experiment start
project.task.events.pause_trigger_value = 2;                    % C2:   start: pause, feedback and rest period
project.task.events.resume_trigger_value = 3;                   % C3:   end: pause, feedback and rest period
project.task.events.end_experiment_trigger_value = 4;           % C4:   signal experiment end
project.task.events.videoend_trigger_value = 5;
project.task.events.question_trigger_value = 6;
project.task.events.AOCS_audio_trigger_value = 7;
project.task.events.AOIS_audio_trigger_value = 8;
project.task.events.cross_trigger_value = 9;

%% ======================================================================================================
% D:    EEGDATA
% ======================================================================================================
project.eegdata.nch=64;                                                 % D1:   final channels_number after electrode removal and polygraphic transformation
project.eegdata.nch_eeg=64;                                             % D2:   EEG channels_number
project.eegdata.fs=256;                                                 % D3:   final sampling frequency in Hz, if original is higher, then downsample it
project.eegdata.eeglab_channels_file_name='standard-10-5-cap385.elp';   % D4:   universal channels file name containing the position of 385 channels
project.eegdata.eeglab_channels_file_path='';                           % D5:   later set by define_paths
    
project.eegdata.eeg_channels_list=[1:project.eegdata.nch_eeg];          % D6:   list of EEG channels
project.eegdata.emg_channels_list=[66 67 68];                           % D7:   list of EMG channels IDs after polygraphic transformation
project.eegdata.emg_channels_list_labels={'DFDR' 'NDFDR' 'DTA'};        % D8:   list of EMG channels labels after polygraphic transformation
project.eegdata.eog_channels_list=[65];                                 % D9:   list of EOG channels
                                                                        % D10:  list of NO-EEG channels IDs
project.eegdata.no_eeg_channels_list=[project.eegdata.emg_channels_list project.eegdata.eog_channels_list]; 

%% ======================================================================================================
% E:    IMPORT
% ======================================================================================================
project.import.acquisition_system='BIOSEMI';                            % E1:   EEG hardware type: BIOSEMI | BRAINAMP
% input file name = [original_data_prefix subj_name original_data_suffix . original_data_extension]
project.import.original_data_extension='bdf';                           % E2:   original data file extension
project.import.original_data_folder='raw';                              % E3:   original data file subfolder
project.import.original_data_suffix='';                                 % E4:   string after subject name in original EEG file nale....often empty
project.import.original_data_prefix='';                                 % E5:   string before subject name in original EEG file nale....often empty

%output
project.import.output_suffix='_raw';                                    % E5:   string appended to input file name after importing original file
project.import.emg_output_postfix= '_observation_emg';                  % E6:   string appended to input file name to EMG file

project.import.electrodes2discard=[];                                   % E7:   list of electrodes to discard : {'HEOG','RM','VEOG'};
project.import.reference_channels=[];                                   % E8:   list of electrodes to be used as reference

% E9:   rules to transform polygraphic ch in EMG ch. it takes 2 channels, substract their values and replaces them with one channel difference.
%       each cell define the two channels to subtract and the label of the new channel
project.import.polygraphic2transform={{65,66,'DVEOG'};{67,68,'DFDR'};{69,70,'NDFDR'};{71,72,'DTA'}};    

% E10:  list of trigger marker to import. can be a cel array, or a string with these values: 'all', 'stimuli','responses'
project.import.valid_marker={'11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46' '1' '2' '3' '4' '5' '6' '7' '8' '9' '50' '60' '70' '80'};  
%% ======================================================================================================
% F:    PREPROCESSING
% ======================================================================================================
% during import
% GLOBAL FILTER
project.preproc.ff1_global=0.16;                                        % F1:   lower frequency in Hz of the preliminar filtering applied during data import
project.preproc.ff2_global=100;                                         % F2:   higher frequency in Hz of the preliminar filtering applied during data import

% NOTCH
project.preproc.do_notch=1;                                             % F3:   define if apply the notch filter at 50 Hz

% during pre-processing
%FURTHER EEG FILTER
project.preproc.ff1_eeg=0.16;                                           % F4:   lower frequency in Hz of the EEG filtering applied during preprocessing
project.preproc.ff2_eeg=45;                                             % F5:   higher frequency in Hz of the EEG filtering applied during preprocessing

%FURTHER EOG FILTER
project.preproc.ff1_eog=0.16;                                           % F6:   lower frequency in Hz of the EOG filtering applied during preprocessing
project.preproc.ff2_eog=8;                                              % F7:   higher frequency in Hz of the EEG filtering applied during preprocessing

%FURTHER EMG FILTER
project.preproc.ff1_emg=5;                                              % F8:   lower frequency in Hz of the EMG filtering applied during preprocessing
project.preproc.ff2_emg=100;                                            % F9:   higher frequency in Hz of the EMG filtering applied during preprocessing

%% ======================================================================================================
% G:    EPOCHING
% ======================================================================================================
% EEG
project.epoching.input_suffix=[project.import.output_suffix '_mc'];     % G1:   final file name before epoching : default is '_raw_mc'

project.epoching.epo_st.s=-1;                                           % G2:   EEG epochs start latency
project.epoching.epo_end.s=3;                                           % G3:   EEG epochs end latency
project.epoching.bc_st.s=-0.9;                                          % G4:   EEG baseline correction start latency
project.epoching.bc_end.s=-0.512;                                       % G5:   EEG baseline correction end latency

% point
project.epoching.bc_st_point=round((project.epoching.bc_st.s-project.epoching.epo_st.s)*project.eegdata.fs)+1;   % G6:   EEG baseline correction start point
project.epoching.bc_end_point=round((project.epoching.bc_end.s-project.epoching.epo_st.s)*project.eegdata.fs)+1;     % G7:   EEG baseline correction end point

% EMG
project.epoching.emg_epo_st.s=-1;                                       % G8:   EMG epochs start latency
project.epoching.emg_epo_end.s=3;                                       % G9:   EMG epochs end latency
project.epoching.emg_bc_st.s=-0.9;                                      % G10:  EMG baseline correction start latency
project.epoching.emg_bc_end.s=-0.512;                                   % G11:  EMG baseline correction end latency

% point
project.epoching.emg_bc_st_point=round((project.epoching.emg_bc_st.sproject.epoching.emg_epo_st.s)*project.eegdata.fs)+1; % G12:   EMG baseline correction start point
project.epoching.emg_bc_end_point=round((project.epoching.emg_bc_st.s-project.epoching.emg_epo_st.s)*project.eegdata.fs)+1; % G13:   EMG baseline correction end point

% markers
project.epoching.mrkcode_cond={ {'11' '12' '13' '14' '15' '16'};...     % G14:  triggers defining conditions...even if only one trigger is used for each condition, a cell matrix is used
                                {'21' '22' '23' '24' '25' '26'};...     %       
                                {'31' '32' '33' '34' '35' '36'};...
                                {'41' '42' '43' '44' '45' '46'};...  
                              };
project.epoching.numcond = length(project.epoching.mrkcode_cond);       % G15: conditions' number 
project.epoching.valid_marker=[project.epoching.mrkcode_cond{1:length(project.epoching.mrkcode_cond)}];

project.epoching.condition_names={'control' 'AO' 'AOCS' 'AOIS'};        % G 16: conditions' labels
if length(project.epoching.condition_names) ~= project.epoching.numcond
    disp('ERROR in project_structure: number of conditions do not coincide !!! please verify')
end
%% ======================================================================================================
% H:    SUBJECTS
% ======================================================================================================
% non c'e' completa coerenza con il valore gruppo definito a livello di singolo soggetto, e le liste presenti in groups
project.subjects.data(1)=struct('name',  'AC_01_alice',     'group', 'AC', 'age', 30, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(2)=struct('name',  'AC_02_chiara',    'group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(3)=struct('name',  'AC_03_vale',      'group', 'AC', 'age', 30, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(4)=struct('name',  'AC_04_dan',       'group', 'AC', 'age', 26, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(5)=struct('name',  'AC_05_miki',      'group', 'AC', 'age', 30, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(6)=struct('name',  'AC_06_alby',      'group', 'AC', 'age', 41, 'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(7)=struct('name',  'AC_07_diego',     'group', 'AC', 'age', 28, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(8)=struct('name',  'AC_08_marco',     'group', 'AC', 'age', 33, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(9)=struct('name',  'AC_09_michiv',    'group', 'AC', 'age', 33, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(10)=struct('name', 'AC_10_cristina',  'group', 'AC', 'age', 36, 'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(11)=struct('name', 'AC_11_claudio',   'group', 'AC', 'age', 33, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(12)=struct('name', 'AC_12_fabio',     'group', 'AC', 'age', 43, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(13)=struct('name', 'AC_13_emmanuel',  'group', 'AC', 'age', 27, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(14)=struct('name', 'AC_14_andrea',    'group', 'AC', 'age', 32, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(15)=struct('name', 'AC_15_alessandra','group', 'AC', 'age', 32, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(16)=struct('name', 'AC_16_giulia',    'group', 'AC', 'age', 29, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(17)=struct('name', 'AC_17_roberta',   'group', 'AC', 'age', 25, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);

...project.subjects.data(17).bad_ch={'C3', 'C4'};
    

% project.subjects.data(16)=struct('name', 'CC_01_diego',     'group', 'CC', 'age', 10, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(17)=struct('name', 'CC_02_miki',      'group', 'CC', 'age', 9,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(18)=struct('name', 'CC_03_mikiv',     'group', 'CC', 'age', 8,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(19)=struct('name', 'CC_04_cristina',  'group', 'CC', 'age', 6,  'gender', 'f', 'handedness', 'l', 'bad_ch', []);
% project.subjects.data(20)=struct('name', 'CC_05_claudio',   'group', 'CC', 'age', 10, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(21)=struct('name', 'CC_06_fabio',     'group', 'CC', 'age', 9,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(22)=struct('name', 'CC_07_emmanuel',  'group', 'CC', 'age', 8,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(23)=struct('name', 'CC_08_andrea',    'group', 'CC', 'age', 11, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(24)=struct('name', 'CC_09_alessandra','group', 'CC', 'age', 12, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);

project.subjects.list={project.subjects.data.name};
project.subjects.numsubj=length(project.subjects.list);

project.subjects.group_names={unique({project.subjects.data.group}), 'AC', 'CC'};
project.subjects.groups={{'AC_01_alice', 'AC_02_chiara','AC_03_vale', 'AC_04_dan', 'AC_05_miki', 'AC_06_alby_sw', 'AC_07_diego', 'AC_10_cristina_sw','AC_11_claudio','AC_12_fabio','AC_13_emmanuel','AC_14_andrea', 'AC_15_alessandra'}; ...
                         {'BB', 'BB2'} ...
                        };

%% ======================================================================================================
% I:    DESIGN
% ======================================================================================================
% structures that associates conditions' file with (multiple) factor(s)
project.design(1).factor_list=struct('file_match',{'control'}   ,'factor','condition','level','control');
project.design(2).factor_list=struct('file_match',{'AO'}        ,'factor','condition','level','ao');
project.design(3).factor_list=struct('file_match',{'AOCS'}      ,'factor','condition','level','aocs');
project.design(4).factor_list=struct('file_match',{'AOIS'}      ,'factor','condition','level','aois');


project.design(1).list=struct('name', 'ao_control'  , 'factor1_name', 'condition', 'factor1_levels', {'ao','control'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(2).list=struct('name', 'aocs_control', 'factor1_name', 'condition', 'factor1_levels', {'aocs','control'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(3).list=struct('name', 'aocs_ao'     , 'factor1_name', 'condition', 'factor1_levels', {'aocs','ao'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(4).list=struct('name', 'aocs_aois'   , 'factor1_name', 'condition', 'factor1_levels', {'aocs','aois'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(5).list=struct('name', 'aois_ao'     , 'factor1_name', 'condition', 'factor1_levels', {'aois','ao'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');
project.design(6).list=struct('name', 'sound_effect', 'factor1_name', 'sound'    , 'factor1_levels', {'aocs','aois','ao'} , 'factor1_pairing', 'on', 'factor2_name', '', 'factor2_levels', '', 'factor2_pairing', 'on');

        
%% ======================================================================================================
% L:    STATS
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

%% ======================================================================================================
% M:    POSTPROCESS
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

%% ======================================================================================================
% N:    RESULTS DISPLAY
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

%% ======================================================================================================
% O:    EXPORT
% ======================================================================================================
export.r.bands=[];
for nband=1:length(project.postprocess.ersp.frequency_bands_names)
    export.r.bands(nband).freq=project.postprocess.ersp.frequency_bands_list{nband};
    export.r.bands(nband).name=project.postprocess.ersp.frequency_bands_names{nband};
end

%% ======================================================================================================
% P:    CLUSTERING
% ======================================================================================================
project.clustering.channels_file_name='cluster_projection_channel_locations.loc';
project.clustering.channels_file_path=''; ... later set by define_paths

%% ======================================================================================================
% Q:    BRAINSTORM
% ======================================================================================================
project.brainstorm.db_name='healthy_action_observation_sound';                  ... must correspond to brainstorm db name

project.brainstorm.paths.db='';
project.brainstorm.paths.data='';
project.brainstorm.paths.channels_file='';

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



