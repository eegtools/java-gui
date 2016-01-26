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
% this file need the variable: project_folder
%% ======================================================================================================
% A:    START
% ======================================================================================================
...project.research_group                           % A1: set in main: e.g.  PAP or MNI
...project.research_subgroup                        % A2: set in main: e.g.  PAP or MNI
...project.name                                     % A3:   set in main : must correspond to 'project.paths.local_projects_data' subfolder name

project.study_suffix='';                            % A4: sub name used to create a different STUDY name (fianl file will be called: [project.name project.study_suffix '.study'])
project.analysis_name='study_ao_presound_as_baseline';         % A5: epoching output folder name, subfolder containing the condition files of the current analysis type

project.do_source_analysis=0;                       % A6:  
project.do_emg_analysis=1;                          % A7:
project.do_cluster_analysis=0;                      % A8:

%% ======================================================================================================
% B:    PATHS  
% ======================================================================================================
% set by: main file
...project.paths.projects_data_root                 % B1:   folder containing local RBCS projects root-folder,  set in main
...project.paths.svn_scripts_root                   % B2:   folder containing local RBCS script root-folder,  set in main
...project.paths.plugins_root                       % B3:   folder containing local MATLAB PLUGING root-folder, set in main

...project.paths.common_scripts                     % B4:
...project.paths.eeg_tools                          % B5:
...project.paths.scripts                            % B6:

% set by define_paths_structure
...project.paths.global_scripts                     % B7:
...project.paths.global_spm_templates               % B8:

% set by: define_paths_structure
project.paths.project='';                           % B9:   folder containing data, epochs, results etc...(not scripts)
project.paths.original_data='';                     % B10:  folder containing EEG raw data (BDF, vhdr, eeg, etc...)
project.paths.input_epochs='';                      % B11:  folder containing EEGLAB EEG input epochs set files 
project.paths.output_epochs='';                     % B12:  folder containing EEGLAB EEG output condition epochs set files
project.paths.results='';                           % B13:  folder containing statistical results
project.paths.emg_epochs='';                        % B14:  folder containing EEGLAB EMG epochs set files 
project.paths.emg_epochs_mat='';                    % B15:  folder containing EMG data strucuture
project.paths.tf='';                                % B16:  folder containing 
project.paths.cluster_projection_erp='';            % B17:  folder containing 
project.paths.batches='';                           % B18:  folder containing bash batches (usually for SPM analysis)
project.paths.spmsources='';                        % B19:  folder containing sources images exported by brainstorm
project.paths.spmstats='';                          % B20:  folder containing spm stat files
project.paths.spm='';                               % B21:  folder containing spm toolbox
project.paths.eeglab='';                            % B22:  folder containing eeglab toolbox
project.paths.brainstorm='';                        % B23:  folder containing brainstorm toolbox
%% ======================================================================================================
% C:    TASK
% ======================================================================================================
project.task.events.start_experiment_trigger_value      = '1';         % C1:   signal experiment start
project.task.events.pause_trigger_value                 = '2';                    % C2:   start: pause, feedback and rest period
project.task.events.resume_trigger_value                = '3';                   % C3:   end: pause, feedback and rest period
project.task.events.end_experiment_trigger_value        = '4';           % C4:   signal experiment end
project.task.events.trial_end_trigger_value             = '5';
project.task.events.videoend_trigger_value              = '5';
project.task.events.question_trigger_value              = '6';
project.task.events.AOCS_audio_trigger_value            = '7';
project.task.events.AOIS_audio_trigger_value            = '8';
project.task.events.baseline_start_trigger_value        = '9';
project.task.events.baseline_end_trigger_value          = '10';
project.task.events.trial_start_trigger_value           = project.task.events.baseline_start_trigger_value;

project.task.events.preAOCS_audio_trigger_value         = '70';
project.task.events.preAOIS_audio_trigger_value         = '80';
project.task.events.preAO_audio_trigger_equiv_value     = '60';
project.task.events.AO_audio_trigger_equiv_value        = '600';


project.task.events.mrkcode_cond                    = { ...
                                                        {'600'};...  
                                                        {'7'};...            
                                                        {'8'};...
                                                     };
                                                 
                                                 
project.task.events.mrkcode_movement_start          = { ...
                                                       ... {'11' '12' '13' '14' '15' '16'};...     % G15:  triggers defining conditions...even if only one trigger is used for each condition, a cell matrix is used
                                                        {'210' '220' '230' '240' '250' '260'};...            
                                                        {'310' '320' '330' '340' '350' '360'};...
                                                        {'410' '420' '430' '440' '450' '460'};...  
                                                     };

                                                 
                                                 
project.task.events.valid_marker                    = [project.task.events.mrkcode_cond{1:length(project.task.events.mrkcode_cond)}];
project.task.events.import_marker                   = [{'1' '2' '3' '4' '5' '6' '7' '8' '9' '10'} project.task.events.valid_marker];  
                                                 

%% ======================================================================================================
% D:    IMPORT
% ======================================================================================================
% input file name  = [original_data_prefix subj_name original_data_suffix . original_data_extension]
% output file name = [original_data_prefix subj_name original_data_suffix project.import.output_suffix . set]

project.import.acquisition_system='BIOSEMI';                            % E1:   EEG hardware type: BIOSEMI | BRAINAMP
project.import.original_data_extension='bdf';                           % E2:   original data file extension
project.import.original_data_folder='action_observation';                               % E3:   original data file subfolder
project.import.original_data_suffix='';                                 % E4:   string after subject name in original EEG file nale....often empty
project.import.original_data_prefix='';                                 % E5:   string before subject name in original EEG file nale....often empty

%output
project.import.output_folder= 'action_observation';                        % D6:   string appended to fullfile(project.paths.project,'epochs', ...=) , determining where to write imported file
project.import.output_suffix= '_raw';                                    % E7:   string appended to input file name after importing original file
project.import.emg_output_postfix= '_observation_emg';                  % E8:   string appended to input file name to EMG file

project.import.reference_channels={'CAR'};                                   % E9:   list of electrodes to be used as reference

% D10:   list of electrodes to transform

