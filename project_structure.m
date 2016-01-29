%% project
%           A: start
%           B: paths

%           SUBJECT PROCESSING
%           C: task
%           D: eegdata
%           E: import    
%           F: preproc
%           G: epoching

%           H: subjects

%           GROUP PROCESSING
%           I: study
%           L: design
%           M: stats
%           N: postprocess
%           O: results_display
%           P: export
%           Q: clustering
%           R: brainstorm

% times are always defined in seconds and derived in ms  

%% ======================================================================================================
% A:    START
% ======================================================================================================
...project.research_group                           % A1: set in main: e.g.  PAP or MNI
...project.research_subgroup                        % A2: set in main: e.g.  PAP or MNI
project.name = '';                                     % A3: set in main : must correspond to 'project.paths.local_projects_data' subfolder name

project.study_suffix='';                            % A4: sub name used to create a different STUDY name (fianl file will be called: [project.name project.study_suffix '.study'])
project.analysis_name='OCICA_250_raw';            % A5: epoching output folder name, subfolder containing the condition files of the current analysis type

project.do_source_analysis=0;                       % A6:  
project.do_emg_analysis=0;                          % A7:
project.do_cluster_analysis=0;                      % A8:

%% ======================================================================================================
% B:    PATHS
% ======================================================================================================
% set by: main file
...project.paths.projects_data_root                 % B1:   folder containing local RBCS projects root-folder,  set in main
...project.paths.svn_scripts_root                   % B2:   folder containing local RBCS script root-folder,  set in main
...project.paths.plugins_root                       % B3:   folder containing local MATLAB PLUGING root-folder, set in main

% set by define_paths_structure
...project.paths.global_scripts                     % B4:
...project.paths.global_spm_templates               % B5:

% set by: define_paths_structure
project.paths.project='';                           % B6:   folder containing data, epochs, results etc...(not scripts)
project.paths.scripts='';                           % B7:   folder containing matlab scripts under EEG_Tools SVN repository
project.paths.original_data='';                     % B8:   folder containing EEG raw data (BDF, vhdr, eeg, etc...)
project.paths.input_epochs='';                      % B9:   folder containing EEGLAB EEG input epochs set files 
project.paths.output_epochs='';                     % B10:  folder containing EEGLAB EEG output condition epochs set files
project.paths.results='';                           % B11:  folder containing statistical results
project.paths.emg_epochs='';                        % B12:  folder containing EEGLAB EMG epochs set files 
project.paths.emg_epochs_mat='';                    % B13:  folder containing EMG data strucuture
project.paths.tf='';                                % B14:  folder containing 
project.paths.cluster_projection_erp='';            % B15:  folder containing 
project.paths.batches='';                           % B16:  folder containing bash batches (usually for SPM analysis)
project.paths.spmsources='';                        % B17:  folder containing sources images exported by brainstorm
project.paths.spmstats='';                          % B18:  folder containing spm stat files
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
% D:    IMPORT
% ======================================================================================================
% input file name  = [import.original_data_prefix subj_name import.original_data_suffix . original_data_extension]
% output file name = [import.original_data_prefix subj_name import.original_data_suffix project.import.output_suffix . set]

project.import.acquisition_system='BRAINVISION';                        % E1:   EEG hardware type: BIOSEMI | BRAINAMP
project.import.original_data_extension='vhdr';                          % E2:   original data file extension
project.import.original_data_folder='raw';                              % E3:   original data file subfolder
project.import.original_data_suffix='_OCICA_250';                       % E4:   string after subject name in original EEG file name....often empty
project.import.original_data_prefix='';                                 % E5:   string before subject name in original EEG file name....often empty

%output
project.import.output_folder='';                           % D6:   string appended to fullfile(project.paths.project,'epochs', ...=) , determining where to write imported file
project.import.output_suffix='';                                        % E5:   string appended to input file name after importing original file
project.import.emg_output_postfix='';                  				% E6:   string appended to input file name to EMG file

project.import.reference_channels='';                                   % E8:   list of electrodes to be used as reference

% E9:   rules to transform polygraphic ch in EMG ch. it takes 2 channels, substract their values and replaces them with one channel difference.
%       each cell define the two channels to subtract and the label of the new channel
project.import.ch2transform=[];    

