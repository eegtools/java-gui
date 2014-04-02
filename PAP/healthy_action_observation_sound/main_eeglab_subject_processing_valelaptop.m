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
%=====================================================================================================================================================================
% to be edited according to calling PC local file system
os = system_dependent('getos');
if  strncmp(os,'Linux',2)
    local_projects_data_path='/data/projects';
    eegtools_svn_local_path='/data/behavior_lab_svn/behaviourPlatform/EEG_Tools';
    plugins_path='/data/matlab_toolbox';
else
    local_projects_data_path='C:\Users\pippo\Documents\behaviourPlatform@local';
    eegtools_svn_local_path='C:\Users\pippo\Documents\behaviourPlatform@svn\EEG_Tools';
    plugins_path='C:\Users\pippo\Documents\matlab_toolbox';
end

%=====================================================================================================================================================================
% PROJECT DATA 
%=====================================================================================================================================================================
project_folder='healthy_action_observation_sound';      ... must correspond to 'local_projects_data_path' subfolder name
... conf_file_name='project_config.m';
conf_file_name='project_config_execution.m';
%=====================================================================================================================================================================
% load configuration file
%=====================================================================================================================================================================
project_settings=fullfile(eegtools_svn_local_path, project_folder, conf_file_name);
[path,name_noext,ext] = fileparts(project_settings);
addpath(path);    eval(name_noext);

global_scripts_path=fullfile(eegtools_svn_local_path, 'global_scripts');
addpath(global_scripts_path);
define_paths    
%=====================================================================================================================================================================
%  OVERRIDE
%=====================================================================================================================================================================
... OBSERVATION
...subjects_list={'AC_03_vale'}; ... for debugging
% subjects_list={'AC_04_dan_emg','AC_07_diego_emg','AC_09_michiv_emg','AC_11_claudio_emg'}; ..., 'AC_12_fabio', 'AC_08_marco'}; ... for debugging
% subjects_list={'AC_01_alice','AC_02_chiara','AC_03_vale', 'AC_04_dan', 'AC_05_miki','AC_06_alby_sw', 'AC_07_diego', 'AC_08_marco', 'AC_09_michiv', 'AC_10_cristina_sw','AC_11_claudio','AC_12_fabio','AC_13_emmanuel','AC_14_andrea','AC_15_alessandra'}; ... for debugging
% subjects_list={'AC_01_alice','AC_02_chiara','AC_03_vale', 'AC_04_dan', 'AC_05_miki','AC_06_alby', 'AC_07_diego', 'AC_08_marco', 'AC_09_michiv', 'AC_10_cristina','AC_11_claudio','AC_12_fabio','AC_13_emmanuel','AC_14_andrea','AC_15_alessandra'}; ... for debugging
% subjects_list={'AC_01_alice','AC_02_chiara','AC_03_vale', 'AC_04_dan', 'AC_05_miki','AC_06_alby', 'AC_07_diego', 'AC_09_michiv', 'AC_10_cristina','AC_11_claudio','AC_12_fabio','AC_13_emmanuel','AC_14_andrea','AC_15_alessandra'}; ... for debugging

... EXECUTION
subjects_to_swap={'AC_10_cristina_emg'};
subjects_list={'AC_01_alice_emg','AC_02_chiara_emg','AC_04_dan_emg','AC_10_cristina_emg','AC_11_claudio_emg','AC_12_fabio_emg','AC_13_emmanuel_emg','AC_14_andrea_emg','AC_15_alessandra_emg'}; ... for execution
...subjects_list={'AC_10_cristina_emg'}; ... ,'AC_15_alessandra_emg'}; ... for execution
epochs_path=emg_epochs_path;    

... .........................................
numsubj=length(subjects_list);
pre_epoching_input_file_name = '_raw_mc';                              
stat_threshold = 0.05;
electrode2inspect='C4';
save_figure=0;
%=====================================================================================================================================================================
% ======= OPERATIONS LIST ============================================================================================================================================
do_import=0;
do_patch_triggers=0;
do_auto_pauses_removal=0;
do_ica=0; 
do_ica_review=0;
do_epochs=0;
do_epochs_execution=1;
do_singlesubjects_betaband_comparison=0;
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================== S T A R T    P R O C E S S I N G  ==========================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end

if do_import
    for subj=1:length(subjects_list)
        eeglab_subject_import_event(project_settings, fullfile(bdf_path, [subjects_list{subj} '.bdf']), epochs_path, acquisition_system, nch_eeg, [],[],[],polygraphic_channels);
        file_name=fullfile(epochs_path, [subjects_list{subj} '_raw.set']);
        ...eeglab_subject_transform_poly(project_settings, file_name, epochs_path, nch_eeg, polygraphic_channels)
        eeglab_subject_emgextraction_epoching(project_settings, file_name, emg_output_postfix_name, emg_epochs_path);
    end
end

if do_patch_triggers
    % patch, add a pause trigger every question trigger
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        %   1) if not present, add start trigger 1 sec before the first trigger
        
        %   2) add: - a pause trigger value at the same latency of a question_trigger_value 
        %           - a resume trigger 1sec before the event following the question trigger
        eeglab_subject_events_add_event_at_code_and_before_next(project_settings, fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']), 50, pause_trigger_value, resume_trigger_value, 1);
        
        %   3) add a pause trigger value at the same latency of a question_trigger_value
        %eeglab_subject_events_add_eve1_pre_eve2(project_settings, file_name,{question_trigger_value},{resume_trigger_value},10000000000,pause_trigger_value)
    end
