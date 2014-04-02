% to be edited according to calling PC local file system
local_projects_data_path='/data/projects';
svn_local_path='/data/behavior_lab_svn/behaviourPlatform/EEG_Tools';
%plugins_path='/mnt/behaviour_lab/Projects/EEG_tools/matlab_toolbox';
plugins_path='/data/matlab';
%==================================================================================
%==================================================================================
% 1 x 2 design: control, AO  : action vs no_action
% 1 x 3 design: AO, AOCS, AOIS : "paired-ANOVA" on sound effect
%                    
% four posthoc contrasts:   p1) control     vs AO
%                           p2) AO          vs AOCS
%                           p3) AO          vs AOIS
%                           p4) AOCS        vs AOIS
%==================================================================================
% data analysis:
% visual inspection in brainvision, manually removing part of continous data affected by strong artifacts.
% continous data were filtered 0.1-45 Hz, downsampled @ 250 Hz, ocular artifact automatically were removed by an ICA approach and finally exported in binary format
% continous data were imported in EEGLAB, referenced to CAR, baseline corrected (common to all conditions) then epoched and saved as SET (one for each condition)
% epoched data were processed in EEGLAB for TIMEFREQUENCY analysis
%       .............. TODO ........................
%       claudio aggiungi dettagli sull'analisi fatta
%       ............................................
%       ............................................
%======================= PROJECT DATA start here ==================================
protocol_name='cp_action_observation';                  ... must correspond to brainstorm db name
project_folder='cp_action_observation';                 ... must correspond to 'local_projects_data_path' subfolder name
conf_file_name='project_config.m';
db_folder_name='bst_db';                                ... must correspond to db folder name contained in 'project_folder'    
analysis_name='raw';                                    ... subfolder containing the current analysis type (refers to EEG device input data type)
pre_epochs_input = '_raw';                              ... or '_raw_cudaica' if ICA correction has been applied
acquisition_system='BIOSEMI';
subjects_list={'AC_07_diego_emg', 'AC_08_marco_emg', 'AC_09_michiv_emg','CC_01_vittoria','CC_01_vittoria_2','CC_01_vittoria_emg',}; ..., '06_alby'};
% subjects_list={'AC_03_vale', 'AC_04_danli', 'AC_05_miki','AC_06_alby'. 'AC_07_diego', 'AC_08_marco', 'AC_09_michiv'}; ... for debugging
numsubj=length(subjects_list);
stat_correction = 'fdr';
stat_threshold = 0.01;
electrode2inspect='C4';
% ======= TF PARAMS ===================================================================
brainstorm_analysis_bands={{'teta', '4, 8', 'mean'; 'mu', '8, 13', 'mean'; 'beta1', '14, 20', 'mean'; 'beta2', '20, 32', 'mean'}};
brainstorm_analysis_times=[]; ... {{'t-4', '-0.4, -0.304', 'mean'; 't-3', '-0.3, -0.204', 'mean'; 't-2', '-0.2, -0.104', 'mean'; 't-1', '-0.1, -0.004', 'mean'; 't1', '0.0, 0.096', 'mean'; 't2', '0.1, 0.1960', 'mean'; 't3', '0.2, 0.2960', 'mean'; 't4', '0.3, 0.3960', 'mean'; 't5', '0.4, 0.4960', 'mean'; 't6', '0.5, 0.5960', 'mean'; 't7', '0.6, 0.696', 'mean'; 't8', '0.7, 0.796', 'mean'; 't9', '0.8, 0.896', 'mean'; 't10', '0.9, 0.996', 'mean'}};
%==================================================================================
% ======= OPERATIONS LIST =========================================================
do_import=1;
do_ica=0;   
do_epochs=0;
do_epochs_ica=0;
do_tf=0;
do_singlesubjects_betaband_comparison=0;
do_group_analysis=0;
do_process_stats=0;           
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================== S T A R T ==================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
global_scripts_path=fullfile(svn_local_path, 'global_scripts');
addpath(global_scripts_path);
define_paths    

% load configuration file
[path,name_noext,ext] = fileparts(project_settings);
addpath(path);    eval(name_noext);
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end
if do_import
    for subj=1:length(subjects_list)
        eeglab_subject_import_event(fullfile(bdf_path, [subjects_list{subj} '.bdf']), epochs_path, project_settings, acquisition_system, nch_eeg);
    end
end

if do_ica
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(subjects_list)
        eeglab_subject_cudaica(fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '.set']), project_settings);
    end
end

if do_epochs
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(subjects_list)
        eeglab_subject_epoching(fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '.set']), project_settings);
    end
end

if do_epochs_ica
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(subjects_list)
        eeglab_subject_epochs_cudaica(fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '.set']), project_settings);
    end
end
%==================================================================================
if do_tf
    cnt=1;
    arr_epochs_sets=cell(1,numsubj*length(name_cond));
    for nsubj=1:numsubj
        for cond=1:length(name_cond)
            arr_epochs_sets{cnt}=[subjects_list{nsubj} '_' analysis_name '_' name_cond{cond} '.set'];
            cnt=cnt+1;
        end
    end    
    %for each epochs set file (subject and condition) calculate and save time frequency representation of all channels 
    for nset=1:length(arr_epochs_sets)
        tf_set([epochs_path arr_epochs_sets{nset}], tf_path, project_settings);
    end
end
%==================================================================================
if do_singlesubjects_betaband_comparison
    for subj=1:length(subjects_list)
        cond1=fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '_control' '.set']);
        cond2=fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '_AO' '.set']);
        cond3=fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '_AOCS' '.set']);
        cond4=fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '_AOIS' '.set']);
        eeglab_subject_plot_tf_onecondition_vs_baseline(cond1, electrode2inspect, project_settings, stat_threshold);
        eeglab_subject_plot_tf_onecondition_vs_baseline(cond2, electrode2inspect, project_settings, stat_threshold);
        eeglab_subject_plot_tf_onecondition_vs_baseline(cond3, electrode2inspect, project_settings, stat_threshold);
        eeglab_subject_plot_tf_onecondition_vs_baseline(cond4, electrode2inspect, project_settings, stat_threshold);
        eeglab_subject_plot_tf_2conditions(cond1,cond2, electrode2inspect, project_settings, stat_threshold);
        eeglab_subject_plot_tf_2conditions(cond1,cond3, electrode2inspect, project_settings, stat_threshold);
        eeglab_subject_plot_tf_2conditions(cond3,cond4, electrode2inspect, project_settings, stat_threshold);
    end
end
%==================================================================================
%==================================================================================
% GROUP ANALYSIS
%==================================================================================
%==================================================================================


%==================================================================================
%==================================================================================
% STATS
%==================================================================================
%==================================================================================


%==================================================================================
%==================================================================================
% PARSE RESULTS
%==================================================================================
%==================================================================================