% E10:  list of trigger marker to import. can be a cel array, or a string with these values: 'all', 'stimuli','responses'
project.import.valid_marker={'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 18' 'S 19' 'S 20' 'S201' 'S205' 'S240' 'S245' 'S206' 'S230' 'S235' 'S236', 'S246','S193' 'S194' 'S230' 'S235' 'S236' 'S240' 'S245' 'S246' 'S185' 'S186' 'S205' 'S235' 'S245' 'S206' 'S236' 'S246'};  

%% ======================================================================================================
% E:    EEGDATA
% ======================================================================================================
project.eegdata.nch=65;                                                 % D1:   final channels_number after electrode removal and polygraphic transformation
project.eegdata.nch_eeg=65;                                             % D2:   EEG channels_number
project.eegdata.fs=250;                                                 % D3:   final sampling frequency in Hz, if original is higher, then downsample it
project.eegdata.eeglab_channels_file_name='standard-10-5-cap385.elp';   % D4:   universal channels file name containing the position of 385 channels
project.eegdata.eeglab_channels_file_path='';                           % D5:   later set by define_paths
    
project.eegdata.eeg_channels_list           = [1:project.eegdata.nch_eeg];  % E6:   list of EEG channels IDs

project.eegdata.emg_channels_list           = [];
project.eegdata.emg_channels_list_labels    = {''};
project.eegdata.eog_channels_list           = [];
project.eegdata.eog_channels_list_labels    = {''};

for ch_id=1:length(project.import.ch2transform)
    ch = project.import.ch2transform(ch_id);
    if ~isempty(ch.new_label)
        if strcmp(ch.type, 'emg')
            project.eegdata.emg_channels_list           = [project.eegdata.emg_channels_list (project.eegdata.nch_eeg+ch_id)];
            project.eegdata.emg_channels_list_labels    = [project.eegdata.emg_channels_list_labels ch.new_label];
        elseif strcmp(ch.type, 'eog')
            project.eegdata.eog_channels_list           = [project.eegdata.eog_channels_list (project.eegdata.nch_eeg+ch_id)];
            project.eegdata.eog_channels_list_labels    = [project.eegdata.eog_channels_list_labels ch.new_label];
        end
    end
end

project.eegdata.no_eeg_channels_list = [project.eegdata.emg_channels_list project.eegdata.eog_channels_list];  % D10:  list of NO-EEG channels IDs

%% ======================================================================================================
% F:    PREPROCESSING
% ======================================================================================================
% input file name  = [import.original_data_prefix subj_name import.original_data_suffix project.import.output_suffix . set]
% output file name = [import.original_data_prefix subj_name import.original_data_suffix project.import.output_suffix . set]

project.preproc.output_folder = project.import.output_folder;
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
% input file name  = [import.original_data_prefix subj_name import.original_data_suffix import.output_suffix epoching.input_suffix . set]
% output file name = [import.original_data_prefix subj_name import.original_data_suffix import.output_suffix epoching.input_suffix '_' CONDXX. set]

% EEG
project.epoching.input_folder = project.preproc.output_folder;
project.epoching.input_suffix = '';                                       % G1:   final file name before epoching : default is '_raw_mc'
project.epoching.input_epochs_folder = project.analysis_name;             % G2:   input epoch folder, output folder of the import process
project.epoching.bc_type='global';                                      % G3:   type of baseline correction: global: considering all the trials, 'condition': by condition, 'trial': trial-by-trial

project.epoching.epo_st.s=-0.4;                                         % G4:   EEG epochs start latency
project.epoching.epo_end.s=1;                                           % G5:   EEG epochs end latency
project.epoching.bc_st.s=-0.4;                                          % G6:   EEG baseline correction start latency
project.epoching.bc_end.s=-0.04;                                        % G7:   EEG baseline correction end latency

% point
project.epoching.bc_st_point=round((project.epoching.bc_st.s-project.epoching.epo_st.s)*project.eegdata.fs)+1;   	% G8:   EEG baseline correction start point
project.epoching.bc_end_point=round((project.epoching.bc_end.s-project.epoching.epo_st.s)*project.eegdata.fs)+1; 	% G9:   EEG baseline correction end point