project.import.ch2transform(1)          = struct('type', 'eog' , 'ch1', 65,'ch2', 66, 'new_label', 'DVEOG');        ... eog bipolar                   
project.import.ch2transform(2)          = struct('type', 'emg' , 'ch1', 67,'ch2', 68, 'new_label', 'DFDR');         ... emg bipolar
project.import.ch2transform(3)          = struct('type', 'emg' , 'ch1', 69,'ch2', 70, 'new_label', 'NDFDR');        ... emg bipolar
project.import.ch2transform(4)          = struct('type', 'emg' , 'ch1', 71,'ch2', 72, 'new_label', 'DTA');          ... emg bipolar

% x carlotta
% project.import.ch2transform(1)          = struct('type', 'eog' , 'ch1', 69,'ch2', 70, 'new_label', 'DVEOG');        ... eog bipolar                   
% project.import.ch2transform(2)          = struct('type', 'emg' , 'ch1', 65,'ch2', 66, 'new_label', 'DFDR');         ... emg bipolar
% project.import.ch2transform(3)          = struct('type', 'emg' , 'ch1', 67,'ch2', 68, 'new_label', 'NDFDR');        ... emg bipolar
% project.import.ch2transform(4)          = struct('type', 'emg' , 'ch1', 71,'ch2', 72, 'new_label', 'DTA');          ... emg bipolar

