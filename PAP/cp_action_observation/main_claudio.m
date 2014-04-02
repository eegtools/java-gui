% to be edited according to calling PC local file system
local_projects_data_path='G:\';
svn_local_path='G:\behaviourPlatform_svn\EEG_Tools';
plugins_path='G:\groups\behaviour_lab\Projects\EEG_tools\matlab_toolbox';
global_scripts_path='G:\behaviourPlatform_svn\EEG_Tools\global_scripts';

os = system_dependent('getos');
if  strncmp(os,'Linux',2)
    local_projects_data_path='/data/projects';
    svn_local_path='/data/behavior_lab_svn/behaviourPlatform/EEG_Tools';
    plugins_path='/mnt/behaviour_lab/Projects/EEG_tools/matlab_toolbox';

end

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
pre_epoching_input_file_name = '_raw_mc';                              ... or '_raw_cudaica' if ICA correction has been applied
acquisition_system='BIOSEMI';
subjects_list={'CC_02_fabio'};
%subjects_list={'CC_01_vittoria', 'CC_02_fabio', 'CC_03_anna', 'CP_01_riccardo', 'CP_02_ester', 'CP_03_sara'};   
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
do_import=0;
do_patch_triggers=0;
do_auto_pauses_removal=0;
do_ica=0; 
do_ica_review=1;
do_epochs=0;
do_singlesubjects_betaband_comparison=0;


% do group analysis
do_study=1;
do_design=0;
do_study_invert_polarity=0;
do_study_invert_polarity2=0;
do_study_compute_channels_measures=0;
do_study_plot_roi_erp=0;
do_study_plot_roi_tf=0;
do_eeglab_study_export_erp_r=0;






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
        eeglab_subject_import_event(project_settings, fullfile(bdf_path, [subjects_list{subj} '.bdf']), epochs_path, acquisition_system, nch_eeg, [],[],[],polygraphic_channels);
        file_name=fullfile(epochs_path, [subjects_list{subj} '_raw.set']);
        eeglab_subject_emgextraction_epoching(project_settings, file_name, emg_output_postfix_name, emg_epochs_path);
    end
end

if do_patch_triggers
    % patch, add a pause trigger every question trigger
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        %   1) if not present, add start trigger 1 sec before the first trigger
        
        %   2) add:  1) a pause trigger value at the same latency of a question_trigger_value 
        %       2) a resume trigger 1sec before the event following the question trigger
        %eeglab_subject_events_add_event_at_code_and_before_next(fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']), 50, pause_trigger_value, resume_trigger_value, 1, project_settings);
        
        %   3) add a pause trigger value at the same latency of a question_trigger_value
        eeglab_subject_events_add_eve1_pre_eve2(project_settings, file_name,{question_trigger_value},{resume_trigger_value},10000000,pause_trigger_value)
    end
end

if do_auto_pauses_removal
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        %eeglab_subject_events_remove_upto_triggercode(project_settings, file_name, start_experiment_trigger_value);
        pause_resume_errors=eeglab_subject_events_check_2triggers_orders(project_settings, file_name,pause_trigger_value, resume_trigger_value);
        if isempty(pause_resume_errors)
            eeglab_subject_remove_pauses(project_settings, file_name, pause_trigger_value, resume_trigger_value);
        else
            disp('errors in pause/resume trigger sequence');
            pause_resume_errors
        end
    end
end

if do_ica
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_ica(project_settings, file_name, epochs_path, nch_eeg, 'cudaica');
    end
end
if do_ica_review
    % calculate IC which show intervals outside Xtimes their standard deviations
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_remove_segments_ica(project_settings, file_name, 3, 5);
    end
end

%==================================================================================
if do_epochs
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_epoching_baseline_remove(project_settings, file_name, epochs_path);
    end
end
%==================================================================================
if do_singlesubjects_betaband_comparison
    for subj=1:length(subjects_list)
        cond1=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_control' '.set']);
        cond2=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_AO' '.set']);
        cond3=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_AOCS' '.set']);
        cond4=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_AOIS' '.set']);
        %eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond1, electrode2inspect, stat_threshold);
        %eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond2, electrode2inspect, stat_threshold);
        %eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond3, electrode2inspect, stat_threshold);
        %eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond4, electrode2inspect, stat_threshold);
        eeglab_subject_ft_plot_2conditions(project_settings, cond2,cond1, electrode2inspect, stat_threshold);
        eeglab_subject_ft_plot_2conditions(project_settings, cond3,cond2, electrode2inspect, stat_threshold);
        eeglab_subject_ft_plot_2conditions(project_settings, cond3,cond1, electrode2inspect, stat_threshold);
        eeglab_subject_ft_plot_2conditions(project_settings, cond3,cond4, electrode2inspect, stat_threshold);
    end
end
%==================================================================================
%==================================================================================
% GROUP ANALYSIS
%==================================================================================
%==================================================================================

if do_study
    pre_epoching_suffix='';
    eeglab_study_create(project_settings,protocol_name, subjects_list, conditions_list, analysis_name,  pre_epoching_suffix, epochs_path);
end

if do_design
    eeglab_study_define_design(project_settings,fullfile(epochs_path, [protocol_name, '.study']), designs_list);
end


if do_study_compute_channels_measures   
    tot_des=size(designs_list,1);
    for design_num=1:tot_des %for design_num=7%1:tot_des 
        eeglab_study_compute_channels_measures(project_settings,fullfile(epochs_path, [protocol_name, '.study']), design_num, 'ALL');
    end
end

if do_study_plot_roi_erp
    %lista di design da selezionare nello studio
    list_sel_designs=[1];
    %lista di design da selezionare nelle liste di project_config (per
    %graficare solo alcuni design modificare solo questo)
    sel_designs=[1];
    for design_num=1:length(sel_designs)        
        eeglab_study_plot_roi_erp(project_settings,fullfile(epochs_path, [protocol_name, '.study']), list_sel_designs(sel_designs(design_num)), roi_list,time_windows_list{sel_designs(design_num)}, show_statistics_list{sel_designs(design_num)});

    end
end


if do_study_plot_roi_tf
    %lista di design da selezionare nello studio
    list_sel_designs=[2];
    %lista di design da selezionare nelle liste di project_config (per
    %graficare solo alcuni design modificare solo questo)
    sel_designs=[1];
    for design_num=1:length(sel_designs)        
        eeglab_study_plot_roi_tf(project_settings,fullfile(epochs_path, [protocol_name, '.study']), list_sel_designs(sel_designs(design_num)),time_windows_list{sel_designs(design_num)},frequency_bands_list);

    end
end



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