% EMG
project.epoching.emg_epo_st.s=0;                                        % G10: EMG epochs start latency
project.epoching.emg_epo_end.s=0;                                       % G11:  EMG epochs end latency
project.epoching.emg_bc_st.s=0;                                         % G12:  EMG baseline correction start latency
project.epoching.emg_bc_end.s=0;                                        % G13:  EMG baseline correction end latency

% point
project.epoching.emg_bc_st_point=round((project.epoching.emg_bc_st.s-project.epoching.emg_epo_st.s)*project.eegdata.fs)+1; 		% G14:   EMG baseline correction start point
project.epoching.emg_bc_end_point=round((project.epoching.emg_bc_end.s-project.epoching.emg_epo_st.s)*project.eegdata.fs)+1; 	% G15:   EMG baseline correction end point

% markers
project.epoching.mrkcode_cond={ {'S  1'};...     % G16:  triggers defining conditions...even if only one trigger is used for each condition, a cell matrix is used
                                {'S  2'};...     %       
                                {'S  3'};...
                                {'S  4'};...  
                              };
project.epoching.numcond = length(project.epoching.mrkcode_cond);       % G17: conditions' number 
project.epoching.valid_marker=[project.epoching.mrkcode_cond{1:length(project.epoching.mrkcode_cond)}];

project.epoching.condition_names={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};        % G 18: conditions' labels
if length(project.epoching.condition_names) ~= project.epoching.numcond
    disp('ERROR in project_structure: number of conditions do not coincide !!! please verify')
end

%% ======================================================================================================
% H:    SUBJECTS
% ======================================================================================================
% non c'e' completa coerenza con il valore gruppo definito a livello di singolo soggetto, e le liste presenti in groups