end

if do_auto_pauses_removal
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_events_remove_upto_triggercode(project_settings, file_name, start_experiment_trigger_value); ... return if find a boundary as first event
        eeglab_subject_events_remove_after_triggercode(project_settings, file_name, end_experiment_trigger_value); ... return if find a boundary as first event
        pause_resume_errors=eeglab_subject_events_check_2triggers_orders(project_settings, file_name,pause_trigger_value, resume_trigger_value);
        if isempty(pause_resume_errors)
            disp('====>> pause/remove triggers sequence ok....move to pause removal');
            eeglab_subject_remove_pauses(project_settings, file_name, pause_trigger_value, resume_trigger_value);
        else
            disp('====>> errors in pause/resume trigger sequence');
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
    
    for subj=1:length(subjects_to_swap)
        input_file_name=fullfile(epochs_path, [subjects_to_swap{subj} pre_epoching_input_file_name '.set']);
        output_file_name=fullfile(epochs_path, [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name '.set']);
        eeglab_subject_swap_electrodes(project_settings, input_file_name, output_file_name);
        eeglab_subject_epoching_baseline_remove(project_settings, output_file_name, epochs_path);
    end
end

if do_epochs_execution
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
     for subj=1:length(subjects_list)
         file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
         eeglab_subject_epoching_baseline_remove(project_settings, file_name, epochs_path); ..., 'mrk_code', {{'DFDR'};{'NFDR'}}, 'mrk_name',{'DFDR' 'NFDR'});
         
         file2swap=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_' mrkcode_cond{1} '.set']);
         file2preserve=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_' mrkcode_cond{2} '.set']);
        
         EEG2preserve = pop_loadset(file2preserve);      
         EEG2preserve=rmfield(EEG2preserve,'urevent'); 
         pop_saveset( EEG2preserve, 'filename', [subjects_list{subj} pre_epoching_input_file_name '_' mrkcode_cond{2} '.set'], 'filepath', epochs_path);
         
         EEG_swapped = eeglab_subject_swap_electrodes(project_settings, file2swap, file2swap);
         EEG_swapped=rmfield(EEG_swapped,'urevent'); 
        ... pop_saveset(EEG_swapped, 'filename', [subjects_list{subj} pre_epoching_input_file_name 'sw' '.set'], 'filepath', epochs_path);...'_' mrkcode_cond{1} 'sw' '.set'], 'filepath', epochs_path);
         
         ...EEG_merged = pop_mergeset(EEG2preserve, EEG_swapped, 0);
         ...pop_saveset( EEG_merged, 'filename',[subjects_list{subj} pre_epoching_input_file_name '_' condition_names{1} '.set'], 'filepath', epochs_path);
         
     end

    for subj=1:length(subjects_to_swap)
        input_file_name=fullfile(epochs_path, [subjects_to_swap{subj} pre_epoching_input_file_name '.set']);
        output_file_name=fullfile(epochs_path, [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name '.set']);
        eeglab_subject_swap_electrodes(project_settings, input_file_name, output_file_name);
        eeglab_subject_epoching_baseline_remove(project_settings, output_file_name, epochs_path);
        
         file2swap=fullfile(epochs_path, [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name '_' mrkcode_cond{1} '.set']);
         file2preserve=fullfile(epochs_path, [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name '_' mrkcode_cond{2} '.set']);

         EEG2preserve = pop_loadset(file2preserve);      
         EEG2preserve=rmfield(EEG2preserve,'urevent'); 
         pop_saveset( EEG2preserve, 'filename', [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name '_' mrkcode_cond{2} '.set'], 'filepath', epochs_path);

         EEG_swapped = eeglab_subject_swap_electrodes(project_settings, file2swap, file2swap);
         EEG_swapped=rmfield(EEG_swapped,'urevent'); 
        ... pop_saveset(EEG_swapped, 'filename', [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name 'sw' '.set'], 'filepath', epochs_path);...'_' mrkcode_cond{1} 'sw' '.set'], 'filepath', epochs_path);  

         ...EEG_merged = pop_mergeset(EEG2preserve, EEG_swapped, 0);
         ...pop_saveset( EEG_merged, 'filename',[subjects_list{subj} '_sw' pre_epoching_input_file_name '_' condition_names{1} '.set'], 'filepath', epochs_path);         
     end     

end
%==================================================================================
if do_singlesubjects_betaband_comparison
    for subj=1:length(subjects_list)
        %electrode2inspect = electrode_of_interest{subj};
        
        cond1=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_' condition_names{1} '.set']);
        ...cond2=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_' condition_names{2} '.set']);
        ...cond3=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_' condition_names{3} '.set']);
        ...cond4=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_' condition_names{4} '.set']);
        
          eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond1, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
        ... eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond2, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
%         eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond3, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
%         eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond4, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
        ...  eeglab_subject_tf_plot_2conditions(project_settings, cond2, cond1, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project_settings, cond3, cond2, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project_settings, cond3, cond1, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project_settings, cond3, cond4, electrode2inspect, stat_threshold, save_figure, results_path);
    end
end
%==================================================================================
%==================================================================================