% D11:  list of trigger marker to import. can be a cel array, or a string with these values: 'all', 'stimuli','responses'
project.import.valid_marker={'11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '50' '60' '70' '80'};  

%% ======================================================================================================
% E:    EEGDATA
% ======================================================================================================
project.eegdata.nch=68;                                                 % D1:   final channels_number after electrode removal and polygraphic transformation
project.eegdata.nch_eeg=64;                                             % D2:   EEG channels_number
project.eegdata.fs=256;                                                 % D3:   final sampling frequency in Hz, if original is higher, then downsample it
project.eegdata.eeglab_channels_file_name='standard-10-5-cap385.elp';   % D4:   universal channels file name containing the position of 385 channels
project.eegdata.eeglab_channels_file_path='';                           % D5:   later set by define_paths
    
project.eegdata.eeg_channels_list           = [1:project.eegdata.nch_eeg];  % E6:   list of EEG channels IDs

project.eegdata.emg_channels_list           = [];
project.eegdata.emg_channels_list_labels    = [];
project.eegdata.eog_channels_list           = [];
project.eegdata.eog_channels_list_labels    = [];

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
% input file name  = [original_data_prefix subj_name original_data_suffix project.import.output_suffix . set]
% output file name = [original_data_prefix subj_name original_data_suffix project.import.output_suffix . set]
project.preproc.output_folder = project.import.output_folder; 
project.preproc.filter_algorithm = 'pop_eegfiltnew_12'; 

% during import
% GLOBAL FILTER
project.preproc.ff1_global=0.16;                                        % F1:   lower frequency in Hz of the preliminar filtering applied during data import
project.preproc.ff2_global=100;                                         % F2:   higher frequency in Hz of the preliminar filtering applied during data import

% NOTCH
project.preproc.do_notch      = 1;                            % F3:   define if apply the notch filter at 50 Hz
project.preproc.notch_fcenter = 50;                           % F4:   center frequency of the notch filter 50 Hz or 60 Hz
project.preproc.notch_fspan   = 5;                            % F5:   halved frequency range of the notch filters  
project.preproc.notch_remove_armonics = 'first';                %       'all' | 'first' reemove all or only the first harmonic(s) of the line current

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

% CALCULATE RT
project.preproc.rt.eve1_type            = [];               % F12:
project.preproc.rt.eve2_type            = [];               % F13:
project.preproc.rt.allowed_tw_ms.min    = [];               % F14:
project.preproc.rt.allowed_tw_ms.max    = [];               % F14:
project.preproc.rt.output_folder        = [];               % F15:

%% ADD NEW MARKERS

% DEFINE MARKER LABELS
project.preproc.marker_type.begin_trial     = project.task.events.baseline_start_trigger_value;
project.preproc.marker_type.end_trial       = project.task.events.trial_end_trigger_value;
project.preproc.marker_type.begin_baseline  = project.task.events.baseline_start_trigger_value;
project.preproc.marker_type.end_baseline    = project.task.events.baseline_end_trigger_value;

% INSERT BEGIN TRIAL MARKERS (only if both the target and the begin trial types are NOT empty)
project.preproc.insert_begin_trial.target_event_types       = [];        % string or cell array of strings denoting the type(s) (i.e. labels) of the target events used to set the the begin trial markers 
project.preproc.insert_begin_trial.delay.s                  = repmat( -1.5, 1, length(project.preproc.insert_begin_trial.target_event_types));                           % time shift (in ms) to anticipate (negative values ) or posticipate (positive values) the new begin trial markers
                                                                                                %      with respect to the target events, if empty ([]) time shift = 0.
% INSERT END TRIAL MARKERS (only if both the target and the begin trial types are NOT empty)
project.preproc.insert_end_trial.target_event_types         = [];        % string or cell array of strings denoting the type(s) (i.e. labels) of the target events used to set the the end trial markers 
project.preproc.insert_end_trial.delay.s                    = [];                           % time shift (in ms) to anticipate (negative values ) or posticipate (positive values) the new end trial markers

% INSERT BEGIN BASELINE MARKERS (project.epoching.baseline_replace.baseline_begin_marker)
project.preproc.insert_begin_baseline.target_event_types    = project.task.events.mrkcode_cond;                % a target event for placing the baseline markers: baseline begin marker will be placed at the target marker with a selected delay.
project.preproc.insert_begin_baseline.delay.s               = repmat( -1.5, 1, length(project.preproc.insert_begin_trial.target_event_types));                                         % the delay (in seconds) between the target marker and the begin baseline marker to be placed: 
                                                                                                                        % >0 means that baseline begin FOLLOWS the target, 
                                                                                                                        % =0 means that baseline begin IS AT THE SAME TIME the target, 
                                                                                                                        % <0 means that baseline begin ANTICIPATES the target.
                                                                                                                        % IMPOTANT NOTE: The latency information is displayed in seconds for continuous data, 
                                                                                                                        % or in milliseconds relative to the epoch's time-locking event for epoched data. 
                                                                                                                        % As we will see in the event scripting section, 
                                                                                                                        % the latency information is stored internally in data samples (points or EEGLAB 'pnts') 
                                                                                                                        % relative to the beginning of the continuous data matrix (EEG.data). 

% INSERT END BASELINE MARKERS (project.epoching.baseline_replace.baseline_end_marker)                                                                                                                        
project.preproc.insert_end_baseline.target_event_types      = project.task.events.mrkcode_cond;                % a target event for placing the baseline markers: baseline begin marker will be placed at the target marker with a selected delay.
project.preproc.insert_end_baseline.delay.s                 = repmat( -0.56, 1, length(project.preproc.insert_begin_trial.target_event_types));                                            % the delay (in seconds) between the target marker and the begin baseline marker to be placed: 
                                                                                                                        % >0 means that baseline begin FOLLOWS the target, 
                                                                                                                        % =0 means that baseline begin IS AT THE SAME TIME the target, 
                                                                                                                        % <0 means that baseline begin ANTICIPATES the target.
                                                                                                                        % IMPOTANT NOTE: The latency information is displayed in seconds for continuous data, 
                                                                                                                        % or in milliseconds relative to the epoch's time-locking event for epoched data. 
                                                                                                                        % As we will see in the event scripting section, 
                                                                                                                        % the latency information is stored internally in data samples (points or EEGLAB 'pnts') 
                                                                                                                        % relative to the beginning of the continuous data matrix (EEG.data). 
  
%% ======================================================================================================
% G:    EPOCHING
% ======================================================================================================
% input file name  = [original_data_prefix subj_name original_data_suffix project.import.output_suffix epoching.input_suffix . set]
% output file name = [original_data_prefix subj_name original_data_suffix project.import.output_suffix epoching.input_suffix '_' CONDXX. set]
project.epoching.input_folder = fullfile(project.import.output_folder, '04_mc' , ''); %_er input folder
project.epoching.input_epochs_folder = project.analysis_name; % epoching output folder


project.epoching.baseline_replace.mode                       = 'none';                      % replace a baseline before/after events to  be epoched and processed: 
                                                                                                %  * 'trial'    use a baseline within each trial
                                                                                                %  * 'external' use a baseline obtained from a period of global baseline, not within the trials, 
                                                                                                %     extracted from the current recording or from another file
                                                                                                %  * 'none'do not add a baseline (standard simple case)    


project.epoching.baseline_replace.baseline_originalposition  = 'before';                     % when replace the new baseline: the baseline segments to be inserted are originally 'before' or 'after' the events to  be epoched and processed                                                                                                                                                                             
project.epoching.baseline_replace.baseline_finalposition     = 'before';                     % when replace the new baseline: the baseline segments are inserted 'before' or 'after' the events to  be epoched and processed                                                                                 
project.epoching.baseline_replace.replace                    = 'part';                    % 'all' 'part' replace all the pre/post marker period with a replicated baseline or replace the baseline at the begin (final position 'before') or at the end (final position 'after') of the recostructed baseline

   
% EEG
project.epoching.input_suffix='_mc';                                   % G1:   final file name before epoching : default is '_raw_mc'
project.epoching.input_epochs_folder=project.analysis_name;            % G2:   input epoch folder
project.epoching.bc_type='trial';                                      % G3:   type of baseline correction: global: considering all the trials, 'condition': by condition, 'trial': trial-by-trial


project.epoching.epo_st.s=-1;                                       % G4:   EEG epochs start latency
project.epoching.epo_end.s=1.18;                                       % G5:   EEG epochs end latency
project.epoching.bc_st.s=-1;                                        % G6:   EEG baseline correction start latency
project.epoching.bc_end.s=-0.04;                                      % G7:   EEG baseline correction end latency
project.epoching.baseline_duration.s= project.epoching.bc_end.s - project.epoching.bc_st.s ;

% point
project.epoching.bc_st_point=round((project.epoching.bc_st.s-project.epoching.epo_st.s)*project.eegdata.fs)+1;   % G7:   EEG baseline correction start point
project.epoching.bc_end_point=round((project.epoching.bc_end.s-project.epoching.epo_st.s)*project.eegdata.fs)+1; % G8:   EEG baseline correction end point

% EMG
project.epoching.emg_epo_st.s=-1.5;                                    % G9:   EMG epochs start latency
project.epoching.emg_epo_end.s= 1.95;                                       % G10:  EMG epochs end latency
project.epoching.emg_bc_st.s= -0.95;                                      % G11:  EMG baseline correction start latency
project.epoching.emg_bc_end.s=-0.50;                                   % G12:  EMG baseline correction end latency

% point
project.epoching.emg_bc_st_point    = round((project.epoching.emg_bc_st.s-project.epoching.emg_epo_st.s)*project.eegdata.fs)+1; % G13:   EMG baseline correction start point
project.epoching.emg_bc_end_point   = round((project.epoching.emg_bc_end.s-project.epoching.emg_epo_st.s)*project.eegdata.fs)+1; % G14:   EMG baseline correction end point

% markers
project.epoching.mrkcode_cond       = project.task.events.mrkcode_cond;
project.epoching.numcond            = length(project.epoching.mrkcode_cond);       % G16: conditions' number 
project.epoching.valid_marker       = [project.epoching.mrkcode_cond{1:length(project.epoching.mrkcode_cond)}];

project.epoching.condition_names    = {'AO' 'AOCS' 'AOIS'};        % G 17: conditions' labels
if length(project.epoching.condition_names) ~= project.epoching.numcond
    disp('ERROR in project_structure: number of conditions do not coincide !!! please verify')
end

project.epoching.handedness_swap        = 'l';                        % G18: 'off' | 'l' | 'r' : swap subject during epoching according to handedness (l or r). also set project.operations.do_handedness_epochs

%% ======================================================================================================
% H:    SUBJECTS
% ======================================================================================================
if isfield(project, 'subjects')
    if isfield(project.subjects, 'data')
        project.subjects = rmfield(project.subjects, 'data');
    end
end

project.subjects.baseline_file              = '';
project.subjects.baseline_file_interval_s   = '';

% non c'è completa coerenza con il valore gruppo definito a livello di singolo soggetto, e le liste presenti in groups
project.subjects.data(1)  = struct('name', 'CC_01_vittoria', 'group', 'CC', 'age', 13, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(2)  = struct('name', 'CC_03_anna',     'group', 'CC', 'age', 12, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(3)  = struct('name', 'CC_04_giacomo',  'group', 'CC', 'age', 8,  'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(4)  = struct('name', 'CC_05_stefano',  'group', 'CC', 'age', 9,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(5)  = struct('name', 'CC_06_giovanni', 'group', 'CC', 'age', 6,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(6)  = struct('name', 'CC_07_davide',   'group', 'CC', 'age', 11, 'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(7)  = struct('name', 'CC_08_jonathan', 'group', 'CC', 'age', 8,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(8)  = struct('name', 'CC_10_chiara',   'group', 'CC', 'age', 11, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(9)  = struct('name', 'CC_11_isabella', 'group', 'CC', 'age', 6,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(10) = struct('name', 'CC_12_agnese',   'group', 'CC', 'age', 11, 'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(11) = struct('name', 'CC_13_carlotta', 'group', 'CC', 'age', 9,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(12) = struct('name', 'CC_14_jenny',    'group', 'CC', 'age', 6,  'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(13) = struct('name', 'CC_16_sofia',    'group', 'CC', 'age', 8,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(14) = struct('name', 'CC_17_mattia',   'group', 'CC', 'age', 7,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);


project.subjects.data(15) = struct('name', 'CP_01_riccardo', 'group', 'CP', 'age', 6,  'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(16) = struct('name', 'CP_02_ester',    'group', 'CP', 'age', 8,  'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(17) = struct('name', 'CP_03_sara',     'group', 'CP', 'age', 11, 'gender', 'f', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(18) = struct('name', 'CP_04_matteo',   'group', 'CP', 'age', 10, 'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(19) = struct('name', 'CP_05_gregorio', 'group', 'CP', 'age', 6,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(20) = struct('name', 'CP_06_fernando', 'group', 'CP', 'age', 8,  'gender', 'm', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(21) = struct('name', 'CP_07_roberta',  'group', 'CP', 'age', 9,  'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(22) = struct('name', 'CP_08_mattia',   'group', 'CP', 'age', 7,  'gender', 'm', 'handedness', 'r', 'bad_ch', []);
project.subjects.data(23) = struct('name', 'CP_09_alessia',  'group', 'CP', 'age', 10, 'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(24) = struct('name', 'CP_10_livia',    'group', 'CP', 'age', 10, 'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(25) = struct('name', 'CP_13_ariana',   'group', 'CP', 'age', 11, 'gender', 'f', 'handedness', 'l', 'bad_ch', []);
project.subjects.data(26) = struct('name', 'CP_14_sofia',    'group', 'CP', 'age', 7,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);


% DISCARDED
% project.subjects.data(X)  = struct('name', 'CC_02_fabio',    'group', 'CC', 'age', 12, 'gender', 'm', 'handedness', 'r', 'bad_ch', []);
% project.subjects.data(XX)  = struct('name', 'CC_09_antonella','group', 'CC', 'age', 9,  'gender', 'f', 'handedness', 'r', 'bad_ch', []);

project.subjects.data(21).bad_ch    = {'P1'};       ... 'CP_07_roberta'
project.subjects.data(17).bad_ch    = {'P1'};       ... 'CP_03_sara'
project.subjects.data(18).bad_ch    = {'Iz'};       ... 'CP_04_matteo'
project.subjects.data(5).bad_ch     = {'PO3'};      ... 'CC_06_giovanni'
% project.subjects.data(XX).bad_ch     = {'POz'};   ...'CC_09_antonella'



project.subjects.list               = {project.subjects.data.name};
project.subjects.numsubj            = length(project.subjects.list);

project.subjects.group_names        = {'CC', 'CP'};
project.subjects.groups             = {{'CC_01_vittoria', 'CC_03_anna', 'CC_04_giacomo', 'CC_05_stefano', 'CC_06_giovanni', 'CC_07_davide', 'CC_08_jonathan','CC_10_chiara','CC_11_isabella','CC_12_agnese','CC_13_carlotta','CC_14_jenny','CC_16_sofia','CC_17_mattia'}; ...
                                       {'CP_01_riccardo','CP_02_ester', 'CP_03_sara', 'CP_04_matteo', 'CP_05_gregorio', 'CP_06_fernando', 'CP_07_roberta', 'CP_08_mattia', 'CP_09_alessia', 'CP_10_livia','CP_13_ariana','CP_14_sofia'} ...
                                      };


%% ======================================================================================================
% I:    STUDY
% ======================================================================================================
project.study.filename = [project.name project.study_suffix '.study'];


% structures that associates conditions' file with (multiple) factor(s)
if isfield(project, 'study')
    if isfield(project.study, 'factors')
        project.study = rmfield(project.study, 'factors');
    end
end
project.study.factors = [];

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
project.study.precompute.do_ersp                = 'on';
project.study.precompute.do_erpim               = 'on';
project.study.precompute.do_spec                = 'on';

% project.study.precompute.erp                    = {'interp','off','allcomps','on','erp'  ,'on','erpparams'  ,{},'recompute','off'};
% project.study.precompute.erpim                  = {'interp','off','allcomps','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'recompute','off'};
% project.study.precompute.spec                   = {'interp','off','allcomps','on','spec' ,'on','specparams' ,{'specmode' 'fft','freqs' project.study.ersp.freqout_analysis_interval},'recompute','off'};
% project.study.precompute.ersp                   = {'interp','off' ,'allcomps','on','ersp' ,'on','erspparams' ,{'cycles' project.study.ersp.cycles,  'freqs', project.study.ersp.freqout_analysis_interval, 'timesout', project.study.ersp.timeout_analysis_interval.s*1000, ...
%                                                    'freqscale','linear','padratio',project.study.ersp.padratio, 'baseline',[project.epoching.bc_st.s*1000 project.epoching.bc_end.s*1000] },'itc','on','recompute','off'};

project.study.precompute.erp                    = struct('interp','off','allcomps','on','erp'  ,'on','erpparams'  ,{},'recompute','off');
project.study.precompute.erpim                  = struct('interp','off','allcomps','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'recompute','off');
project.study.precompute.spec                   = struct('interp','off','allcomps','on','spec' ,'on','specparams' ,{'specmode' 'fft','freqs' project.study.ersp.freqout_analysis_interval},'recompute','off');
project.study.precompute.ersp                   = struct('interp','off' ,'allcomps','on','ersp' ,'on','erspparams' ,{'cycles' project.study.ersp.cycles,  'freqs', project.study.ersp.freqout_analysis_interval, 'timesout', project.study.ersp.timeout_analysis_interval.s*1000, ...
                                                   'freqscale','linear','padratio',project.study.ersp.padratio, 'baseline',[project.epoching.bc_st.s*1000 project.epoching.bc_end.s*1000] },'itc','on','recompute','off'};

%% ======================================================================================================
% L:    DESIGN
% ======================================================================================================
project.design(1)=struct('name', 'all_cond', 'factor1_name', 'condition', 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', 'group'  , 'factor2_levels', [], 'factor2_pairing', 'off');
project.design(1).factor1_levels={'AO', 'AOCS', 'AOIS'};
project.design(1).factor2_levels={'CC','CP'};

project.design(2)=struct('name', 'ao_aocs', 'factor1_name', 'condition', 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', 'group'  , 'factor2_levels', [], 'factor2_pairing', 'off');
project.design(2).factor1_levels={'AO', 'AOCS'};
project.design(2).factor2_levels={'CC','CP'};

project.design(3)=struct('name', 'ao_aois', 'factor1_name', 'condition', 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', 'group'  , 'factor2_levels', [], 'factor2_pairing', 'off');
project.design(3).factor1_levels={'AO', 'AOIS'};
project.design(3).factor2_levels={'CC','CP'};

project.design(4)=struct('name', 'aocs_aois', 'factor1_name', 'condition', 'factor1_levels', [] , 'factor1_pairing', 'on', 'factor2_name', 'group'  , 'factor2_levels', [], 'factor2_pairing', 'off');
project.design(4).factor1_levels={'AOCS', 'AOIS'};
project.design(4).factor2_levels={'CC','CP'};

%% ======================================================================================================
% M:    STATS
% ======================================================================================================
% ERP
project.stats.erp.pvalue=0.025; ...0.01;                % level of significance applied in ERP statistical analysis
project.stats.erp.num_permutations=20000;               % number of permutations applied in ERP statistical analysis
project.stats.erp.num_tails= 2;
project.stats.eeglab.erp.method='bootstrap';            % method applied in ERP statistical analysis
project.stats.eeglab.erp.correction='fdr';              % multiple comparison correction applied in ERP statistical analysis

% ERSP
project.stats.ersp.pvalue=0.05;               % level of significance applied in ERSP statistical analysis
project.stats.ersp.num_permutations=20000;              % number of permutations applied in ERP statistical analysis
project.stats.ersp.num_tails=2;
project.stats.ersp.decimation_factor_times_tf=10;
project.stats.ersp.decimation_factor_freqs_tf=10;
project.stats.ersp.tf_resolution_mode='continuous';     % 'continuous'; 'decimate_times';'decimate_freqs';'decimate_times_freqs';'tw_fb';
project.stats.ersp.measure='dB';                        % 'Pfu';  dB decibel, Pfu, (A-R)/R * 100 = (A/R-1) * 100 = (10^.(ERSP/10)-1)*100 variazione percentuale definita da pfursheller

project.stats.ersp.do_narrowband                    = 'ref'; % on|off enable/disable the adjustment of spectral band for each subject
project.stats.ersp.narrowband.group_tmin            = 100;  % lowest time of the time windows considered to select the narrow band. if empty, consider the start of the epoch
project.stats.ersp.narrowband.group_tmax            = 900; % highest time of the time windows considered to select the narrow band. if empty, consider the end of the epoch
project.stats.ersp.narrowband.dfmin                 =  1;   % low variation in Hz from the barycenter frequency
project.stats.ersp.narrowband.dfmax                 =  1;   % high variation in Hz from the barycenter frequency
project.stats.ersp.narrowband.which_realign_measure = {'auc','auc','auc','auc','auc'}; % min |max |auc for each band, select the frequency with the maximum or the minumum ersp or the largest area under the curve to reallign the narrowband
project.stats.ersp.narrowband.which_realign_param   = {'fnb', 'fnb', 'fnb', 'fnb', 'fnb'};
project.stats.eeglab.ersp.method='bootstrap';           % method applied in ERP statistical analysis
project.stats.eeglab.ersp.correction='none';             % multiple comparison correction applied in ERP statistical analysis

% BRAINSTORM 
project.stats.brainstorm.pvalue=0.025; ...0.01;         % level of significance applied in ERSP statistical analysis
project.stats.brainstorm.correction='fdr';              % multiple comparison correction applied in ERP statistical analysis

% SPM
project.stats.spm.pvalue=0.025; ...0.01;                % level of significance applied in ERSP statistical analysis
project.stats.spm.correction='fwe';                     % multiple comparison correction applied in ERP statistical analysis

% for each design of interest, perform or not statistical analysis of erp
project.stats.show_statistics_list={'on','on','on','on','on','on','on','on'};   

%% ======================================================================================================
% N:    POSTPROCESS
% ======================================================================================================

% ERP

project.postprocess.erp.mode.continous              = struct('time_resolution_mode', 'continuous', 'peak_type', 'off'          , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.erp.mode.tw_group_noalign       = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.erp.mode.tw_group_align         = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'on',  'tw_stat_estimator', 'tw_extremum');
project.postprocess.erp.mode.tw_individual_noalign  = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.erp.mode.tw_individual_align    = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'on' , 'tw_stat_estimator', 'tw_extremum');


project.postprocess.erp.sel_extrema='first_occurrence';%'avg_occurrences'

project.postprocess.erp.design(1).group_time_windows(1)=struct('name','350-650'   ,'min',350  , 'max',650);
project.postprocess.erp.design(1).group_time_windows(2)=struct('name','750-2700'  ,'min',750  , 'max',2700);
project.postprocess.erp.design(1).group_time_windows(3)=struct('name','350-2700'  ,'min',350  , 'max',2700);

project.postprocess.erp.design(1).subject_time_windows(1)=struct('min',-100, 'max',100);
project.postprocess.erp.design(1).subject_time_windows(2)=struct('min',-100, 'max',100);
project.postprocess.erp.design(1).subject_time_windows(3)=struct('min',-100, 'max',100);

% project.postprocess.erp.roi_list={  ...
%           {'F5','F7','AF7','FT7'};  ... left IFG
%           {'F6','F8','AF8','FT8'};  ... right IFG
%           {'FC3','FC5'};            ... l PMD
%           {'FC4','FC6'};            ... r PMD    
%           {'C3'};                   ... iM1 hand
%           {'C4'};                   ... cM1 hand
%           {'Cz'};                   ... SMA
%           {'CP3','CP5','P3','P5'};  ... left IPL
%           {'CP4','CP6','P4','P6'};  ... right IPL
%           {'O1','PO3','POz','Oz'};  ... left occipital          
%           {'O2','PO4','POz','Oz'}   ... right occipital 
% 
%           %           {'CP3','P3','CP1','P1'};  ... left SPL
% %           {'CP4','P4','CP2','P2'};  ... right SPL
% %           {'T7','TP7','CP5','P5'};  ... left pSTS
% %           {'T8','TP8','CP6','P6'};  ... right pSTS          
% };
% project.postprocess.erp.roi_names={'left-ifg','right-ifg','left-PMd','right-PMd','left-SM1','right-SM1','SMA', 'left-ipl','left-occipital','right-occipital'}; ...,'right-ipl','left-spl','right-spl','left-sts','right-sts'};
%     


project.postprocess.erp.roi_list={  ...
          {'C3','C1'};              ... hSM1
          {'C4','C2'};              ... aSM1
          {'FC1','FC3'};            ... hPMd
          {'FC2','FC4'};            ... aPMd
          {'FCz','Cz'};              ... SMA
          {'F5','F7','AF7','FT7'};  ... hIF
          {'F6','F8','AF8','FT8'};  ... aIF
          {'CP3','P3'};             ... hIP
          {'CP4','P4'};             ... aIP
          {'T7','TP7','CP5','P5'};  ... h pST
          {'T8','TP8','CP6','P6'};  ... a pST           
          
};
project.postprocess.erp.roi_names={'hSM1', 'aSM1', 'hPMd', 'aPMd', 'SMA','hIF','aIF','hIP','aIP','hpST','apST'};


project.postprocess.erp.numroi=length(project.postprocess.erp.roi_list);

project.postprocess.erp.design(1).which_extrema_curve = {  ... design x roi x time_windows
                                {'max';'min';'min';'min'}; ... 
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}; ...
                                {'max';'min';'min';'min'}  ...
};


for ds=2:length(project.design)
    project.postprocess.erp.design(ds) = project.postprocess.erp.design(1);
end


% =========================================================================================================
% =========================================================================================================
% =========================================================================================================
% ERSP 
% =========================================================================================================
% =========================================================================================================
% =========================================================================================================

project.postprocess.ersp.frequency_bands(1)=struct('name','teta','min',3,'max',7,'dfmin',1,'dfmax',1,'ref_roi_list',[], 'ref_roi_name','aSM1','ref_cond', 'AO', 'ref_tw_list', [100 900], 'ref_tw_name', 'presound', 'which_realign_measure','auc');
project.postprocess.ersp.frequency_bands(2)=struct('name','mu','min',7.5,'max',13,'dfmin',1,'dfmax',1,'ref_roi_list',[], 'ref_roi_name','aSM1','ref_cond', 'AO', 'ref_tw_list', [100 900], 'ref_tw_name', 'presound', 'which_realign_measure','auc');
project.postprocess.ersp.frequency_bands(3)=struct('name', 'beta1', 'min', 13.5, 'max', 17.5,'dfmin',1,'dfmax',1,'ref_roi_list',{'C3'}, 'ref_roi_name','C3','ref_cond', 'AO', 'ref_tw_list', [100 900], 'ref_tw_name', 'post', 'which_realign_measure','auc');
project.postprocess.ersp.frequency_bands(4)=struct('name', 'beta2', 'min', 18, 'max', 22  ,'dfmin',1,'dfmax',1,'ref_roi_list',{'C3'}, 'ref_roi_name','C3','ref_cond', 'AO', 'ref_tw_list', [100 900], 'ref_tw_name', 'post', 'which_realign_measure','auc');

...project.postprocess.ersp.frequency_bands(5)=struct('name', 'mu1'  ,  'min', 7,  'max', 10  ,'dfmin',1,'dfmax',1,'ref_roi_list',{'C3'}, 'ref_roi_name','C3','ref_cond', 'AO', 'ref_tw_list', [350 850], 'ref_tw_name', 'post', 'which_realign_measure','auc');
...project.postprocess.ersp.frequency_bands(6)=struct('name', 'mu2'  ,  'min', 10.5,  'max', 12.5  ,'dfmin',1,'dfmax',1,'ref_roi_list',{'C3'}, 'ref_roi_name','C3','ref_cond', 'AO', 'ref_tw_list', [350 850], 'ref_tw_name', 'post', 'which_realign_measure','auc');



project.postprocess.ersp.frequency_bands(1).ref_roi_list = {'C2', 'C4'};
project.postprocess.ersp.frequency_bands(2).ref_roi_list = {'C2', 'C4'};
project.postprocess.ersp.frequency_bands(3).ref_roi_list = {'C2', 'C4'};
project.postprocess.ersp.frequency_bands(4).ref_roi_list = {'C2', 'C4'};
...project.postprocess.ersp.frequency_bands(5).ref_roi_list = {'C2', 'C4'};
...project.postprocess.ersp.frequency_bands(6).ref_roi_list = {'C2', 'C4'};

project.postprocess.ersp.sel_extrema                        ='first_occurrence';%'avg_occurrences'

project.postprocess.ersp.mode.continous                     = struct('time_resolution_mode', 'continuous', 'peak_type', 'off'          , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.ersp.mode.tw_group_noalign              = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.ersp.mode.tw_group_align                = struct('time_resolution_mode', 'tw'        , 'peak_type', 'group'        , 'align', 'on',  'tw_stat_estimator', 'tw_extremum');
project.postprocess.ersp.mode.tw_individual_noalign         = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'off', 'tw_stat_estimator', 'tw_mean');
project.postprocess.ersp.mode.tw_individual_align           = struct('time_resolution_mode', 'tw'        , 'peak_type', 'individual'   , 'align', 'on' , 'tw_stat_estimator', 'tw_extremum');

project.postprocess.ersp.design(1).group_time_windows(1)    = struct('name', '150-350' , 'min', 150, 'max', 350);
project.postprocess.ersp.design(1).group_time_windows(2)    = struct('name', '350-850' , 'min', 350, 'max', 850);
% project.postprocess.ersp.design(1).group_time_windows(2)    = struct('name', '350-600' , 'min', 350, 'max', 600);
% project.postprocess.ersp.design(1).group_time_windows(3)    = struct('name', '600-850', 'min', 600, 'max', 850);
    
project.postprocess.ersp.design(1).subject_time_windows(1)  = struct('min', -100, 'max', 100);
project.postprocess.ersp.design(1).subject_time_windows(2)  = struct('min', -100, 'max', 100);
% project.postprocess.ersp.design(1).subject_time_windows(3)  = struct('min', -100, 'max', 100);



% project.postprocess.ersp.roi_list={  ...
%           {'F5','F7','AF7','FT7'};  ... left IFG
%           {'F6','F8','AF8','FT8'};  ... right IFG
%           {'FC3','FC5'};            ... l PMD
%           {'FC4','FC6'};            ... r PMD    
%           {'C3'};                   ... iM1 hand
%           {'C4'};                   ... cM1 hand
%           {'Cz'};                   ... SMA
%           {'CP3','CP5','P3','P5'};  ... left IPL
%           {'CP4','CP6','P4','P6'};  ... right IPL
%           {'O1','PO3','POz','Oz'};  ... left occipital          
%           {'O2','PO4','POz','Oz'}   ... right occipital 
% 
%           %           {'CP3','P3','CP1','P1'};  ... left SPL
% %           {'CP4','P4','CP2','P2'};  ... right SPL
% %           {'T7','TP7','CP5','P5'};  ... left pSTS
% %           {'T8','TP8','CP6','P6'};  ... right pSTS          
% };
% project.postprocess.ersp.roi_names={'left-ifg', 'right-ifg', 'left-PMd', 'right-PMd', 'left-SM1', 'right-SM1', 'SMA', 'left-ipl', 'right-ipl', 'left-occipital', 'right-occipital'}; ...,'right-ipl','left-spl','right-spl','left-sts','right-sts'};

project.postprocess.ersp.roi_list={  ...
          {'C3','C1'};              ... hSM1
          {'C4','C2'};              ... aSM1
%           {'FC1','FC3'};            ... hPMd
%           {'FC2','FC4'};            ... aPMd
%           {'FCz','Cz'};              ... SMA
           {'F5','F7','AF7','FT7'};  ... hIF
           {'F6','F8','AF8','FT8'};  ... aIF
           {'CP3','P3'};             ... hIP
           {'CP4','P4'};             ... aIP
           {'T7','TP7','CP5','P5'};  ... h pST
           {'T8','TP8','CP6','P6'};  ... a pST           
};
...project.postprocess.ersp.roi_names={'hSM1', 'aSM1', 'hPMd', 'aPMd', 'SMA','hIF','aIF','hIP','aIP','hpST','apST'};
project.postprocess.ersp.roi_names={'hSM1', 'aSM1', 'hIF','aIF','hIP','aIP','hpST','apST'};


project.postprocess.ersp.numroi=length(project.postprocess.ersp.roi_list);

% extreme to be searched in the continuous curve ( NON time-window mode)
project.postprocess.ersp.design(1).which_extrema_curve_continuous = {     .... design x roi x freq band x time window
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                    
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'};...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                    
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                    
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };
                                    {... roi
                                        {'max'};... frequency band
                                        {'min'};...
                                        {'min'};...
                                        {'min'}; ...
                                        {'min'}...
                                    };                                   
};

% extreme to be searched in each time window (time-window mode)
project.postprocess.ersp.design(1).which_extrema_curve_tw = {     .... design x roi x freq band x time window
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
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
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
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
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
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };                                   
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
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
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'}...
                                    };                                   
                                    {... roi
                                        {'max';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min'}; ...
                                        {'max';'min';'min';'min'};...
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



project.postprocess.ersp.design(1).which_extrema_curve      = {     .... design x roi x freq band x time window
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };                                    
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };                                    
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };                                    
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };                                   
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };                                   
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };                                   
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };
                                    {... roi
                                        {'max';'min';'min';'min';'min'};... frequency band
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'};...
                                        {'max';'min';'min';'min';'min'}...
                                    };                                       
};


 project.postprocess.ersp.design(1).deflection_polarity_list = {  ... design x roi x frequency band x time_windows
                               {... roi
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                               {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                               {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                               {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                               {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                                {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               };...
                               {...
                                {'positive';'positive';'positive';'positive';'positive';'negative'}; ... frequency band
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                                {'negative';'negative';'negative';'negative';'negative';'negative'}; ... 
                               } ...                               
};

project.postprocess.ersp.design(1).min_duration = 10;


for ds=2:length(project.design)
    project.postprocess.ersp.design(ds) = project.postprocess.ersp.design(1);
end

project.postprocess.ersp.frequency_bands_list={}; ... writes something like {[4,8];[8,12];[14,20];[20,32]};
for fb=1:length(project.postprocess.ersp.frequency_bands)
    bands=[project.postprocess.ersp.frequency_bands(fb).min, project.postprocess.ersp.frequency_bands(fb).max];
    project.postprocess.ersp.frequency_bands_list=[project.postprocess.ersp.frequency_bands_list; {bands}];
end
project.postprocess.ersp.frequency_bands_names={project.postprocess.ersp.frequency_bands.name};




%% ======================================================================================================
% O:    RESULTS DISPLAY
% ======================================================================================================

% CURVES

% ERP
project.results_display.filter_freq=10;         %frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data

project.results_display.erp.time_smoothing=10;                 % frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
project.results_display.erp.time_range.s        = [project.study.erp.tmin_analysis.s project.study.erp.tmax_analysis.s];       % time range for erp representation

project.results_display.ylim_plot=[-2.5 2.5];           %y limits (uV)for the representation of ERP

project.results_display.erp.compact_plots='on';                             % display (curve) plots with different conditions/groups on the same plots
project.results_display.erp.single_subjects='off';                          % display patterns of the single subjcts (keeping the average pattern)
project.results_display.erp.compact_h0='on';                                % display parameters for compact plots
project.results_display.erp.compact_v0='on';
project.results_display.erp.compact_sem='off';
project.results_display.erp.compact_stats='on';
project.results_display.erp.compact_display_xlim=[];
project.results_display.erp.compact_display_ylim=[];
project.results_display.erp.masked_times_max = []; % number of ms....all the timepoints before this values are not considered for statistics
project.results_display.erp.set_caxis_topo_tw=[];
project.results_display.erp.display_only_significant_curve='on'; %on
project.results_display.erp.display_only_significant_topo='on'; %on
project.results_display.erp.display_only_significant_topo_mode='surface'; %'electrodes';
project.results_display.erp.compact_plots_topo='off'; 
project.results_display.erp.display_compact_topo_mode='boxplot'; ...'boxplot'; ... 'errorbar'
project.results_display.erp.display_compact_show_head= 'off';        % 'on'|'off'
project.results_display.erp.do_plots='on';        %
project.results_display.erp.show_text='on';         %


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
project.results_display.ersp.stat_time_windows_list             = [];           % time windows in seconds [tw1_start,tw1_end; tw2_start,tw2_end] considered for statistics
project.results_display.ersp.masked_times_max = [0]; % number of ms....all the timepoints before this values are not considered for statistics
project.results_display.ersp.set_caxis_tf=[];
project.results_display.ersp.set_caxis_topo_tw_fb=[];
project.results_display.ersp.display_only_significant_curve='on'; %on % the threshold is always set, however you can choose to display only the significant p values or all the p values (in the curve plots the threshold is added as a landmark)
project.results_display.ersp.display_only_significant_topo='on'; %on
project.results_display.ersp.display_only_significant_topo_mode='surface'; %'electrodes';
project.results_display.ersp.display_only_significant_tf='on'; %on
project.results_display.ersp.display_only_significant_tf_mode='binary'; ....'thresholded'; % 'binary';
    
project.results_display.ersp.display_pmode                      = 'raw_diff';   % 'raw_diff' | 'abs_diff'| 'standard'; plot p values in a time-frequency space. 'raw_diff': for 2 levels factors, show p values multipled with the raw difference between the average of level 1 and the average of level 2; 'abs_diff': for 2 levels factors, show p values multipled with the difference betwenn the abs of the average of level 1 and the abs of the average of level 2 (more focused on the strength of the spectral variatio with respect to the sign of the variation); 'standard': the standard mode of EEGLab, only indicating a significant difference between levels, without providing information about the sign of the difference, it's the only representation avalillable for factors with >2 levels (for which a difference cannot be simply calculated). 

project.results_display.ersp.compact_plots_topo                 = 'on';         % 'on'|'off' for each time window, plot compact topographic plot with bot topographic location of the roi and multiple comparisons between conditions OR standard EEGLAB topographic distribution plots (consider the wolwe scalp)
project.results_display.ersp.display_compact_topo_mode          = 'boxplot';    % 'boxplot'|'errorbar' display boxplot with single subjects represented by red points (complete information about distribution) or error bar (syntetic standard representation)
project.results_display.ersp.display_compact_show_head          = 'off';        %'on'|'off' show the topographical representation of the roi (the head with the channels of the roi in red and te others in black)
project.results_display.ersp.do_plots                           = 'on';        %
project.results_display.ersp.show_text                          = 'on';         %

project.results_display.ersp.z_transform                        = 'on';         % 'on'|'off' z-transform data data for each roi, band and tw to allow to plot all figures on the same scale
project.results_display.ersp.which_error_measure                = 'sem';        % 'sd'|'sem'; which error measure is adopted in the errorbar: standard deviation or standard error



%% ======================================================================================================
% P:    EXPORT
% ======================================================================================================
export.r.bands=[];
for nband=1:length(project.postprocess.ersp.frequency_bands_names)
    export.r.bands(nband).freq=project.postprocess.ersp.frequency_bands_list{nband};
    export.r.bands(nband).name=project.postprocess.ersp.frequency_bands_names{nband};
end

%% ======================================================================================================
% Q:    CLUSTERING
% ======================================================================================================
project.clustering.channels_file_name='cluster_projection_channel_locations.loc';
project.clustering.channels_file_path=''; ... later set by define_paths

%% ======================================================================================================
% R:    BRAINSTORM
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

for fb=1:length(project.postprocess.ersp.frequency_bands)
    project.brainstorm.analysis_bands{fb,1} = project.postprocess.ersp.frequency_bands(fb).name;
    project.brainstorm.analysis_bands{fb,2} = [num2str(project.postprocess.ersp.frequency_bands(fb).min) ', ' num2str(project.postprocess.ersp.frequency_bands(fb).max)];
    project.brainstorm.analysis_bands{fb,3} = 'mean';
end
project.brainstorm.analysis_bands = {project.brainstorm.analysis_bands};
                                  
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
project.epoching.bc_st.ms   = project.epoching.bc_st.s*1000;            % baseline correction start latency
project.epoching.bc_end.ms  = project.epoching.bc_end.s*1000;           % baseline correction end latency
project.epoching.epo_st.ms  = project.epoching.epo_st.s*1000;             % epochs start latency
project.epoching.epo_end.ms = project.epoching.epo_end.s*1000;             % epochs end latency

...project.epoching.baseline_mark.baseline_begin_target_marker_delay.ms = project.epoching.baseline_mark.baseline_begin_target_marker_delay.s *1000; % delay  between target and baseline begin marker to be inserted

%  ********* /DERIVED DATA *****************************************************************


% ======================================================================================================
% POSTPROCESS
% ======================================================================================================

%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
for fb=1:length(project.postprocess.ersp.frequency_bands)
    project.postprocess.eeglab.frequency_bands_list{fb,1}=[project.postprocess.ersp.frequency_bands(fb).min,project.postprocess.ersp.frequency_bands(fb).max];
end
project.postprocess.eeglab.frequency_bands_names = {project.postprocess.ersp.frequency_bands.name};%  ********* /DERIVED DATA  *****************************************************************


% ERP
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.study.erp.tmin_analysis.ms                  = project.study.erp.tmin_analysis.s*1000;
project.study.erp.tmax_analysis.ms                  = project.study.erp.tmax_analysis.s*1000;
project.study.erp.ts_analysis.ms                    = project.study.erp.ts_analysis.s*1000;
project.study.erp.timeout_analysis_interval.ms      = project.study.erp.timeout_analysis_interval.s*1000;
%  ********* /DERIVED DATA  *****************************************************************


% ERSP
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.study.ersp.tmin_analysis.ms                 = project.study.ersp.tmin_analysis.s*1000;
project.study.ersp.tmax_analysis.ms                 = project.study.ersp.tmax_analysis.s*1000;
project.study.ersp.ts_analysis.ms                   = project.study.ersp.ts_analysis.s*1000;
project.study.ersp.timeout_analysis_interval.ms     = project.study.ersp.timeout_analysis_interval.s*1000;
%  ********* /DERIVED DATA  *****************************************************************


% ======================================================================================================
% RESULTS DISPLAY
% ======================================================================================================
      
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.results_display.erp.time_range.ms           = project.results_display.erp.time_range.s*1000;
project.results_display.ersp.time_range.ms          = project.results_display.ersp.time_range.s*1000;
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
% eeglab_derived_parameters_project(project)
% eeglab_check_project(project)