project.subjects.data(1)  = struct('name', 'alessandra_finisguerra',    'group', 'AC', 'age', 0, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(2)  = struct('name', 'alessia',    				'group', 'AC', 'age', 0, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(3)  = struct('name', 'amedeo_schipani',     		'group', 'AC', 'age', 0, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(4)  = struct('name', 'antonio2',  				'group', 'AC', 'age', 0, 'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(5)  = struct('name', 'augusta2',  				'group', 'AC', 'age', 0, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(6)  = struct('name', 'claudio2', 					'group', 'AC', 'age', 0, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(7)  = struct('name', 'denis_giambarrasi',   		'group', 'AC', 'age', 0, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(8)  = struct('name', 'eleonora_bartoli', 			'group', 'AC', 'age', 0, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(9)  = struct('name', 'giada_fix2', 				'group', 'AC', 'age', 0, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(10) = struct('name', 'jorhabib',    				'group', 'AC', 'age', 0, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(11) = struct('name', 'martina2',     				'group', 'AC', 'age', 0, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(12) = struct('name', 'stefano',   				'group', 'AC', 'age', 0, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(13) = struct('name', 'yannis3', 					'group', 'AC', 'age', 0, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);

project.subjects.list               = {project.subjects.data.name};
project.subjects.numsubj            = length(project.subjects.list);

project.subjects.group_names        = {'AC'};
project.subjects.groups             = {{'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'}; ...
                                      };

%% ======================================================================================================
% I:    STUDY
% ======================================================================================================
project.study.filename = [project.name project.study_suffix '.study'];

% structures that associates conditions' file with (multiple) factor(s)
project.study.factors(1) = struct('factor', 'motion', 'file_match', [], 'level', 'translating');
project.study.factors(2) = struct('factor', 'motion', 'file_match', [], 'level', 'centered');
project.study.factors(3) = struct('factor', 'shape' , 'file_match', [], 'level', 'walker');
project.study.factors(4) = struct('factor', 'shape' , 'file_match', [], 'level', 'scrambled');

project.study.factors(1).file_match = {'twalker', 'tscrambled'};
project.study.factors(2).file_match = {'cwalker', 'cscrambled'};
project.study.factors(3).file_match = {'twalker', 'cwalker'};
project.study.factors(4).file_match = {'tscrambled', 'cscrambled'};

% ERP
project.study.erp.tmin_analysis.s               = project.epoching.epo_st.s;
project.study.erp.tmax_analysis.s               = project.epoching.epo_end.s;
project.study.erp.ts_analysis.s                 = 0.008;
project.study.erp.timeout_analysis_interval.s   = [project.study.erp.tmin_analysis.s:project.study.erp.ts_analysis.s:project.study.erp.tmax_analysis.s];

% ERSP
project.study.ersp.tmin_analysis.s              = project.epoching.epo_st.s;
project.study.ersp.tmax_analysis.s              = project.epoching.epo_end.s;
project.study.ersp.ts_analysis.s                = 0.008;
project.study.ersp.timeout_analysis_interval.s  = [project.study.ersp.tmin_analysis.s:project.study.ersp.ts_analysis.s:project.study.ersp.tmax_analysis.s];

project.study.ersp.fmin_analysis                = 4;
project.study.ersp.fmax_analysis                = 32;
project.study.ersp.fs_analysis                  = 0.5;
project.study.ersp.freqout_analysis_interval    = [project.study.ersp.fmin_analysis:project.study.ersp.fs_analysis:project.study.ersp.fmax_analysis];
project.study.ersp.padratio                     = 16;
project.study.ersp.cycles                       = 0; ...[3 0.8];



project.study.precompute.recompute              = 'on';
project.study.precompute.do_erp                 = 'on';
project.study.precompute.do_ersp                = 'off';
project.study.precompute.do_erpim               = 'off';
project.study.precompute.do_spec                = 'off';



project.study.precompute.erp   = {'interp','off','allcomps','on','erp'  ,'on','erpparams'  ,{},'recompute','off'};
project.study.precompute.erpim = {'interp','off','allcomps','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'recompute','off'};
project.study.precompute.spec  = {'interp','off','allcomps','on','spec' ,'on','specparams' ,{'specmode' 'fft','freqs' project.study.ersp.freqout_analysis_interval},'recompute','off'};
project.study.precompute.ersp  = {'interp','off' ,'allcomps','on','ersp' ,'on','erspparams' ,{'cycles' project.study.ersp.cycles,  'freqs', project.study.ersp.freqout_analysis_interval, 'timesout', project.study.ersp.timeout_analysis_interval.s*1000, ...
                                 'freqscale','linear','padratio', project.study.ersp.padratio, 'baseline',[project.epoching.bc_st.s*1000 project.epoching.bc_end.s*1000] },'itc','on','recompute','off'};


%% ======================================================================================================
% L:    DESIGN
% ======================================================================================================

project.design(1)=struct('name', 'all'          , 'factor1_name', 'condition'   , 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', ''        , 'factor2_levels', [], 'factor2_pairing', 'off');
project.design(2)=struct('name', 'motion'       , 'factor1_name', 'motion'      , 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', ''        , 'factor2_levels', [], 'factor2_pairing', 'off');
project.design(3)=struct('name', 'shape'        , 'factor1_name', 'shape'       , 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', ''        , 'factor2_levels', [], 'factor2_pairing', 'off');
project.design(4)=struct('name', 'shape_motion' , 'factor1_name', 'shape'       , 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', 'motion'  , 'factor2_levels', [], 'factor2_pairing', 'on');

project.design(1).factor1_levels={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};
project.design(2).factor1_levels={'centered','translating'};
project.design(3).factor1_levels={'scrambled','walker'};
project.design(4).factor1_levels={'scrambled','walker'};
project.design(4).factor2_levels={'centered','translating'};
        
%% ======================================================================================================
% M:    STATS
% ======================================================================================================
% ERP
project.stats.erp.pvalue                        = 0.05; ...0.01;  % level of significance applied in ERP statistical analysis
project.stats.erp.num_permutations              = 100000;           % number of permutations applied in ERP statistical analysis
project.stats.erp.num_tails                     = 2;
project.stats.eeglab.erp.method                 = 'bootstrap';      % method applied in ERP statistical analysis
project.stats.eeglab.erp.correction             = 'fdr';           % multiple comparison correction applied in ERP statistical analysis

% ERSP
project.stats.ersp.pvalue                       = 0.0125; ...0.01;    % level of significance applied in ERSP statistical analysis
project.stats.ersp.num_permutations             = 100000;            % number of permutations applied in ERP statistical analysis
project.stats.ersp.num_tails                    = 2;
project.stats.ersp.decimation_factor_times_tf   = 10;
project.stats.ersp.decimation_factor_freqs_tf   = 10;
project.stats.ersp.tf_resolution_mode           = 'continuous';     %'continuous'; 'decimate_times';'decimate_freqs';'decimate_times_freqs';'tw_fb';
project.stats.ersp.measure                      = 'dB';             % 'Pfu';  dB decibel, Pfu, (A-R)/R * 100 = (A/R-1) * 100 = (10^.(ERSP/10)-1)*100 variazione percentuale definita da pfursheller
project.stats.eeglab.ersp.method                = 'bootstrap';      % method applied in ERP statistical analysis
project.stats.eeglab.ersp.correction            = 'none';            % multiple comparison correction applied in ERP statistical analysis


project.stats.ersp.narrowband.group_tmin        = [];
project.stats.ersp.narrowband.group_tmax        = [];
project.stats.ersp.narrowband.dfmin             = [];
project.stats.ersp.narrowband.dfmax             = [];
project.stats.ersp.narrowband.which_realign_measure = [];

% BRAINSTORM
project.stats.brainstorm.pvalue                 = 0.025; ...0.01;   % level of significance applied in ERSP statistical analysis
project.stats.brainstorm.correction             = 'fdr';            % multiple comparison correction applied in ERP statistical analysis

% SPM
project.stats.spm.pvalue                        = 0.025; ...0.01;   % level of significance applied in ERSP statistical analysis
project.stats.spm.correction                    = 'fwe';            % multiple comparison correction applied in ERP statistical analysis

%% ======================================================================================================
% N:    POSTPROCESS
% ======================================================================================================

% ERP

project.postprocess.erp.mode.continous              = struct('time_resolution_mode', 'continuous', 'peak_type', 'off'          , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.erp.mode.tw_group_noalign       = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.erp.mode.tw_group_align         = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'on',  'tw_stat_estimator', 'tw_extremum');
project.postprocess.erp.mode.tw_individual_noalign  = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.erp.mode.tw_individual_align    = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'on' , 'tw_stat_estimator', 'tw_extremum');


project.postprocess.erp.sel_extrema = 'first_occurrence';%'avg_occurrences'



project.postprocess.erp.roi_list={
                                  {'hEye'};                                         ... hEye    
                                  {'PO8','P8','TP8','PO7','P7','TP7'};    ... VENTRAL
};
project.postprocess.erp.roi_names={'eye', 'ventral'};

project.postprocess.erp.numroi=length(project.postprocess.erp.roi_list);

project.postprocess.erp.design(1).group_time_windows(1)=struct('name','N1','min',180, 'max',250);
project.postprocess.erp.design(1).group_time_windows(2)=struct('name','N2','min',365, 'max',450);

project.postprocess.erp.design(1).subject_time_windows(1)=struct('min',-10, 'max',10);
project.postprocess.erp.design(1).subject_time_windows(2)=struct('min',-10, 'max',10);

project.postprocess.erp.design(1).which_extrema_curve = {  ... roi x time_windows
                                {'min';'min'}; ... 
                                {'min';'min'}; ... 
};


project.postprocess.erp.design(1).deflection_polarity_list = {  ... design x roi x time_windows
                                ...   tw1      tw2  ...
                                {'negative';'negative'} ... roi 1
                                {'negative';'negative'} ... roi 1
};

project.postprocess.erp.eog.design(1).deflection_polarity_list = [];
project.postprocess.erp.emg.design(1).deflection_polarity_list = [];


% minimum duration in ms of the deflections: deflections shorter than this
% threshold will be removed
project.postprocess.erp.design(1).min_duration     = 10;
project.postprocess.erp.eog.design(1).min_duration = 10;
project.postprocess.erp.emg.design(1).min_duration = 10;


for ds=2:length(project.design)
    project.postprocess.erp.design(ds) = project.postprocess.erp.design(1);
end






% ERSP 

project.stats.ersp.do_narrowband                     = 'off'; % on|off enable/disable the adjustment of spectral band for each subject
project.postprocess.ersp.sel_extrema                 ='first_occurrence';%'avg_occurrences'

project.postprocess.ersp.mode.continous              = struct('time_resolution_mode', 'continuous', 'peak_type', 'off'          , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.ersp.mode.tw_group_noalign       = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.ersp.mode.tw_group_align         = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'on',  'tw_stat_estimator', 'tw_extremum');
project.postprocess.ersp.mode.tw_individual_noalign  = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.ersp.mode.tw_individual_align    = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'on' , 'tw_stat_estimator', 'tw_extremum');

project.postprocess.ersp.design(1).group_time_windows(1)=struct('name','P100','min',80,  'max',140);
project.postprocess.ersp.design(1).group_time_windows(2)=struct('name','N200','min',180, 'max',250);
project.postprocess.ersp.design(1).group_time_windows(3)=struct('name','P330','min',280, 'max',360);
project.postprocess.ersp.design(1).group_time_windows(4)=struct('name','N400','min',380, 'max',450);
project.postprocess.ersp.design(1).group_time_windows(5)=struct('name','P550','min',450, 'max',600);
    
project.postprocess.ersp.design(1).subject_time_windows(1)=struct('min',-20, 'max',20);
project.postprocess.ersp.design(1).subject_time_windows(2)=struct('min',-20, 'max',20);
project.postprocess.ersp.design(1).subject_time_windows(3)=struct('min',-20, 'max',20);
project.postprocess.ersp.design(1).subject_time_windows(4)=struct('min',-20, 'max',20);
project.postprocess.ersp.design(1).subject_time_windows(5)=struct('min',-20, 'max',20);


project.postprocess.ersp.design(1).which_extrema_curve = {     .... design x roi x freq band x time window
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };                                    
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };                                    
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };                                    
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };                                   
};


% extreme to be searched in the continuous curve ( NON time-window mode)
project.postprocess.ersp.design(1).which_extrema_curve_continuous = {     .... design x roi x freq band
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                    
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                    
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                    
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                   
};





% time interval for searching extreme in the continuous curve ( NON time-window mode)
project.postprocess.ersp.design(1).group_time_windows_continuous = {     .... design x roi x freq band x time window
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };                                    
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };                                    
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };                                    
                                    {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };
                                     {... roi
                                        {};... frequency band
                                        {};...
                                        {}; ...
                                        {}...
                                    };                                  
};



for ds=2:length(project.design)
    project.postprocess.ersp.design(ds) = project.postprocess.ersp.design(1);
end

project.postprocess.ersp.sel_extrema ='first_occurrence';%'avg_occurrences'

project.postprocess.ersp.frequency_bands(1)=struct('name', 'teta' , 'min', 3 , 'max', 5);
project.postprocess.ersp.frequency_bands(2)=struct('name', 'mu'   , 'min', 8 , 'max', 12);
project.postprocess.ersp.frequency_bands(3)=struct('name', 'beta1', 'min', 14, 'max', 20);
project.postprocess.ersp.frequency_bands(4)=struct('name', 'beta2', 'min', 20, 'max', 32);

project.postprocess.ersp.frequency_bands_list={}; ... writes something like {[4,8];[8,12];[14,20];[20,32]};
for fb=1:length(project.postprocess.ersp.frequency_bands)
    bands=[project.postprocess.ersp.frequency_bands(fb).min, project.postprocess.ersp.frequency_bands(fb).max];
    project.postprocess.ersp.frequency_bands_list=[project.postprocess.ersp.frequency_bands_list; {bands}];
end
project.postprocess.ersp.frequency_bands_names={project.postprocess.ersp.frequency_bands.name};


project.postprocess.ersp.roi_list={
                                  {'PO4','O2','PO3', 'O1'};                         ... Visual
                                  {'P6','PO8','P8','TP8','P5','PO7','P7','TP7'};    ... VENTRAL-eba/mt
                                  {'CP6','CP5'};                                    ... STSpost
                                  {'F6','F8','AF8','FT8','F5','F7','AF7','FT7'};    ... IFG
                                  {'CP4','CP6','P4','P6','CP3','CP5','P3','P5'};    ... IPL
                                  {'CP4','P4','CP2','P2','CP3','P3','CP1','P1'};    ... SPL
                                  {'Cz','CPz'}                                      ... SMA_legm1                                
};
project.postprocess.ersp.roi_names={'Visual','Ventral-eba','STC post','IFG','IPL','SPL','SMA_leg'};

project.postprocess.ersp.numroi=length(project.postprocess.ersp.roi_list);

project.postprocess.design_factors_ordered_levels={...
                              {{'cscrambled' 'cwalker' 'tscrambled' 'twalker'} {}};...for each desing, up to 2 factors
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
                              {{} {}};...
};

%% ======================================================================================================
% O:    RESULTS DISPLAY
% ======================================================================================================

% ERP
project.results_display.erp.time_smoothing=10;                 % frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
project.results_display.ylim_plot=[-2.5 2.5];           %y limits (uV)for the representation of ERP
project.results_display.erp.time_range.s        = [project.study.erp.tmin_analysis.s project.study.erp.tmax_analysis.s];       % time range for erp representation
project.results_display.erp.single_subjects='off';                          % display patterns of the single subjcts (keeping the average pattern)
project.results_display.erp.do_plots='on';
project.results_display.erp.show_text='on';
project.results_display.erp.masked_times_max = []; % number of ms....all the timepoints before this values are not considered for statistics
project.results_display.erp.z_transform = 'off';
project.results_display.erp.compact_plots='on';                             % display (curve) plots with different conditions/groups on the same plots
project.results_display.erp.compact_h0='on';                                % display parameters for compact plots
project.results_display.erp.compact_v0='on';
project.results_display.erp.compact_sem='off';%'off';
project.results_display.erp.compact_stats='on';
project.results_display.erp.compact_display_xlim=[];
project.results_display.erp.compact_display_ylim=[-4 3];
project.results_display.erp.display_only_significant_curve='on'; %on

project.results_display.erp.compact_plots_topo='on'; 
project.results_display.erp.display_only_significant_topo_mode='surface'; %'electrodes';
project.results_display.erp.display_compact_topo_mode='errorbar'; ...'boxplot'; ... 'errorbar'
project.results_display.erp.display_compact_show_head='on'; ...'on'|'off'
project.results_display.erp.display_only_significant_topo='on'; %on
project.results_display.erp.set_caxis_topo_tw=[];

% ERSP
project.results_display.ersp.time_range.s       = [project.study.ersp.tmin_analysis.s project.study.ersp.tmax_analysis.s];     % time range for erp representation
project.results_display.ersp.frequency_range    = [project.study.ersp.fmin_analysis project.study.ersp.fmax_analysis];         % frequency range for ersp representation

project.results_display.ersp.compact_plots='on';                             % display (curve) plots with different conditions/groups on the same plots
project.results_display.ersp.single_subjects='off';                          % display patterns of the single subjcts (keeping the average pattern)
project.results_display.ersp.compact_h0='on';                                % display parameters for compact plots
project.results_display.ersp.compact_v0='on';
project.results_display.ersp.compact_sem='off';
project.results_display.ersp.compact_stats='on';
project.results_display.ersp.compact_display_xlim=[];
project.results_display.ersp.compact_display_ylim=[];
project.results_display.ersp.freq_scale='linear';   %'log'|'linear'
project.results_display.ersp.masked_times_max = []; % number of ms....all the timepoints before this values are not considered for statistics
project.results_display.ersp.set_caxis_tf=[];
project.results_display.ersp.set_caxis_topo_tw_fb=[];
project.results_display.ersp.display_only_significant_curve='on'; %on % the threshold is always set, however you can choose to display only the significant p values or all the p values (in the curve plots the threshold is added as a landmark)
project.results_display.ersp.display_only_significant_topo='on'; %on
project.results_display.ersp.display_only_significant_topo_mode='surface'; %'electrodes';
project.results_display.ersp.display_only_significant_tf='on'; %on
project.results_display.ersp.display_only_significant_tf_mode='binary'; ....'thresholded'; % 'binary';
project.results_display.ersp.compact_plots_topo='on'; 
project.results_display.ersp.display_compact_topo_mode='errorbar'; ... 'errorbar'
project.results_display.ersp.display_compact_show_head='on'; ...'on'|'off'
project.results_display.ersp.do_plots='on';
project.results_display.ersp.show_text='on';


%% ======================================================================================================
% P:    EXPORT
% ======================================================================================================
project.export.r.bands=[];
for nband=1:length(project.postprocess.ersp.frequency_bands_names)
    project.export.r.bands(nband).freq=project.postprocess.ersp.frequency_bands_list{nband};
    project.export.r.bands(nband).name=project.postprocess.ersp.frequency_bands_names{nband};
end
clear nband;
%% ======================================================================================================
% Q:    CLUSTERING
% ======================================================================================================
project.clustering.channels_file_name='cluster_projection_channel_locations.loc';
project.clustering.channels_file_path=''; ... later set by define_paths

%% ======================================================================================================
% R:    BRAINSTORM
% ======================================================================================================
project.brainstorm.db_name='walker_bst_db_cleanica';                  ... must correspond to brainstorm db name

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
%                     project.postprocess.ersp.frequency_bands(4).name, [num2str(project.postprocess.ersp.frequency_bands(4).min) ', ' num2str(project.postprocess.ersp.frequency_bands(4).max)], 'mean' ...
                                  }};
                                  
project.brainstorm.analysis_times={{'t-4', '-0.4000, -0.3040', 'mean'; 't-3', '-0.3000, -0.2040', 'mean'; 't-2', '-0.2000, -0.1040', 'mean'; 't-1', '-0.1000, -0.0040', 'mean'; 't1', '0.0000, 0.0960', 'mean'; 't2', '0.1000, 0.1960', 'mean'; 't3', '0.2000, 0.2960', 'mean'; 't4', '0.3000, 0.3960', 'mean'; 't5', '0.4000, 0.4960', 'mean'; 't6', '0.5000, 0.5960', 'mean'; 't7', '0.6000, 0.6960', 'mean'; 't8', '0.7000, 0.7960', 'mean'; 't9', '0.8000, 0.8960', 'mean'; 't10', '0.9000, 0.9960', 'mean'}};

project.brainstorm.conductorvolume.type = 1;
project.brainstorm.conductorvolume.surf_bem_file_name = 'headmodel_surf_openmeeg.mat';
project.brainstorm.conductorvolume.vol_bem_file_name  = 'headmodel_vol_openmeeg.mat';

if project.brainstorm.conductorvolume.type == 1
    project.brainstorm.conductorvolume.bem_file_name = project.brainstorm.conductorvolume.surf_bem_file_name;
else
    project.brainstorm.conductorvolume.bem_file_name = project.brainstorm.conductorvolume.vol_bem_file_name;
end

project.brainstorm.use_same_montage=1;
project.brainstorm.default_anatomy='Colin27';
project.brainstorm.channels_file_name='brainstorm_channel_acticaps_64.mat';
project.brainstorm.channels_file_type='BST';
project.brainstorm.channels_file_path=''; ... later set by define_paths
    
project.brainstorm.export.spm_vol_downsampling=2;
project.brainstorm.export.spm_time_downsampling=1;

project.brainstorm.std_loose_value=0.2;

project.brainstorm.average_file_name = 'data_average';
project.brainstorm.stats.ttest_abstype = 1;
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
%     [project.postprocess.ersp.frequency_bands(4).min,project.postprocess.ersp.frequency_bands(4).max]; ...
    };
% project.postprocess.eeglab.frequency_bands_names={project.postprocess.ersp.frequency_bands(1).name,project.postprocess.ersp.frequency_bands(2).name,project.postprocess.ersp.frequency_bands(3).name,project.postprocess.ersp.frequency_bands(4).name};
project.postprocess.eeglab.frequency_bands_names={project.postprocess.ersp.frequency_bands(1).name,project.postprocess.ersp.frequency_bands(2).name,project.postprocess.ersp.frequency_bands(3).name};
%  ********* /DERIVED DATA  *****************************************************************


% ERP
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.study.erp.tmin_analysis.ms=project.study.erp.tmin_analysis.s*1000;
project.study.erp.tmax_analysis.ms=project.study.erp.tmax_analysis.s*1000;
project.study.erp.ts_analysis.ms=project.study.erp.ts_analysis.s*1000;
project.study.erp.timeout_analysis_interval.ms=project.study.erp.timeout_analysis_interval.s*1000;
%  ********* /DERIVED DATA  *****************************************************************


% ERSP
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.study.ersp.tmin_analysis.ms=project.study.ersp.tmin_analysis.s*1000;
project.study.ersp.tmax_analysis.ms=project.study.ersp.tmax_analysis.s*1000;
project.study.ersp.ts_analysis.ms=project.study.ersp.ts_analysis.s*1000;
project.study.ersp.timeout_analysis_interval.ms=project.study.ersp.timeout_analysis_interval.s*1000;
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



clear bands;
clear ds;
clear fb;
